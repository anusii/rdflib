import 'package:rdfgraph/rdfgraph.dart';

main() {
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

  // bind 'foaf' to FOAF for easy readout
  g.bind('foaf', FOAF(ns: FOAF.foaf));

  // export graph to turtle format
  g.serialize(format: 'ttl', dest: 'example/ex1.ttl');
}