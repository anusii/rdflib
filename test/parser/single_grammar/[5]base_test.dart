import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[5] 	base 	::= 	'@base' IRIREF '.'""", () {
    Map<String, bool> testStrings = {
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
      bool actual = base.end().accept(element);
      bool expected = testStrings[element]!;
      print('base $element - actual: $actual, expected: $expected');
      test('base case $element', () {
        expect(actual, expected);
      });
    });
  });
}
