import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[170s] 	PERCENT 	::= 	'%' HEX HEX""", () {
    Map<String, bool> testStrings = {
      '%': false,
      '%a9': true,
      '%ft': false,
      '%8': false,
      '%8D': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = PERCENT.end().accept(element);
      bool expected = testStrings[element]!;
      print('PERCENT $element - actual: $actual, expected: $expected');
      test('PERCENT case $element', () {
        expect(actual, expected);
      });
    });
  });
}
