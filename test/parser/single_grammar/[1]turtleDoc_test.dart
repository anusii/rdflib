import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[1] 	turtleDoc 	::= 	statement*""", () {
    // ttl file
    String sampleTurtle0 = '''
    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
  @prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<https://solid.silo.net.au/charlie_bruegel> rdf:type owl:NamedIndividual ;
    <http://xmlns.com/foaf/0.1/name> "Charlie Bruegel"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bmiM> "0,3,2,6"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bmiF> "1,10,2,6"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bloodPreasureM> "11,81,64,39"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bloodPreasureF> "39,11,81,64"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#cholesterolLevelM> "8,1,2"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#cholesterolLevelF> "11,5,3"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#smoking0> "26"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#smoking1> "4"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bloodGlucoseReal> "5.1,6.0,8.1,7.2,8.6,7.8,7.3,7.1,4.5,6.7,6.3,6.6,6.9"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#BMIList> "18,35,20,32,23"^^xsd:string .
    ''';
    // acl file
    String sampleTurtle1 = '''
    @prefix : <#>.
  @prefix acl: <http://www.w3.org/ns/auth/acl#>.
@prefix foaf: <http://xmlns.com/foaf/0.1/>.
@prefix c: <https://solid.udula.net.au/charlie_bruegel/profile/card#>.
@prefix c0: <https://solid.udula.net.au/leslie_smith/profile/card#>.
@prefix c1: <https://solid.ecosysl.net/phitest00/profile/card#>.

:ControlReadWrite
    a acl:Authorization;
    acl:accessTo <employment>;
    acl:agent c:me;
    acl:mode acl:Control, acl:Read, acl:Write.
:ReadWrite
    a acl:Authorization;
    acl:accessTo <employment>;
    acl:agent c0:me, c1:me;
    acl:mode acl:Read, acl:Write.
    ''';
    Map<String, bool> testStrings = {
      '': true,
      sampleTurtle0: true,
      '$sampleTurtle0 .': false,
      sampleTurtle1: true,
      '.': false,
      ' ': false,
      '@prefix : </etc/> . @prefix c: <./> . @base <./> .': true,
      '@prefix abc: <https://abc.net.au/> .\n@prefix v2.7: <www.anu.cecs.au/> . \n_:0.a a <unknown> . ':
          true,
      'Prefix : <> \n PREFIX root: </> \n BasE <www.example.com> <www.example.com/alice#me> located: "ACT"^^earth:australia .':
          true,
      '@base <http://www.example.org> .': true,
      'rdf:type a rdf:example, <xyz.com> .': true,
      '<bob#me> a <person>, <staff>;;; .': true,
      'rdf:type a rdf:example, <xyz.com>, .': false,
      ':Control \n  <2023> _:burg, _:_, x:, "a", <empty>, <whoiswho>': false,
      '<bob#me> xyz:loves .': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = turtleDoc.end().accept(element);
      bool expected = testStrings[element]!;
      print('turtleDoc $element - actual: $actual, expected: $expected');
      test('turtleDoc case $element', () {
        expect(actual, expected);
      });
    });
  });
}
