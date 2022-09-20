## 0.0.11

- `graph.dart`: adding function `addObjectProperty()` to link two named triple individuals together
- updating `example/rdfgraph_example2.dart` to demonstrate linking triples

## 0.0.10

- `term.dart`: `Literal` default constructor can parse integer, float/double, and date time strings
  with corresponding `XSD` types
- `graph.dart`: adding named individual
- Adding
  derived [SOLID Health Ontology Example](https://github.com/anusii/pods/blob/main/datasets/turtle-data/SOLID-Health-Ontology-Example%20-%20(data).ttl)
  examples for demonstration
- Updating `README.md` to include new examples

## 0.0.9

Updating pub.dev page sidebar homepage link to new ANUSII GitHub repository.

## 0.0.8

- `namespace.dart`: adding default namespaces (e.g., `RDF`, `RDFS`, `OWL`, and `XSD` ) with reserved
  vocabulary of OWL 2 including special treatment, refer
  to [this link](https://www.w3.org/TR/owl-syntax/#IRIs) for more details
- `triple.dart`: converting single string value in object to a `Literal` instance with
  datatype `xsd:string`
- `term.dart`:
    - refactoring constructor to accept full URI
    - updating base address later if need be
    - adding `Literal` class with data type and language options for more specific object
      description
- `graph.dart`:
    - updating contexts when adding triples with different types
    - serializing prefixes based on contexts

## 0.0.7

Improve `serialize()` by shortening full `URIRef` instance to the bound namespace name.

## 0.0.6

Update `Graph` class:

- add `bind()` method to bind string to a namespace for code readability
- add `serialize()` method to export the graph to `turtle` format file.

Update documentation based on dart
guide [here](https://dart.dev/guides/language/effective-dart/documentation)

## 0.0.5

Move example code to the top `example/` folder.

## 0.0.4

Add methods to find subjects and objects based on the criteria in the graph.

Update package description with what it can do currently.

Add example file in `example/` folder.

Tidy up unused imports.

## 0.0.3

Add examples, refer to README.

- Namespace
    - add RDF and FOAF (incomplete lists)
- URIRef
    - add comments
    - update methods
- Triple
    - update method

## 0.0.2

Add the following simple naive classes:

- Graph
- Namespace
- URIRef
- Triple

Functionalities in creating the graph:

- add triple to the graph
    - this will not add duplicates because a set structure is used to store the triples

## 0.0.1

Take baby steps in creating RDFGraph package.