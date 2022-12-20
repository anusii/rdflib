import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[159s] ECHAR 	::= 	'\' [tbnrf"'\]""", () {
    Map<String, bool> testStrings = {
      '\\': false,
      '\R': false,
      '\\\\': true,
      '\U': false,
      'r': false,
      '\\\"': true,
      '\"': false,
      '\"\"': false,
      '\u0355': false,
      '_': false,
      '\\f': true,
      '\\r': true,
      '\\t': true,
      '\\n': true,
      '\\b': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = ECHAR.end().accept(element);
      bool expected = testStrings[element]!;
      print('ECHAR $element - actual: $actual, expected: $expected');
      test('ECHAR case $element', () {
        expect(actual, expected);
      });
    });
  });
}
