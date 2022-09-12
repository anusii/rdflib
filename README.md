# RDFGraph

> We're trying to create a tool for organizing RDF data efficiently in dart.

## Features

- Create triple instances
- Create a graph to store triples without duplicates
- Find triples based on criteria

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

```dart
import 'package:rdfgraph/rdfgraph.dart';

void main() {
  Graph g = Graph();

  URIRef example = URIRef.fullUri('http://example.org');
  // subject and predicate should be a valid URIRef instance
  URIRef donna = example.slash('donna');

  g.add(Triple(sub: donna, pre: RDF.type, obj: FOAF.Person));
  // add duplicated record
  g.add(Triple(sub: donna, pre: RDF.type, obj: FOAF.Person));
  g.add(Triple(sub: donna, pre: FOAF.nick, obj: 'donna'));
  g.add(Triple(sub: donna, pre: FOAF.name, obj: 'Donna Fales'));
  // add duplicated record
  g.add(Triple(sub: donna, pre: FOAF.name, obj: 'Donna Fales'));
  g.add(Triple(
      sub: donna,
      pre: FOAF.mbox,
      obj: URIRef.fullUri('mailto:donna@example.org')));

  // add another in the graph
  URIRef ed = example.slash('edward');
  g.add(Triple(sub: ed, pre: RDF.type, obj: FOAF.Person));
  g.add(Triple(sub: ed, pre: FOAF.nick, obj: 'ed'));
  g.add(Triple(sub: ed, pre: FOAF.name, obj: 'Edward Scissorhands'));
  g.add(Triple(sub: ed, pre: FOAF.mbox, obj: 'e.scissorhands@example.org'));

  // TEST triples should print correctly
  print('-'*30);
  for (Triple t in g.triples) {
    // duplicated records will not be added and printed out
    print(t);
  }

  print('-'*30);
  // TEST correct subjects/objects should print out
  for (URIRef s in g.subjects(RDF.type, FOAF.Person)) {
    for (var o in g.objects(s, FOAF.mbox)) {
      print(o);
    }
  }
}
```

## Additional information

### Useful resources

1. [RDFLib](https://github.com/RDFLib/rdflib)
2. [Introduction to RDF](https://www.w3.org/TR/rdf11-primer/)

### How to contribute

Make a pull request!
