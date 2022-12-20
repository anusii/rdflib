import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[167s] 	PN_PREFIX 	::= 	PN_CHARS_BASE ((PN_CHARS | '.')* PN_CHARS)?""",
      () {
    Map<String, bool> testStrings = {
      'd': true,
      'Y': true,
      '\u00bf': false,
      '\u00C0': true,
      '\u00D7': false,
      '\u00F6': true,
      '\u00FF': true,
      '\u0355': false,
      'd-': true,
      'd.': false,
      'Y507-': true,
      'Y 507-': false,
      'X8.': false,
      'Z10.9a': true,
      '\u00F6\u0299.\u0300': true,
      '\u00F6\u0299.\u0300.': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = PN_PREFIX.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_PREFIX $element - actual: $actual, expected: $expected');
      test('PN_PREFIX case $element', () {
        expect(actual, expected);
      });
    });
  });
}
