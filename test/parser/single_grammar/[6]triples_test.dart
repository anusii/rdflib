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
