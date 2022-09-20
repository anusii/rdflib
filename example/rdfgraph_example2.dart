import 'package:rdfgraph/rdfgraph.dart';

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
