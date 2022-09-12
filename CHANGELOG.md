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