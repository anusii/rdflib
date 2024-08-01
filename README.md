# RDFLib

[![Pub Package](https://img.shields.io/pub/v/rdflib)](https://pub.dev/packages/rdflib)
[![GitHub Issues](https://img.shields.io/github/issues/anusii/rdflib)](https://github.com/anusii/rdflib/issues)
[![GitHub License](https://img.shields.io/github/license/anusii/rdflib)](https://raw.githubusercontent.com/anusii/rdflib/main/LICENSE)

> A pure Dart package for working with RDF (resource description framework).

## Features

- Create triple instances (with data types)
- Create a graph to store triples without duplicates
- Find triples based on criteria
- Export graph to turtle `ttl` format (default)
- Bind long namespace with customized shortened name for readability
- Include [reserved vocabulary](https://www.w3.org/TR/owl-syntax/#IRIs) of OWL 2
- Parse [turtle format](https://www.w3.org/TR/turtle/#sec-grammar-grammar) string effectively and
  store triples in the graph in memory

## Getting started

Refer to the code example below, or go to `/example` to find out more!

### For testing the `rdflib` package

```bash
# create a dart project for testing
dart create test_rdflib
cd test_rdflib
# install rdflib as the dependency with dart pub add
dart pub add rdflib
# copy the following code examples to ~/bin/test_rdflib.dart
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

```dart
import 'package:rdflib/rdflib.dart';

main() {
  // the following example is modified from <https://rdflib.readthedocs.io/en/stable/gettingstarted.html#a-more-extensive-example>

  // Initialize a Graph
  Graph g = Graph();

  // Create a new URIRef instance for a person
  final donna = URIRef('http://example.org/donna');

  // Add triples to the Graph using [Graph.addTriplesToGroups] method
  g.addTripleToGroups(donna, RDF.type, FOAF.Person);
  g.addTripleToGroups(donna, FOAF.nick, Literal('donna', lang: 'en'));
  g.addTripleToGroups(donna, FOAF.name, Literal('Donna Fales'));
  g.addTripleToGroups(donna, FOAF.mbox, URIRef('mailto:donna@example.org'));
  // Adding a duplicate triple should be ignored
  g.addTripleToGroups(donna, FOAF.mbox, URIRef('mailto:donna@example.org'));

  // Create another URIRef instance
  final ed = URIRef('http://example.org/edward');

  // Add triples to the Graph
  g.addTripleToGroups(ed, RDF.type, FOAF.Person);
  g.addTripleToGroups(ed, FOAF.nick, Literal('ed', datatype: XSD.string));
  g.addTripleToGroups(ed, FOAF.name, Literal('Edward Scissorhands'));
  g.addTripleToGroups(
      ed, FOAF.mbox, Literal('mailto:ed@example.org', datatype: XSD.anyURI));

  // Bind the long namespace to shorter string for better readability
  g.bind('example', Namespace(ns: 'http://example.org/'));

  // Serialize the Graph to the standard turtle format, and the result is stored
  // in [Graph.serializedString]
  g.serialize(format: 'ttl', abbr: 'short');
  print('-------\nSerialized content:\n${g.serializedString}');

  // Print out every added triple in the graph by iterating through the set
  print('-------\nTriples updated in the graph:');
  for (Triple t in g.triples) {
    print(t);
  }

  // Print out each person's mailbox value
  print('-------\nMailboxes:');
  for (var sub in g.subjects(a, FOAF.Person)) {
    for (var mbox in g.objects(sub, FOAF.mbox)) {
      print('${sub}\'s mailbox: ${mbox.value}');
    }
  }
}
```

### 2. [SOLID Health Ontology Example](https://github.com/anusii/pods/blob/main/datasets/turtle-data/SOLID-Health-Ontology-Example%20-%20(data).ttl)

```dart
import 'package:rdflib/rdflib.dart';

main() {
  // Initialize a Graph
  Graph g = Graph();

  // Define namespaces for later use
  Namespace shData = Namespace(ns: 'http://silo.net.au/data/SOLID-Health#');
  Namespace shOnto =
  Namespace(ns: 'http://sii.cecs.anu.edu.au/onto/SOLID-Health#');

  // Create a subject
  URIRef newAssessTab = shData.withAttr('AssessmentTab-p43623-20220727T120913');

  // Add the entity to the Graph, equivalent to
  // g.addTripleToGroups(newAssessTab, rdf.typ, owl:NamedIndividual)
  g.addNamedIndividualToGroups(newAssessTab);

  // Add using a Triple type
  Triple t1 = Triple(
      sub: newAssessTab, pre: RDF.type, obj: shOnto.withAttr('AssessmentTab'));
  g.addTripleToGroups(t1.sub, t1.pre, t1.obj);

  // Add directly using sub, pre, and obj
  g.addTripleToGroups(
      newAssessTab, shData.withAttr('asthmaControl'), 'Poor Control');
  g.addTripleToGroups(
      newAssessTab, shOnto.withAttr('diastolicBloodPressure'), '75');
  g.addTripleToGroups(
      newAssessTab, shOnto.withAttr('systolicBloodPressure'), Literal('125.0'));

  URIRef newSeeAndDoTab = shData.withAttr('SeeAndDoTab-p43623-20220727T120913');
  URIRef newSeeAndDoOption =
  shData.withAttr('SeeAndDoOption-p43623-20220727T120913-fitnessDrive');

  g.addNamedIndividualToGroups(newSeeAndDoTab);
  g.addNamedIndividualToGroups(newSeeAndDoOption);

  // Link two triple individuals by a relation
  g.addObjectProperty(
      newSeeAndDoTab, shOnto.withAttr('hasSeeAndDoOption'), newSeeAndDoOption);

  // Bind to shorter abbreviations for readability
  g.bind('sh-data', shData);
  g.bind('sh-onto', shOnto);

  // Serialize the graph for output
  g.serialize(format: 'ttl', abbr: 'short');
  print(g.serializedString);
}

```

### 3. Parsing local turtle file

```dart
import 'dart:io';

import 'package:rdflib/rdflib.dart';

main() async {
  String filePath = 'example/sample_ttl_1.ttl';
  // Read file content to a local String
  String fileContents = await File(filePath).readAsStringSync();
  print('-------Original file-------\n$fileContents');

  // create a graph to read turtle file and store info
  Graph g = Graph();

  // Parse with the new method [Graph.parseTurtle] instead of [Graph.parse] (deprecated)
  g.parseTurtle(fileContents);

  // Serialize the Graph for output
  g.serialize(format: 'ttl', abbr: 'short');
  print('-------Serialized String--------\n${g.serializedString}');

  // Print out full format of triples (will use shorthand in serialization/export)
  print('--------All triples in the graph-------');
  for (Triple t in g.triples) {
    print(t);
  }
}

```

### 4. Updating ACL file

```dart
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:rdflib/rdflib.dart';

main() async {
  // https://github.com/anusii/rdflib/blob/main/example/sample_acl_1.acl
  // https://raw.githubusercontent.com/anusii/rdflib/main/example/sample_acl_1.acl
  var url = Uri.https('raw.githubusercontent.com',
      'anusii/rdflib/main/example/sample_acl_1.acl');
  // Get the contents of the acl file
  var res = await http.get(url);
  String aclContents = res.body;
  print('-------Original ACL Contents-------\n${res.body}\n');

  // Initialize a Graph to store all the info
  Graph g = Graph();
  // Parse the contents and update the triples
  g.parseTurtle(aclContents);
  g.serialize(format: 'ttl', abbr: 'short');
  print('-------Serialized ACL Contents------\n${g.serializedString}\n');

  // Add 'zack' to the ACL file
  g.addTripleToGroups('<#zack>', a, 'acl:Authorization');
  // Specify which document/fold
  g.addTripleToGroups('<#zack>', 'acl:accessTo', '<./README>');
  // Specify the target by its webID card
  g.addTripleToGroups('<#zack>', 'acl:agent',
      '<https://solid.dev.yarrabah.net/zack-collins/profile/card#me>');
  // Grant him access to Read only
  g.addTripleToGroups('<#zack>', 'acl:mode', 'acl:Read');
  // Need to serialize before exporting
  g.serialize(format: 'ttl', abbr: 'short');
  print('-------Serialized ACL Contents (New)------\n${g.serializedString}\n');
}

```

## Additional information

### Useful resources

1. [RDFLib](https://github.com/RDFLib/rdflib)
2. [Introduction to RDF](https://www.w3.org/TR/rdf11-primer/)

### How to contribute

Make a pull request on our GitHub [repo](https://github.com/anusii/rdfgraph)!

## Acknowledgement

- This `rdflib` dart package is modelled on the [RDFLib](https://rdflib.readthedocs.io/).
- The parser is written with
  package [dart-petitparser](https://github.com/petitparser/dart-petitparser)
