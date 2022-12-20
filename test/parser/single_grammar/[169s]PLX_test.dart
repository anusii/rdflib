import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[169s] 	PLX 	::= 	PERCENT | PN_LOCAL_ESC""", () {
    Map<String, bool> testStrings = {
      '%': false,
      '%a9': true,
      '%Te': false,
      '%0': false,
      '%D3': true,
      '\_': false,
      '\$': false,
      '\\\\': false,
      '\\"': false,
      '\\\$': true,
      '\\\&': true,
      '\\@': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = PLX.end().accept(element);
      bool expected = testStrings[element]!;
      print('PLX $element - actual: $actual, expected: $expected');
      test('PLX case $element', () {
        expect(actual, expected);
      });
    });
  });
}
