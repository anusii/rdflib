import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[154s] 	EXPONENT 	::= 	[eE] [+-]? [0-9]+""", () {
    Map<String, bool> testStrings = {
      'e00': true,
      'E3': true,
      '+3': false,
      'e-16': true,
      'E+3.5': false,
      'E+9': true,
      'E+ 9': false,
      'E1': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = EXPONENT.end().accept(element);
      bool expected = testStrings[element]!;
      print('EXPONENT $element - actual: $actual, expected: $expected');
      test('EXPONENT case $element', () {
        expect(actual, expected);
      });
    });
  });
}
