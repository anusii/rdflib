import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[20] 	DECIMAL 	::= 	[+-]? [0-9]* '.' [0-9]+""", () {
    Map<String, bool> testStrings = {
      '00.00': true,
      '9.5': true,
      '.369': true,
      '1.': false,
      '23.98': true,
      '-42.3': true,
      '- 42.3': false,
      '+05670.12': true,
      '+-3.2': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = DECIMAL.end().accept(element);
      bool expected = testStrings[element]!;
      print('DECIMAL $element - actual: $actual, expected: $expected');
      test('DECIMAL case $element', () {
        expect(actual, expected);
      });
    });
  });
}
