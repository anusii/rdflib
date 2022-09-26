# RDFLib

> A pure Dart package for working with RDF (resource description framework).

## Features

- Create triple instances (with data types)
- Create a graph to store triples without duplicates
- Find triples based on criteria
- Export graph to turtle `ttl` format (default)
- Bind long namespace with customized shortened name for readability
- Include [reserved vocabulary](https://www.w3.org/TR/owl-syntax/#IRIs) of OWL 2
- Parse local turtle `ttl` file and store triples in the graph in memory

## Getting started

Refer to the code example below, or go to `/example` to find out more!

### For testing the `rdflib` package

```bash
# create a dart project for testing
dart create test_rdflib
cd test_rdflib
# install rdflib as the dependency with dart pub add
dart pub add rdflib
# copy the following code to /bin/test_rdflib.dart
# run the file with dart
dart run
```

## Usage

Head over to our GitHub repo to check out
more [examples](https://github.com/anusii/rdfgraph/tree/main/example)!

### 1. General usage

The following code snippet shows how to:

1. Create a `Graph` instance;
2. Create and store `triple`s with different data types;
3. Find entities based on customized criteria;
4. Bind shorted string to long `namespace`;
5. Export graph data to turtle file;

```dart
import 'dart:io';
import 'package:rdflib/rdflib.dart';

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

### 2. [SOLID Health Ontology Example](https://github.com/anusii/pods/blob/main/datasets/turtle-data/SOLID-Health-Ontology-Example%20-%20(data).ttl)

```dart
import '../lib/rdflib.dart';

main() {
  Graph g = Graph();

  Namespace shData = Namespace(ns: 'http://silo.net.au/data/SOLID-Health#');
  Namespace shOnto =
  Namespace(ns: 'http://sii.cecs.anu.edu.au/onto/SOLID-Health#');

  URIRef newAssessTab = shData.withAttr('AssessmentTab-p43623-20220727T120913');
  g.addNamedIndividual(newAssessTab);

  // Literal string
  g.add(Triple(
      sub: newAssessTab, pre: RDF.type, obj: shOnto.withAttr('AssessmentTab')));

  // Literal string
  g.add(Triple(
      sub: newAssessTab,
      pre: shOnto.withAttr('asthmaControl'),
      obj: Literal('Poor Control')));

  // Literal integer
  g.add(Triple(
      sub: newAssessTab,
      pre: shOnto.withAttr('diastolicBloodPressure'),
      obj: Literal('75')));

  // Literal float/double
  g.add(Triple(
      sub: newAssessTab,
      pre: shOnto.withAttr('systolicBloodPressure'),
      obj: Literal('125.0')));

  URIRef newSeeAndDoTab = shData.withAttr('SeeAndDoTab-p43623-20220727T120913');
  URIRef newSeeAndDoOption =
  shData.withAttr('SeeAndDoOption-p43623-20220727T120913-fitnessDrive');

  g.addNamedIndividual(newSeeAndDoTab);
  g.addNamedIndividual(newSeeAndDoOption);
  // link two triple individuals
  g.addObjectProperty(
      newSeeAndDoTab, shOnto.withAttr('hasSeeAndDoOption'), newSeeAndDoOption);

  /// binding for readability
  g.bind('sh-data', shData);
  g.bind('sh-onto', shOnto);

  g.serialize(dest: 'example/ex2.ttl');
}
```

### 3. Parsing local turtle file

```dart
import 'package:rdflib/rdflib.dart';

main() async {
  String filePath = 'example/ex1.ttl';
  // create a graph to read turtle file and store info
  Graph g = Graph();
  // wait for it to complete parsing
  await g.parse(filePath);
  // full format of triples (will use shorthand in serialization/export)
  for (Triple t in g.triples) {
    print(t);
  }
  // export it to a new file (should be equivalent to the original one)
  g.serialize(format: 'ttl', dest: 'example/ex3.ttl');
}
```

## Additional information

### Useful resources

1. [RDFLib](https://github.com/RDFLib/rdflib)
2. [Introduction to RDF](https://www.w3.org/TR/rdf11-primer/)

### How to contribute

Make a pull request on our GitHub [repo](https://github.com/anusii/rdfgraph)!

## Acknowledgement
This `rdflib` dart package is modelled on the [RDFLib](https://rdflib.readthedocs.io/).