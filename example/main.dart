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
  for (var sub in g.subjects(pre: a, obj: FOAF.Person)) {
    for (var mbox in g.objects(sub: sub, pre: FOAF.mbox)) {
      print('${sub}\'s mailbox: ${mbox.value}');
    }
  }
}
