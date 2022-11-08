## 0.1.9

- `term.dart`: update `isValidUri` to static method
- `graph.dart`: add support for reading different forms in subject/predicate/object to full URIRef form
  - Case 1: `<valid_uri>` => `URIRef(valid_uri)`
  - Case 2: `<invalid_uri>` => (there should be a default base to interpret this invalid uri) `URIRef(base_uri+invalid_uri)`
  - Case 3: `a:b` => `URIRef(context[a]+b)`
  - Case 4: `:a` => (there should be a shorthand prefix `:` in namespace prefix section) `URIRef(shorthand_uri+a)`

## 0.1.8

- `graph.dart`: add support for parsing and writing `@base` and `@prefix :` in namespace prefixes section
- `constants.dart`: create constants in this file to be imported to other files if necessary

## 0.1.7

- `graph.dart`: add function in `Graph` to parse a whole text string in additional to a file.
- Add a corresponding example for parsing full text string.

## 0.1.6

- `graph.dart`: fix issue of encryption/decryption by using a different key
    - `sha256` is for quick verification of hashed passphrase
    - `sha512` is for encryption/decryption

## 0.1.5

- `graph.dart`: adding optional decryption for the encrypted `ttl` file
    - Note the encrypted file must contain a hashed key triple (for quick verification of password)
      and the encrypted data triple
    - `sha256` is used for hashing and verifying the password
    - `AES` is the only supported decryption now (depends
      on [`encrypt`](https://pub.dev/packages/encrypt))

## 0.1.4

- `graph.dart`: adding optional encryption when serializing graph data to `ttl` file.
    - `AES` is the default encryption
    - `sha256` is used for generating hashed passphrase
    - new encrypted file will still be a valid `ttl` file with original contents encrypted in one
      triple

## 0.1.3

Adding acknowledgement for [RDFLib](https://rdflib.readthedocs.io/)

Adding examples for reading and writing a full `ttl` file, check it out in the `example/` folder!

- `graph.dart`:
    - fixing bugs in reading lines ending with `.`, `,` and `;`
    - [partly] fixing prefix lines starting with ':' and '@base'
    - fixing bugs in reading single numeric values (with no specified datatypes)

## 0.1.2

Updating description and GitHub repository.

## 0.1.1

Renaming `rdfgraph` to `rdflib`. (GitHub repository stays the same)

## 0.1.0

- `graph.dart`: supporting reading local turtle file into a `Graph` instance in memory
- updating `example/rdfgraph_example3.dart` to demonstrate parsing local `ttl` file

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