import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[2] 	statement 	::= 	directive | triples '.'""", () {
    Map<String, bool> testStrings = {
      '@prefix : </etc/> .': true,
      '@prefix c: <./> .': true,
      '@prefix abc: <https://abc.net.au/> .': true,
      '@prefix v2.7: <www.anu.cecs.au/> .': true,
      '@prefix r <./> .': false,
      '@Prefix abc: <https://abc.net.au/> .': false,
      '@prefix v2.: <www.anu.cecs.au/> ': false,
      'Prefix : <>': true,
      'PREFIX : <>': true,
      'PREFIX root: </>': true,
      'PREFIx version5.0: <www.v5.org/>': true,
      '@PREFIx v5: <www.v5.org/>': false,
      'Prefix : <> .': false,
      'PREFIX : <https://xyz.com>>': false,
      'PREFIX root:dir </>': false,
      'PREFIX version5.0 <www.v5.org/>': false,
      'bAse <>': true,
      'BasE <www.example.com>': true,
      'Base <./> ': true,
      'BASE <https://act.org> ': true,
      'base <> .': false,
      '@Base <./> ': false,
      'BASE https://act.org ': false,
      '@base <abc> .': true,
      '@base <http://www.example.org> .': true,
      '@base <> .': true,
      '@base <./> .': true,
      '@BASE <abc> .': false,
      '@Base <http://www.example.org> .': false,
      '@base <> ..': false,
      '@base <./> ': false,
      'rdf:type a rdf:example, <xyz.com> .': true,
      ':Control \n    <2023> _:burg, _:_, x:, "a", <empty>, <whoiswho> . ':
          true,
      'L10.9a:%b23c a <www.example.com/alice#me>, [], _:2 .': true,
      'burg:_do <check#status> :_denied, _:_accepted.sub, hello:me; ;; ; .':
          true,
      'www: abc:time [   ], :whitespaces, "now", (:c1 :c3), 9.8; a rdf:number, owl:vocabulary ; .':
          true,
      '<./> a <folder>; .': true,
      '<bob#me> a <person>, <staff>;;; .': true,
      '<www.example.com/alice#me> located: "ACT"^^earth:australia .': true,
      '_:0.a a <unknown> . ': true,
      'rdf:type a rdf:example, <xyz.com>, .': false,
      ':Control \n  <2023> _:burg, _:_, x:, "a", <empty>, <whoiswho>': false,
      '<./> a <folder> "directory"; ..': false,
      '<bob#me> xyz:loves .': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = statement.end().accept(element);
      bool expected = testStrings[element]!;
      print('statement $element - actual: $actual, expected: $expected');
      test('statement case $element', () {
        expect(actual, expected);
      });
    });
  });
}
