
# Template for Cypher generation with semantic search results
CYPHER_GENERATION_TEMPLATE = """
Your goal is to answer the user question. Therefore you need to write a Cypher statement to get the relevant
information.

Here is the question:
{query}

Here is the semantic result that extracted the most similiar nodes to the users question:
{semantic_results}

Use the graph schema to formulate the Cypher statement.
{schema}

Here are the Cypher Statements you can choose from. 

IMPORTANT: You must replace ANY_NAME with an actual name from the semantic results if applicable. 

```cypher
# FUNCTION RELATED QUERIES

01. To find all functional requirements that functions must satisfy
    MATCH (f:function)-[:MUST_SATISFY]->(fr:functional_requirement)
    RETURN f.name AS entity1_name, f.description AS entity1_desc, fr.name AS entity2_name, fr.description AS entity2_desc

02. To find all functional requirements that a specific function must satisfy
    MATCH (f:function {{name: "ANY_NAME"}})-[:MUST_SATISFY]->(fr:functional_requirement)
    RETURN f.name AS entity1_name, f.description AS entity1_desc, fr.name AS entity2_name, fr.description AS entity2_desc

03. To find all inputs to functions
    MATCH (f:function)-[:HAS_INPUT]->(fi:function_input)
    RETURN f.name AS entity1_name, f.description AS entity1_desc, fi.name AS entity2_name, fi.description AS entity2_desc

04. To find all inputs to a specific function
    MATCH (f:function {{name: "ANY_NAME"}})-[:HAS_INPUT]->(fi:function_input)
    RETURN f.name AS entity1_name, f.description AS entity1_desc, fi.name AS entity2_name, fi.description AS entity2_desc

05. To find all outputs from functions
    MATCH (f:function)-[:HAS_OUTPUT]->(fo:function_output)
    RETURN f.name AS entity1_name, f.description AS entity1_desc, fo.name AS entity2_name, fo.description AS entity2_desc

06. To find all outputs from a specific function
    MATCH (f:function {{name: "ANY_NAME"}})-[:HAS_OUTPUT]->(fo:function_output)
    RETURN f.name AS entity1_name, f.description AS entity1_desc, fo.name AS entity2_name, fo.description AS entity2_desc

# SOLUTION RELATED QUERIES

07. To find all performance requirements that solutions must satisfy
    MATCH (s:solution)-[:MUST_SATISFY]->(pr:performance_requirement)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, pr.name AS entity2_name, pr.description AS entity2_desc

08. To find all performance requirements that a specific solution must satisfy
    MATCH (s:solution {{name: "ANY_NAME"}})-[:MUST_SATISFY]->(pr:performance_requirement)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, pr.name AS entity2_name, pr.description AS entity2_desc

09. To find all resource requirements that solutions must satisfy
    MATCH (s:solution)-[:MUST_SATISFY]->(rr:ressource_requirement)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, rr.name AS entity2_name, rr.description AS entity2_desc

10. To find all resource requirements that a specific solution must satisfy
    MATCH (s:solution {{name: "ANY_NAME"}})-[:MUST_SATISFY]->(rr:ressource_requirement)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, rr.name AS entity2_name, rr.description AS entity2_desc

11. To find all functions that solutions perform
    MATCH (s:solution)-[:PERFORMS]->(f:function)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, f.name AS entity2_name, f.description AS entity2_desc

12. To find all functions that a specific solution performs
    MATCH (s:solution {{name: "ANY_NAME"}})-[:PERFORMS]->(f:function)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, f.name AS entity2_name, f.description AS entity2_desc

13. To find all functional requirements satisfied by functions that solutions perform
    MATCH (s:solution)-[:PERFORMS]->(f:function)-[:MUST_SATISFY]->(fr:functional_requirement)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, f.name AS entity2_name, f.description AS entity2_desc, fr.name AS entity3_name, fr.description AS entity3_desc

14. To find all functional requirements satisfied by functions that a specific solution performs
    MATCH (s:solution {{name: "ANY_NAME"}})-[:PERFORMS]->(f:function)-[:MUST_SATISFY]->(fr:functional_requirement)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, f.name AS entity2_name, f.description AS entity2_desc, fr.name AS entity3_name, fr.description AS entity3_desc

15. To find all inputs to functions that solutions perform
    MATCH (s:solution)-[:PERFORMS]->(f:function)-[:HAS_INPUT]->(fi:function_input)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, f.name AS entity2_name, f.description AS entity2_desc, fi.name AS entity3_name, fi.description AS entity3_desc

16. To find all inputs to functions that a specific solution performs
    MATCH (s:solution {{name: "ANY_NAME"}})-[:PERFORMS]->(f:function)-[:HAS_INPUT]->(fi:function_input)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, f.name AS entity2_name, f.description AS entity2_desc, fi.name AS entity3_name, fi.description AS entity3_desc

17. To find all outputs from functions that solutions perform
    MATCH (s:solution)-[:PERFORMS]->(f:function)-[:HAS_OUTPUT]->(fo:function_output)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, f.name AS entity2_name, f.description AS entity2_desc, fo.name AS entity3_name, fo.description AS entity3_desc

18. To find all outputs from functions that a specific solution performs
    MATCH (s:solution {{name: "ANY_NAME"}})-[:PERFORMS]->(f:function)-[:HAS_OUTPUT]->(fo:function_output)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, f.name AS entity2_name, f.description AS entity2_desc, fo.name AS entity3_name, fo.description AS entity3_desc

# MODEL RELATED QUERIES

19. To find all models associated with solutions
    MATCH (s:solution)-[:HAS_MODEL]->(m:model)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, m.name AS entity2_name, m.description AS entity2_desc

20. To find all models associated with a specific solution
    MATCH (s:solution {{name: "ANY_NAME"}})-[:HAS_MODEL]->(m:model)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, m.name AS entity2_name, m.description AS entity2_desc

21. To find all inputs to models associated with solutions
    MATCH (s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, m.name AS entity2_name, m.description AS entity2_desc, mi.name AS entity3_name, mi.description AS entity3_desc

22. To find all inputs to models associated with a specific solution
    MATCH (s:solution {{name: "ANY_NAME"}})-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, m.name AS entity2_name, m.description AS entity2_desc, mi.name AS entity3_name, mi.description AS entity3_desc

23. To find all outputs from models associated with solutions
    MATCH (s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_OUTPUT]->(mo:model_output)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, m.name AS entity2_name, m.description AS entity2_desc, mo.name AS entity3_name, mo.description AS entity3_desc

24. To find all outputs from models associated with a specific solution
    MATCH (s:solution {{name: "ANY_NAME"}})-[:HAS_MODEL]->(m:model)-[:HAS_OUTPUT]->(mo:model_output)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, m.name AS entity2_name, m.description AS entity2_desc, mo.name AS entity3_name, mo.description AS entity3_desc

25. To find all attributes that are equal to model inputs in solutions model
    MATCH (s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, m.name AS entity2_name, m.description AS entity2_desc, mi.name AS entity3_name, mi.description AS entity3_desc, a.name AS entity4_name, a.description AS entity4_desc

26. To find all attributes that are equal to model inputs in a specific solution's model
    MATCH (s:solution {{name: "ANY_NAME"}})-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)
    RETURN s.name AS entity1_name, s.description AS entity1_desc, m.name AS entity2_name, m.description AS entity2_desc, mi.name AS entity3_name, mi.description AS entity3_desc, a.name AS entity4_name, a.description AS entity4_desc

27. To find all inputs to models
    MATCH (m:model)-[:HAS_INPUT]->(mi:model_input)
    RETURN m.name AS entity1_name, m.description AS entity1_desc, mi.name AS entity2_name, mi.description AS entity2_desc

28. To find all inputs to a specific model
    MATCH (m:model {{name: "ANY_NAME"}})-[:HAS_INPUT]->(mi:model_input)
    RETURN m.name AS entity1_name, m.description AS entity1_desc, mi.name AS entity2_name, mi.description AS entity2_desc

29. To find all attributes connected to models inputs
    MATCH (m:model)-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)
    RETURN m.name AS entity1_name, m.description AS entity1_desc, mi.name AS entity2_name, mi.description AS entity2_desc, a.name AS entity3_name, a.description AS entity3_desc

30. To find all attributes connected to a specific model's inputs
    MATCH (m:model {{name: "ANY_NAME"}})-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)
    RETURN m.name AS entity1_name, m.description AS entity1_desc, mi.name AS entity2_name, mi.description AS entity2_desc, a.name AS entity3_name, a.description AS entity3_desc

31. To find model outputs connected to attributes that are equal to models inputs
    MATCH (m:model)-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)-[:EQUALS]->(mo:model_output)
    RETURN m.name AS entity1_name, m.description AS entity1_desc, mi.name AS entity2_name, mi.description AS entity2_desc, a.name AS entity3_name, a.description AS entity3_desc, mo.name AS entity4_name, mo.description AS entity4_desc

32. To find model outputs connected to attributes that are equal to a specific model's inputs
    MATCH (m:model {{name: "ANY_NAME"}})-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)-[:EQUALS]->(mo:model_output)
    RETURN m.name AS entity1_name, m.description AS entity1_desc, mi.name AS entity2_name, mi.description AS entity2_desc, a.name AS entity3_name, a.description AS entity3_desc, mo.name AS entity4_name, mo.description AS entity4_desc

33. To find all outputs from models
    MATCH (m:model)-[:HAS_OUTPUT]->(mo:model_output)
    RETURN m.name AS entity1_name, m.description AS entity1_desc, mo.name AS entity2_name, mo.description AS entity2_desc

34. To find all outputs from a specific model
    MATCH (m:model {{name: "ANY_NAME"}})-[:HAS_OUTPUT]->(mo:model_output)
    RETURN m.name AS entity1_name, m.description AS entity1_desc, mo.name AS entity2_name, mo.description AS entity2_desc

35. To find all attributes equal to models input
    MATCH (mi:model_input)-[:EQUALS]->(a:attribute)
    RETURN mi.name AS entity1_name, mi.description AS entity1_desc, a.name AS entity2_name, a.description AS entity2_desc

36. To find all attributes equal to a specific model input
    MATCH (mi:model_input {{name: "ANY_NAME"}})-[:EQUALS]->(a:attribute)
    RETURN mi.name AS entity1_name, mi.description AS entity1_desc, a.name AS entity2_name, a.description AS entity2_desc

37. To find all model outputs equal to attributes connected to models inputs
    MATCH (mi:model_input)-[:EQUALS]->(a:attribute)-[:EQUALS]->(mo:model_output)
    RETURN mi.name AS entity1_name, mi.description AS entity1_desc, a.name AS entity2_name, a.description AS entity2_desc, mo.name AS entity3_name, mo.description AS entity3_desc

38. To find all model outputs equal to attributes connected to a specific model input
    MATCH (mi:model_input {{name: "ANY_NAME"}})-[:EQUALS]->(a:attribute)-[:EQUALS]->(mo:model_output)
    RETURN mi.name AS entity1_name, mi.description AS entity1_desc, a.name AS entity2_name, a.description AS entity2_desc, mo.name AS entity3_name, mo.description AS entity3_desc

# PRODUCT RELATED QUERIES

41. To find all design requirements that products must satisfy
    MATCH (p:product)-[:MUST_SATISFY]->(dr:design_requirement)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, dr.name AS entity2_name, dr.description AS entity2_desc

42. To find all design requirements that a specific product must satisfy
    MATCH (p:product {{name: "ANY_NAME"}})-[:MUST_SATISFY]->(dr:design_requirement)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, dr.name AS entity2_name, dr.description AS entity2_desc

43. To find all solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc

44. To find all subproducts of a product
    MATCH (p:product)-[:IS_COMPOSED_OF]->(sp:product)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, sp.name AS entity2_name, sp.description AS entity2_desc

45. To find all solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc

46. To find all performance requirements satisfied by solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:MUST_SATISFY]->(pr:performance_requirement)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, pr.name AS entity3_name, pr.description AS entity3_desc

47. To find all performance requirements satisfied by solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:MUST_SATISFY]->(pr:performance_requirement)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, pr.name AS entity3_name, pr.description AS entity3_desc

48. To find all resource requirements satisfied by solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:MUST_SATISFY]->(rr:ressource_requirement)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, rr.name AS entity3_name, rr.description AS entity3_desc

49. To find all resource requirements satisfied by solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:MUST_SATISFY]->(rr:ressource_requirement)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, rr.name AS entity3_name, rr.description AS entity3_desc

50. To find all functions performed by solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:PERFORMS]->(f:function)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, f.name AS entity3_name, f.description AS entity3_desc

51. To find all functions performed by solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:PERFORMS]->(f:function)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, f.name AS entity3_name, f.description AS entity3_desc

52. To find all functional requirements satisfied by functions of solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:PERFORMS]->(f:function)-[:MUST_SATISFY]->(fr:functional_requirement)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, f.name AS entity3_name, f.description AS entity3_desc, fr.name AS entity4_name, fr.description AS entity4_desc

53. To find all functional requirements satisfied by functions of solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:PERFORMS]->(f:function)-[:MUST_SATISFY]->(fr:functional_requirement)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, f.name AS entity3_name, f.description AS entity3_desc, fr.name AS entity4_name, fr.description AS entity4_desc

54. To find all inputs to functions of solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:PERFORMS]->(f:function)-[:HAS_INPUT]->(fi:function_input)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, f.name AS entity3_name, f.description AS entity3_desc, fi.name AS entity4_name, fi.description AS entity4_desc

55. To find all inputs to functions of solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:PERFORMS]->(f:function)-[:HAS_INPUT]->(fi:function_input)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, f.name AS entity3_name, f.description AS entity3_desc, fi.name AS entity4_name, fi.description AS entity4_desc

56. To find all outputs from functions of solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:PERFORMS]->(f:function)-[:HAS_OUTPUT]->(fo:function_output)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, f.name AS entity3_name, f.description AS entity3_desc, fo.name AS entity4_name, fo.description AS entity4_desc

57. To find all outputs from functions of solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:PERFORMS]->(f:function)-[:HAS_OUTPUT]->(fo:function_output)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, f.name AS entity3_name, f.description AS entity3_desc, fo.name AS entity4_name, fo.description AS entity4_desc

# PRODUCT-MODEL RELATED QUERIES

58. To find all models associated with solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc

59. To find all models associated with solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc

60. To find all inputs to models associated with solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc, mi.name AS entity4_name, mi.description AS entity4_desc

61. To find all inputs to models associated with solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc, mi.name AS entity4_name, mi.description AS entity4_desc

62. To find all attributes equal to model inputs in solutions realized by products
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc, mi.name AS entity4_name, mi.description AS entity4_desc, a.name AS entity5_name, a.description AS entity5_desc

63. To find all attributes equal to model inputs in solutions realized by a specific product
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc, mi.name AS entity4_name, mi.description AS entity4_desc, a.name AS entity5_name, a.description AS entity5_desc

64. To find connected model outputs through attributes for solutions realized by products
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)-[:EQUALS]->(mo:model_output)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc, mi.name AS entity4_name, mi.description AS entity4_desc, a.name AS entity5_name, a.description AS entity5_desc, mo.name AS entity6_name, mo.description AS entity6_desc

65. To find connected model outputs through attributes for solutions realized by a specific product
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_INPUT]->(mi:model_input)-[:EQUALS]->(a:attribute)-[:EQUALS]->(mo:model_output)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc, mi.name AS entity4_name, mi.description AS entity4_desc, a.name AS entity5_name, a.description AS entity5_desc, mo.name AS entity6_name, mo.description AS entity6_desc

66. To find all outputs from models associated with solutions that products realize
    MATCH (p:product)-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_OUTPUT]->(mo:model_output)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc, mo.name AS entity4_name, mo.description AS entity4_desc

67. To find all outputs from models associated with solutions that a specific product realizes
    MATCH (p:product {{name: "ANY_NAME"}})-[:REALIZES]->(s:solution)-[:HAS_MODEL]->(m:model)-[:HAS_OUTPUT]->(mo:model_output)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, s.name AS entity2_name, s.description AS entity2_desc, m.name AS entity3_name, m.description AS entity3_desc, mo.name AS entity4_name, mo.description AS entity4_desc

# ATTRIBUTE RELATED QUERIES

68. To find all attributes of products
    MATCH (p:product)-[:HAS_ATTRIBUTE]->(a:attribute)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, a.name AS entity2_name, a.description AS entity2_desc

69. To find all attributes of a specific product
    MATCH (p:product {{name: "ANY_NAME"}})-[:HAS_ATTRIBUTE]->(a:attribute)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, a.name AS entity2_name, a.description AS entity2_desc

70. To find all model outputs equal to attributes of product
    MATCH (p:product)-[:HAS_ATTRIBUTE]->(a:attribute)-[:EQUALS]->(mo:model_output)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, a.name AS entity2_name, a.description AS entity2_desc, mo.name AS entity3_name, mo.description AS entity3_desc

71. To find all model outputs equal to attributes of a specific product
    MATCH (p:product {{name: "ANY_NAME"}})-[:HAS_ATTRIBUTE]->(a:attribute)-[:EQUALS]->(mo:model_output)
    RETURN p.name AS entity1_name, p.description AS entity1_desc, a.name AS entity2_name, a.description AS entity2_desc, mo.name AS entity3_name, mo.description AS entity3_desc

72. To find all model outputs equal to attributes
    MATCH (a:attribute)-[:EQUALS]->(mo:model_output)
    RETURN a.name AS entity1_name, a.description AS entity1_desc, mo.name AS entity2_name, mo.description AS entity2_desc

73. To find all model outputs equal to a specific attribute
    MATCH (a:attribute {{name: "ANY_NAME"}})-[:EQUALS]->(mo:model_output)
    RETURN a.name AS entity1_name, a.description AS entity1_desc, mo.name AS entity2_name, mo.description AS entity2_desc
```
"""
