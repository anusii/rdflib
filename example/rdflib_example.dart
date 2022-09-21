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
