import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[164s] 	PN_CHARS_U 	::= 	PN_CHARS_BASE | '_'""", () {
    Map<String, bool> testStrings = {
      'd': true,
      'Y': true,
      '\u00bf': false,
      '\u00C0': true,
      '\u00D7': false,
      '\u00F6': true,
      '\u00FF': true,
      '\u0355': false,
      '_': true
    };
    testStrings.keys.forEach((element) {
      bool actual = PN_CHARS_U.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_CHARS_U $element - actual: $actual, expected: $expected');
      test('PN_CHARS_U case $element', () {
        expect(actual, expected);
      });
    });
  });
}
