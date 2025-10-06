from dotenv import load_dotenv
import os
import re
from neo4j import GraphDatabase
 
load_dotenv()
 
 
class Neo4jPublisher:
    def __init__(self):
        self.driver = GraphDatabase.driver(
            os.getenv("NEO4J_URL"),
            auth=(os.getenv("NEO4J_ADMIN_USERNAME"), os.getenv("NEO4J_ADMIN_PASSWORD"))
        )
 
    def close(self):
        self.driver.close()
 
    def clear_database(self):
        with self.driver.session() as session:
            session.run("MATCH (n) DETACH DELETE n")
 
    def read_cypher_file(self, filename):
        with open(filename, 'r', encoding='utf-8') as file:
            content = file.read()
        return [stmt.strip() for stmt in re.split(r';\s*\n', content) if stmt.strip()]
 
    def categorize_statements(self, statements):
        creates = []
        matches = []
 
        for stmt in statements:
            if stmt.upper().startswith('CREATE ('):
                creates.append(stmt)
            elif stmt.upper().startswith('OPTIONAL MATCH'):
                matches.append(stmt)
 
        return creates, matches
 
    def execute_statements(self, statements):
        with self.driver.session() as session:
            for stmt in statements:
                session.run(stmt)
 
    def publish(self, filename):
        self.clear_database()
        statements = self.read_cypher_file(filename)
        creates, matches = self.categorize_statements(statements)
 
        self.execute_statements(creates)
        self.execute_statements(matches)
 
 
def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    cypher_file = os.path.join(script_dir, "bev.cypher")
    publisher = Neo4jPublisher()
    try:
        publisher.publish(filename=cypher_file)
    finally:
        publisher.close()
 
 
if __name__ == "__main__":
    main()