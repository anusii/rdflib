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
