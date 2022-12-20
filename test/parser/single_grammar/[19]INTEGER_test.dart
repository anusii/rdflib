import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[19] 	INTEGER 	::= 	[+-]? [0-9]+""", () {
    Map<String, bool> testStrings = {
      '0': true,
      '7': true,
      '-590': true,
      '- 590': false,
      '007': true,
      '-007': true,
      '-1670.5': false,
      '90.8': false,
      '+23': true,
      '+2E3': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = INTEGER.end().accept(element);
      bool expected = testStrings[element]!;
      print('INTEGER $element - actual: $actual, expected: $expected');
      test('INTEGER case $element', () {
        expect(actual, expected);
      });
    });
  });
}
