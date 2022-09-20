import '../lib/rdfgraph.dart';

main() {
  Graph g = Graph();

  Namespace shData = Namespace(ns: 'http://silo.net.au/data/SOLID-Health#');
  Namespace shOnto =
      Namespace(ns: 'http://sii.cecs.anu.edu.au/onto/SOLID-Health#');

  URIRef newSub = shData.withAttr('AssessmentTab-p43623-20220727T120913');
  bool suc = g.addNamedIndividual(newSub);
  print(suc);

  g.add(Triple(
      sub: newSub, pre: RDF.type, obj: shOnto.withAttr('AssessmentTab')));

  g.add(Triple(
      sub: newSub,
      pre: shOnto.withAttr('asthmaControl'),
      obj: Literal('Poor Control')));

  g.add(Triple(
      sub: newSub,
      pre: shOnto.withAttr('diastolicBloodPressure'),
      obj: Literal('75')));

  g.add(Triple(
      sub: newSub,
      pre: shOnto.withAttr('systolicBloodPressure'),
      obj: Literal('125.0')));

  g.bind('sh-data', shData);
  g.bind('sh-onto', shOnto);

  g.serialize(dest: 'example/ex2.ttl');
}
