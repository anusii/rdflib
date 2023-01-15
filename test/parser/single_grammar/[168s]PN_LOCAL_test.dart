import 'package:petitparser/debug.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[168s] 	PN_LOCAL 	::= 	(PN_CHARS_U | ':' | [0-9] | PLX) ((PN_CHARS | '.' | ':' | PLX)* (PN_CHARS | ':' | PLX))?
""", () {
    Map<String, bool> testStrings = {
      '_': true,
      ':': true,
      '7': true,
      'i': true,
      'ij': true,
      '%a9': true,
      '%': false,
      '\$': false,
      'z::': true,
      'z\u203dabc': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = PN_LOCAL.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_LOCAL $element - actual: $actual, expected: $expected');
      test('PN_LOCAL case $element', () {
        expect(actual, expected);
      });
    });
  });
  trace(PN_LOCAL).parse('ij');
}
