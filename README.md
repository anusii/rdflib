# RDFGraph

> We're trying to create a tool for organizing RDF data efficiently in dart.

## Features

## Getting started

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
  g.add(Triple(sub: donna, pre: FOAF.mbox, obj: URIRef.fullUri('mailto:donna@example.org')));

  for (Triple t in g.triples) {
    // duplicated records will not be added and printed out
    print(t);
  }
}
```

## Additional information

### Useful resources

1. [RDFLib](https://github.com/RDFLib/rdflib)
2. [Introduction to RDF](https://www.w3.org/TR/rdf11-primer/)

### How to contribute

Make a pull request!
