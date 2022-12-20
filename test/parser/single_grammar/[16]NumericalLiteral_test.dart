import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[16] 	NumericLiteral 	::= 	INTEGER | DECIMAL | DOUBLE""", () {
    Map<String, bool> testStrings = {
      '0': true,
      '0.': false,
      '0.0': true,
      '.0': true,
      '.5E10': true,
      '+000': true,
      '+ 007': false,
      '-.05': true,
      '9.8': true,
      '9.8E3.1': false,
      '': false,
      '-0.': false,
      'e26': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = NumericalLiteral.end().accept(element);
      bool expected = testStrings[element]!;
      print('NumericalLiteral $element - actual: $actual, expected: $expected');
      test('NumericalLiteral case $element', () {
        expect(actual, expected);
      });
    });
  });
}
