import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[172s] 	PN_LOCAL_ESC 	::= 	'\' ('_' | '~' | '.' | '-' | '!' | '\$' | '&' | "'" | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%')""",
      () {
    List<String> escapeChars =
        """'_' | '~' | '.' | '-' | '!' | '\$' | '&' | "'" | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%'"""
            .split(' | ')
            .map((e) => e[1]) // remove surrounding char: '
            .toList();
    print(escapeChars);
    final Map<String, bool> testStrings = {
      '\_': false,
      '\$': false,
      '\\\\': false,
      '\\"': false,
      '\t': false,
      '\ ': false,
    };
    escapeChars.forEach((e) => testStrings['\\$e'] = true);
    testStrings.keys.forEach((element) {
      bool actual = PN_LOCAL_ESC.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_LOCAL_ESC $element - actual: $actual, expected: $expected');
      test('PN_LOCAL_ESC case $element', () {
        expect(actual, expected);
      });
    });
  });
}
