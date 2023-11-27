import 'package:rdflib/rdflib.dart';

main() {
  String turtleSimple = '''
  @prefix ab: <http://www.ex.org/> .
  @prefix : <http://colon.org/> .
  @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
  @prefix foaf:  <http://xmlns.com/foaf/0.1/> .
  
  <> a foaf:PersonalProfileDocument .
  
  ab:cd a ab:company, <logo> ;
    <http://www.pre.com/> <http://www.xyz.com> ;
    <http://www.number.com> 53, 56.7 ;
    <http://www.example.org> "xxx"^^xsd:numeric .
   
  ab:ef ab:type ab:thing, ab:dog ;
    ab:where ab:act .
  ''';

  // test an example string with valid ttl content
  Graph g = Graph();

  // g.parseTurtle(turtleAclExample);

  // g.parseTurtle(turtleRealExample);

  g.parseTurtle(turtleSimple);
  g.addTripleToGroups('ab:xy.zzz', 'rdf:type', '3');
  g.addTripleToGroups(URIRef(''), a, XSD.anyURI);

  // should not add duplicate triples
  g.addTripleToGroups('<xyz>', 'ab:when', 'yesterday');
  g.addTripleToGroups('<xyz>', 'ab:when', 'yesterday');
  g.addTripleToGroups('<xyz>', 'ab:when', 'yesterday');
  g.addTripleToGroups('<xyz>', 'ab:when', 'today');

  String delim = '-' * 30 + '\n';
  print('${delim}Prefixes:\n${g.ctx}\n');
  print('${delim}Turtles:\n${g.groups}\n');
  g.serialize(format: 'ttl', abbr: 'short');
  String serialized = g.serializedString;
  print('${delim}Serialized Result:\n$serialized\n');

  // test to see if the serialized string is still valid as a ttl input
  Graph g2 = Graph();
  g2.parseTurtle(serialized);
  print('${delim}Serialized Prefixes:\n${g2.ctx}\n');
  print('${delim}Serialized Triples:\n${g2.groups}\n');
  g2.serialize(format: 'ttl', abbr: 'short');
  print('${delim}Serialized Again:\n${g2.serializedString}');
}
