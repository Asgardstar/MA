import re
import time
import logging
import json
from typing import List, Dict, Any, Optional
from datetime import datetime
from neo4j import GraphDatabase
from neo4j.exceptions import Neo4jError, ServiceUnavailable
from tqdm import tqdm

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(f'neo4j_upload_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class AdvancedNeo4jBatchUploader:
    def __init__(self, uri: str, username: str, password: str, batch_size: int = 50, retry_attempts: int = 3):
        """Initialize the advanced Neo4j uploader with retry logic"""
        self.uri = uri
        self.username = username
        self.password = password
        self.batch_size = batch_size
        self.retry_attempts = retry_attempts
        self.driver = None
        self.connect()

    def connect(self):
        """Establish connection with retry logic"""
        for attempt in range(self.retry_attempts):
            try:
                self.driver = GraphDatabase.driver(self.uri, auth=(self.username, self.password))
                # Test connection
                with self.driver.session() as session:
                    session.run("RETURN 1")
                logger.info("Successfully connected to Neo4j database")
                return
            except ServiceUnavailable:
                if attempt < self.retry_attempts - 1:
                    wait_time = 2 ** attempt  # Exponential backoff
                    logger.warning(f"Connection attempt {attempt + 1} failed. Retrying in {wait_time} seconds...")
                    time.sleep(wait_time)
                else:
                    logger.error("Failed to connect to Neo4j database after multiple attempts")
                    raise

    def close(self):
        """Close the driver connection"""
        if self.driver:
            self.driver.close()
            logger.info("Neo4j connection closed")

    def parse_cypher_statements(self, cypher_script: str) -> List[str]:
        """Parse the Cypher script into individual statements with improved parsing for fixed format"""
        # Split script into lines and handle comments
        lines = []
        for line in cypher_script.split('\n'):
            # Skip "// Fixed:" comments
            if '// Fixed:' in line:
                continue
            # Remove inline comments
            if '//' in line:
                line = line[:line.index('//')].strip()
            if line.strip():
                lines.append(line.strip())

        statements = []
        i = 0

        while i < len(lines):
            line = lines[i]

            # Handle DELETE statement
            if line.upper().startswith('MATCH') and 'DELETE' in line.upper():
                statements.append(line + ';' if not line.endswith(';') else line)
                i += 1
                continue

            # Handle multi-line MATCH...CREATE statements
            if line.upper().startswith('MATCH'):
                current_statement = [line]
                i += 1

                # Collect subsequent MATCH and CREATE lines
                while i < len(lines):
                    next_line = lines[i]
                    if (next_line.upper().startswith('MATCH') or
                            next_line.upper().startswith('CREATE')):
                        current_statement.append(next_line)
                        # If we found a CREATE line that ends with semicolon, we're done
                        if next_line.upper().startswith('CREATE') and next_line.endswith(';'):
                            break
                    else:
                        # If we find something that's not MATCH or CREATE, we might have an issue
                        break
                    i += 1

                statement = ' '.join(current_statement)
                if not statement.endswith(';'):
                    statement += ';'
                statements.append(statement)
                i += 1
                continue

            # Handle CREATE statements (nodes or simple relationships)
            if line.upper().startswith('CREATE'):
                current_statement = [line]

                # Check if it's a complete single-line statement
                if line.endswith(';') or (line.count('{') == line.count('}') and
                                          line.count('(') == line.count(')')):
                    if not line.endswith(';'):
                        line += ';'
                    statements.append(line)
                    i += 1
                    continue

                # Multi-line CREATE statement
                i += 1
                brace_count = line.count('{') - line.count('}')
                paren_count = line.count('(') - line.count(')')

                while i < len(lines) and (brace_count > 0 or paren_count > 0):
                    next_line = lines[i]
                    current_statement.append(next_line)
                    brace_count += next_line.count('{') - next_line.count('}')
                    paren_count += next_line.count('(') - next_line.count(')')
                    i += 1

                statement = ' '.join(current_statement)
                if not statement.endswith(';'):
                    statement += ';'
                statements.append(statement)
                continue

            # Handle any other statement
            if line:
                if not line.endswith(';'):
                    line += ';'
                statements.append(line)
            i += 1

        logger.info(f"Parsed {len(statements)} statements")
        return statements

    def validate_statement(self, statement: str) -> bool:
        """Validate a Cypher statement before execution"""
        # Basic validation rules
        if not statement.strip():
            return False

        # Check for common syntax issues
        if statement.count('(') != statement.count(')'):
            logger.warning(f"Mismatched parentheses in statement: {statement[:50]}...")
            return False

        if statement.count('[') != statement.count(']'):
            logger.warning(f"Mismatched brackets in statement: {statement[:50]}...")
            return False

        if statement.count('{') != statement.count('}'):
            logger.warning(f"Mismatched braces in statement: {statement[:50]}...")
            return False

        return True

    def execute_with_retry(self, session, statement: str) -> bool:
        """Execute a statement with retry logic"""
        for attempt in range(self.retry_attempts):
            try:
                session.run(statement)
                return True
            except Neo4jError as e:
                if attempt < self.retry_attempts - 1:
                    wait_time = 2 ** attempt
                    logger.warning(f"Attempt {attempt + 1} failed. Retrying in {wait_time} seconds...")
                    time.sleep(wait_time)
                else:
                    logger.error(f"Failed to execute statement after {self.retry_attempts} attempts: {str(e)}")
                    logger.error(f"Statement: {statement}")
                    return False
        return False

    def execute_batch(self, session, statements: List[str], batch_name: str = "") -> Dict[str, Any]:
        """Execute a batch of statements with progress tracking"""
        results = {
            'success': 0,
            'failed': 0,
            'errors': [],
            'failed_statements': []
        }

        with tqdm(total=len(statements), desc=batch_name, unit="stmt") as pbar:
            for i, statement in enumerate(statements, 1):
                if self.validate_statement(statement):
                    if self.execute_with_retry(session, statement):
                        results['success'] += 1
                    else:
                        results['failed'] += 1
                        results['failed_statements'].append(statement)
                        error_msg = f"Statement {i} failed: {statement[:100]}..."
                        results['errors'].append(error_msg)
                else:
                    results['failed'] += 1
                    results['failed_statements'].append(statement)
                    error_msg = f"Invalid statement {i}: {statement[:100]}..."
                    results['errors'].append(error_msg)

                pbar.update(1)

        return results

    def create_indexes(self, session):
        """Create indexes for better performance"""
        index_statements = [
            "CREATE INDEX IF NOT EXISTS FOR (n:functional_requirement) ON (n.name)",
            "CREATE INDEX IF NOT EXISTS FOR (n:performance_requirement) ON (n.name)",
            "CREATE INDEX IF NOT EXISTS FOR (n:ressource_requirement) ON (n.name)",
            "CREATE INDEX IF NOT EXISTS FOR (n:design_requirement) ON (n.name)",
            "CREATE INDEX IF NOT EXISTS FOR (n:solution) ON (n.name)",
            "CREATE INDEX IF NOT EXISTS FOR (n:product) ON (n.name)",
            "CREATE INDEX IF NOT EXISTS FOR (n:function) ON (n.name)",
            "CREATE INDEX IF NOT EXISTS FOR (n:model) ON (n.name)"
        ]

        logger.info("Creating indexes for better performance...")
        for statement in index_statements:
            try:
                session.run(statement)
                logger.info(f"Created index: {statement}")
            except Exception as e:
                logger.warning(f"Failed to create index: {statement}, Error: {str(e)}")

    def upload_cypher_script(self, cypher_script: str, create_backup: bool = True):
        """Upload the Cypher script to Neo4j with enhanced features"""
        start_time = time.time()

        # Create backup if requested
        if create_backup:
            self.create_backup()

        logger.info("Parsing Cypher statements...")
        statements = self.parse_cypher_statements(cypher_script)
        logger.info(f"Found {len(statements)} statements")

        # Group statements by type (updated for new format)
        grouped_statements = self.group_statements_by_type(statements)

        # Results tracking
        total_results = {
            'success': 0,
            'failed': 0,
            'errors': [],
            'failed_statements': []
        }

        with self.driver.session() as session:
            # Create indexes first
            self.create_indexes(session)

            # Process DELETE statements
            if grouped_statements['delete']:
                logger.info("Executing DELETE statements...")
                results = self.execute_batch(session, grouped_statements['delete'], "DELETE")
                self.update_total_results(total_results, results)
                session.run("CALL db.checkpoint()")

            # Process node creation statements
            node_statements = grouped_statements['nodes']
            if node_statements:
                logger.info(f"Executing {len(node_statements)} node creation statements...")
                for i in range(0, len(node_statements), self.batch_size):
                    batch = node_statements[i:i + self.batch_size]
                    batch_name = f"NODES batch {i // self.batch_size + 1}/{(len(node_statements) + self.batch_size - 1) // self.batch_size}"

                    results = self.execute_batch(session, batch, batch_name)
                    self.update_total_results(total_results, results)

                    # Periodic checkpoint
                    if (i + self.batch_size) % (self.batch_size * 5) == 0:
                        session.run("CALL db.checkpoint()")

                    time.sleep(0.2)  # Small delay between batches

            # Process relationship creation statements
            rel_statements = grouped_statements['relationships']
            if rel_statements:
                logger.info(f"Executing {len(rel_statements)} relationship creation statements...")
                for i in range(0, len(rel_statements), self.batch_size):
                    batch = rel_statements[i:i + self.batch_size]
                    batch_name = f"RELATIONSHIPS batch {i // self.batch_size + 1}/{(len(rel_statements) + self.batch_size - 1) // self.batch_size}"

                    results = self.execute_batch(session, batch, batch_name)
                    self.update_total_results(total_results, results)

                    # Periodic checkpoint
                    if (i + self.batch_size) % (self.batch_size * 5) == 0:
                        session.run("CALL db.checkpoint()")

                    time.sleep(0.2)  # Small delay between batches

        # Generate summary report
        end_time = time.time()
        duration = end_time - start_time
        self.generate_summary_report(total_results, duration)

        # Save failed statements to file for review
        if total_results['failed_statements']:
            self.save_failed_statements(total_results['failed_statements'])

        return total_results

    def group_statements_by_type(self, statements: List[str]) -> Dict[str, List[str]]:
        """Group statements by type for better organization (updated for fixed format)"""
        groups = {
            'delete': [],
            'nodes': [],
            'relationships': [],
            'other': []
        }

        for statement in statements:
            statement_upper = statement.upper()

            # Check for DELETE statements
            if 'DELETE' in statement_upper:
                groups['delete'].append(statement)

            # Check for MATCH...MATCH...CREATE relationship pattern
            elif 'MATCH ' in statement_upper and 'CREATE ' in statement_upper and '-[' in statement:
                groups['relationships'].append(statement)

            # Check for simple CREATE relationship pattern
            elif statement_upper.startswith('CREATE (') and ')-[:' in statement:
                groups['relationships'].append(statement)

            # Check for node creation
            elif statement_upper.startswith('CREATE (') and '{' in statement:
                groups['nodes'].append(statement)

            else:
                groups['other'].append(statement)

        # Log statement distribution
        logger.info(f"Statement distribution - Nodes: {len(groups['nodes'])}, "
                    f"Relationships: {len(groups['relationships'])}, "
                    f"Delete: {len(groups['delete'])}, "
                    f"Other: {len(groups['other'])}")

        return groups

    def update_total_results(self, total_results: Dict, batch_results: Dict):
        """Update total results with batch results"""
        total_results['success'] += batch_results['success']
        total_results['failed'] += batch_results['failed']
        total_results['errors'].extend(batch_results['errors'])
        total_results['failed_statements'].extend(batch_results['failed_statements'])

    def create_backup(self):
        """Create a backup of the current database state"""
        logger.info("Creating database backup...")
        try:
            with self.driver.session() as session:
                # Try to export using APOC (if available)
                try:
                    result = session.run("CALL apoc.export.json.all(null, {stream: true})")
                    row = result.single()
                    if row and row[0]:
                        backup_data = row[0]
                        backup_file = f'neo4j_backup_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json'
                        with open(backup_file, 'w') as f:
                            f.write(backup_data)
                        logger.info(f"Backup created: {backup_file}")
                        return
                except Exception:
                    logger.info("APOC not available, using basic backup method...")

                # Alternative backup method without APOC
                result = session.run("""
                    MATCH (n)
                    OPTIONAL MATCH (n)-[r]->(m)
                    RETURN n, collect(r) as relationships, collect(m) as connected_nodes
                """)

                backup_data = []
                for record in result:
                    node_data = dict(record['n'])
                    backup_data.append({
                        'node': node_data,
                        'labels': list(record['n'].labels),
                        'relationships': [
                            {
                                'type': r.type,
                                'properties': dict(r),
                                'end_node': dict(m)
                            }
                            for r, m in zip(record['relationships'], record['connected_nodes'])
                            if r is not None
                        ]
                    })

                backup_file = f'neo4j_backup_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json'
                with open(backup_file, 'w') as f:
                    json.dump(backup_data, f, indent=2)

                logger.info(f"Basic backup created: {backup_file}")

        except Exception as e:
            logger.warning(f"Failed to create backup: {str(e)}")

    def generate_summary_report(self, results: Dict, duration: float):
        """Generate a detailed summary report"""
        report = f"""
=== Neo4j Upload Summary Report ===
Time taken: {duration:.2f} seconds
Total statements processed: {results['success'] + results['failed']}
Successful: {results['success']}
Failed: {results['failed']}
Success rate: {(results['success'] / (results['success'] + results['failed']) * 100):.2f}%

"""
        if results['errors']:
            report += "=== Errors ===\n"
            for error in results['errors'][:10]:  # Show first 10 errors
                report += f"{error}\n"

            if len(results['errors']) > 10:
                report += f"... and {len(results['errors']) - 10} more errors\n"

        logger.info(report)

        # Save report to file
        report_file = f'neo4j_upload_report_{datetime.now().strftime("%Y%m%d_%H%M%S")}.txt'
        with open(report_file, 'w') as f:
            f.write(report)

        logger.info(f"Detailed report saved to: {report_file}")

    def save_failed_statements(self, failed_statements: List[str]):
        """Save failed statements to a file for review"""
        filename = f'failed_statements_{datetime.now().strftime("%Y%m%d_%H%M%S")}.cypher'
        with open(filename, 'w') as f:
            for statement in failed_statements:
                f.write(f"{statement}\n\n")

        logger.info(f"Failed statements saved to: {filename}")


# Example usage
if __name__ == "__main__":
    # Configuration
    NEO4J_URI = "bolt://localhost:7687"  # Update with your URI
    NEO4J_USERNAME = "neo4j"  # Update with your username
    NEO4J_PASSWORD = "Moni8913bca3"  # Update with your password
    BATCH_SIZE = 50
    RETRY_ATTEMPTS = 3

    # Read the Cypher script from file
    try:
        with open('bev_cypher_script_fixed.cypher', 'r', encoding='utf-8') as file:
            cypher_script = file.read()
    except FileNotFoundError:
        logger.error("Cypher script file not found. Please ensure 'bev_cypher_script_fixed.cypher' exists.")
        exit(1)

    # Create uploader instance
    uploader = AdvancedNeo4jBatchUploader(
        NEO4J_URI,
        NEO4J_USERNAME,
        NEO4J_PASSWORD,
        batch_size=BATCH_SIZE,
        retry_attempts=RETRY_ATTEMPTS
    )

    try:
        # Upload the script with backup
        uploader.upload_cypher_script(cypher_script, create_backup=True)
    except Exception as e:
        logger.error(f"Upload failed: {str(e)}")
    finally:
        # Close the connection
        uploader.close()