import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """// [17] 	STRING 	::= 	STRING_LITERAL_QUOTE | STRING_LITERAL_SINGLE_QUOTE | STRING_LITERAL_LONG_SINGLE_QUOTE | STRING_LITERAL_LONG_QUOTE""",
      () {
    Map<String, bool> testStrings = {
      '\'\'': true,
      '""': true,
      '""""""': true,
      "''''''": true,
      '"': false,
      '\'': false,
      '"""': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = STRING.end().accept(element);
      bool expected = testStrings[element]!;
      print('STRING $element - actual: $actual, expected: $expected');
      test('STRING case $element', () {
        expect(actual, expected);
      });
    });
  });
}
