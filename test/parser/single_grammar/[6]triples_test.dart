import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[6] 	triples 	::= 	subject predicateObjectList | blankNodePropertyList predicateObjectList?""",
      () {
    Map<String, bool> testStrings = {
      'rdf:type a rdf:example, <xyz.com>': true,
      ':Control \n    <2023> _:burg, _:_, x:, "a", <empty>, <whoiswho> ': true,
      'L10.9a:%b23c a <www.example.com/alice#me>, [], _:2': true,
      'burg:_do <check#status> :_denied, _:_accepted.sub, hello:me; ;; ;': true,
      'www: abc:time [   ], :whitespaces, "now", (:c1 :c3), 9.8; a rdf:number, owl:vocabulary ;':
          true,
      '<./> a <folder>;': true,
      '<bob#me> a <person>, <staff>;;;': true,
      '<www.example.com/alice#me> located: "ACT"^^earth:australia': true,
      '_:0.a a <unknown>': true,
      'rdf:type a rdf:example, <xyz.com>, ': false,
      ':Control \n  <2023> _:burg, _:_, x:, "a", <empty>, <whoiswho> .': false,
      '<./> a <folder> "directory";': false,
      '<bob#me> xyz:loves ': false,
      'card:ij    rdfs:seeAlso <https://timbl.com/timbl/Public/friends.ttl>': true,
      'c:i r:s <>': true,
      '''<#i> cert:key  [ a cert:RSAPublicKey ; ] ''': true,
      '''<#i> cert:key  [ 
                          a cert:RSAPublicKey ; 
                        ] ''': true,
      '''''<#i> cert:key  [ a cert:RSAPublicKey ; ] ''': false,
      '''<#i> cert:key  [ a cert:RSAPublicKey;
    cert:modulus
"ebe99c737bd3670239600547e5e2eb1d1497da39947b6576c3c44ffeca32cf0f2f7cbee3c47001278a90fc7fc5bcf292f741eb1fcd6bbe7f90650afb519cf13e81b2bffc6e02063ee5a55781d420b1dfaf61c15758480e66d47fb0dcb5fa7b9f7f1052e5ccbd01beee9553c3b6b51f4daf1fce991294cd09a3d1d636bc6c7656e4455d0aff06daec740ed0084aa6866fcae1359de61cc12dbe37c8fa42e977c6e727a8258bb9a3f265b27e3766fe0697f6aa0bcc81c3f026e387bd7bbc81580dc1853af2daa099186a9f59da526474ef6ec0a3d84cf400be3261b6b649dea1f78184862d34d685d2d587f09acc14cd8e578fdd2283387821296f0af39b8d8845"^^xsd:hexBinary ;
        cert:exponent "65537"^^xsd:integer ]
      ''': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = triples.end().accept(element);
      bool expected = testStrings[element]!;
      print('triples $element - actual: $actual, expected: $expected');
      test('triples case $element', () {
        expect(actual, expected);
      });
    });
  });
}
