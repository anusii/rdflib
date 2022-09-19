# RDFGraph

> We're trying to create a tool for organizing RDF data efficiently in dart.

## Features

- Create triple instances (with data types)
- Create a graph to store triples without duplicates
- Find triples based on criteria
- Export graph to turtle `ttl` format (default)
- Bind long namespace with customized shortened name for readability
- Include [reserved vocabulary](https://www.w3.org/TR/owl-syntax/#IRIs) of OWL 2

## Getting started

Refer to the code example below, or go to `/example` to find out more!

### For testing the `rdfgraph` package

```bash
# create a dart project for testing
dart create test_rdfgraph
cd test_rdfgraph
# install rdfgraph as the dependency with dart pub add
dart pub add rdfgraph
# copy the following code to /bin/test_rdfgraph.dart
# run the file with dart
dart run
```

## Usage

The following code snippet shows how to:

1. Create a `Graph` instance;
2. Create and store `triple`s with different data types;
3. Find entities based on customized criteria;
4. Bind shorted string to long `namespace`;
5. Export graph data to turtle file;

```dart
import 'dart:io';
import 'package:rdfgraph/rdfgraph.dart';

main() async {
  Graph g = Graph();

  URIRef example = URIRef.fullUri('http://example.org');

  // subject and predicate should be a valid URIRef instance
  URIRef donna = example.slash('donna');

  g.add(Triple(sub: donna, pre: RDF.type, obj: FOAF.Person));

  // add duplicated record
  g.add(Triple(sub: donna, pre: RDF.type, obj: FOAF.Person));
  g.add(Triple(sub: donna, pre: FOAF.nick, obj: Literal('donna', lang: 'en')));
  g.add(Triple(sub: donna, pre: FOAF.name, obj: Literal('Donna Fales')));

  // add duplicated record
  g.add(Triple(sub: donna, pre: FOAF.name, obj: Literal('Donna Fales')));
  g.add(Triple(
      sub: donna,
      pre: FOAF.mbox,
      obj: URIRef.fullUri('mailto:donna@example.org')));

  // add another in the graph
  URIRef ed = example.slash('edward');
  g.add(Triple(sub: ed, pre: RDF.type, obj: FOAF.Person));
  g.add(Triple(
      sub: ed, pre: FOAF.nick, obj: Literal('ed', datatype: XSD.string)));
  g.add(Triple(sub: ed, pre: FOAF.name, obj: 'Edward Scissorhands'));
  g.add(Triple(
      sub: ed,
      pre: FOAF.mbox,
      obj: Literal('e.scissorhands@example.org', datatype: XSD.anyURI)));

  // TEST triples should print correctly
  print('-' * 30);
  for (Triple t in g.triples) {
    // duplicated records will not be added and printed out
    print(t);
  }

  print('-' * 30);

  // TEST correct subjects/objects should print out
  for (URIRef s in g.subjects(RDF.type, FOAF.Person)) {
    for (var o in g.objects(s, FOAF.mbox)) {
      // should print out URIRef(mailto:donna@example.org) and
      // Literal(e.scissorhands@example.org, datatype: URIRef(http://www.w3.org/2001/XMLSchema#anyURI))
      print(o);
    }
  }

  // bind 'foaf' to FOAF for easy readout
  g.bind('foaf', FOAF(ns: FOAF.foaf));

  /// uncomment the following line to test binding a customized namespace
  /// g.bind('example', Namespace(ns: 'http://example.org/'));

  // export graph to turtle format, create directory if it doesn't exist
  String currentPath = Directory.current.path;
  String examplePath = '$currentPath/example';
  if (!await Directory(examplePath).exists()) {
    await Directory(examplePath).create(recursive: true);
  }
  g.serialize(format: 'ttl', dest: '$examplePath/ex1.ttl');
}
```

## Additional information

### Useful resources

1. [RDFLib](https://github.com/RDFLib/rdflib)
2. [Introduction to RDF](https://www.w3.org/TR/rdf11-primer/)

### How to contribute

Make a pull request on our GitHub [repo](https://github.com/anusii/rdfgraph)!
