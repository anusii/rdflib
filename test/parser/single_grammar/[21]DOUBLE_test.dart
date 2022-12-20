import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[21] DOUBLE 	::= 	[+-]? ([0-9]+ '.' [0-9]* EXPONENT | '.' [0-9]+ EXPONENT | [0-9]+ EXPONENT)""",
      () {
    Map<String, bool> testStrings = {
      '+9.8': false,
      '-36.912': false,
      '+.5': false,
      '-.37': false,
      '-.37e1': true,
      '- .37e1': false,
      '-.': false,
      '+108.': false,
      '+108.E3': true,
      '6.02E23': true,
      '1.6e-10': true,
      '.390E2': true,
      '54e3': true,
      '32E7.2': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = DOUBLE.end().accept(element);
      bool expected = testStrings[element]!;
      print('DOUBLE $element - actual: $actual, expected: $expected');
      test('DOUBLE case $element', () {
        expect(actual, expected);
      });
    });
  });
}
