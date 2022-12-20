import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[5s] 	sparqlBase 	::= 	"BASE" IRIREF""", () {
    Map<String, bool> testStrings = {
      'bAse <>': true,
      'BasE <www.example.com>': true,
      'Base <./> ': true,
      'BASE <https://act.org> ': true,
      'base <> .': false,
      '@Base <./> ': false,
      'BASE https://act.org ': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = sparqlBase.end().accept(element);
      bool expected = testStrings[element]!;
      print('sparqlBase $element - actual: $actual, expected: $expected');
      test('sparqlBase case $element', () {
        expect(actual, expected);
      });
    });
  });
}
