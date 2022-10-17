import 'package:rdflib/rdflib.dart';

main() {
  // sample whole text file
  String text = """
#--rdflib--
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<https://solid.silo.net.au/charlie_bruegel> rdf:type owl:NamedIndividual ;
    <http://xmlns.com/foaf/0.1/name> "Charlie Bruegel"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bmiM> "0,3,2,6"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bmiF> "1,10,2,6"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bloodPressureM> "11,0,0,0"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bloodPressureF> "19,0,0,0"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#cholesterolLevelM> "8,1,2"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#cholesterolLevelF> "11,5,3"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#smoking0> "26"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#smoking1> "4"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bloodGlucoseReal> "8.1,8.0,7.9,7.7,7.6,7.8,7.3,7.1,6.9,6.7,6.3,6.6,6.4"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#BMIList> "33,30,27,25,24"^^xsd:string .

  """;

  // create a graph to read turtle file and store info
  Graph g = Graph();
  g.parseText(text);

  // full format of triples (will use shorthand in serialization/export)
  for (Triple t in g.triples) {
    print(t);
  }

  // verify contexts
  print('Contexts: ${g.contexts}');

  // export it to a new file (should be equivalent to the original one)
  g.serialize(format: 'ttl', dest: 'example/ex_full_text.ttl');
}
