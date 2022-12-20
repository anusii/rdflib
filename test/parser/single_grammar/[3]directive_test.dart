import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[3] 	directive 	::= 	prefixID | base | sparqlPrefix | sparqlBase""",
      () {
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
    };
    testStrings.keys.forEach((element) {
      bool actual = directive.end().accept(element);
      bool expected = testStrings[element]!;
      print('directive $element - actual: $actual, expected: $expected');
      test('directive case $element', () {
        expect(actual, expected);
      });
    });
  });
}
