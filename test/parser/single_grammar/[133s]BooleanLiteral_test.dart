import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[133s] 	BooleanLiteral 	::= 	'true' | 'false'""", () {
    Map<String, bool> testStrings = {
      '': false,
      'true': true,
      'false': true,
      '1': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = BooleanLiteral.end().accept(element);
      bool expected = testStrings[element]!;
      print('BooleanLiteral $element - actual: $actual, expected: $expected');
      test('BooleanLiteral case $element', () {
        expect(actual, expected);
      });
    });
  });
}
