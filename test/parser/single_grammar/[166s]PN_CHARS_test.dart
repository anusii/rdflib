import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[166s] 	PN_CHARS 	::= 	PN_CHARS_U | '-' | [0-9] | #x00B7 | [#x0300-#x036F] | [#x203F-#x2040]
""", () {
    Map<String, bool> testStrings = {
      'd': true,
      'Y': true,
      '\u00bf': false,
      '\u00C0': true,
      '\u00D7': false,
      '\u00F6': true,
      '\u00FF': true,
      '\u0355': true,
      '_': true,
      '-': true,
      '5': true,
      '\u00B7': true,
      '\u0299': true,
      '\u0300': true,
      '\u203d': false,
      '\u2041': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = PN_CHARS.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_CHARS $element - actual: $actual, expected: $expected');
      test('PN_CHARS case $element', () {
        expect(actual, expected);
      });
    });
  });
}
