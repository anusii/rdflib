library rdfgraph;

import 'package:rdfgraph/rdfgraph.dart';
import 'package:rdfgraph/src/term.dart';
import 'package:rdfgraph/src/namespace.dart';

export 'src/term.dart';
export 'src/namespace.dart';
export 'src/triple.dart';
export 'src/graph.dart';

main() {
  Graph g = Graph();

  URIRef example = URIRef.fullUri('http://example.org');
  URIRef donna = example.slash('donna');

  g.add(Triple(sub: donna, pre: RDF.type, obj: FOAF.Person));
  g.add(Triple(sub: donna, pre: RDF.type, obj: FOAF.Person));
  g.add(Triple(sub: donna, pre: FOAF.nick, obj: 'donna'));
  g.add(Triple(sub: donna, pre: FOAF.name, obj: 'Donna Fales'));
  g.add(Triple(sub: donna, pre: FOAF.name, obj: 'Donna Fales'));
  g.add(Triple(sub: donna, pre: FOAF.mbox, obj: URIRef.fullUri('mailto:donna@example.org')));

  for (Triple t in g.triples) {
    print(t);
  }

}