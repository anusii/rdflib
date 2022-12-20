import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  // test each rule in the grammar one by one in group
  group('Test [171s] 	HEX 	::= 	[0-9] | [A-F] | [a-f]', () {
    Map<String, bool> testStringsHex;
    // all test strings and expected results
    testStringsHex = {
      'f': true,
      'T5': false,
      '3': true,
      'C': true,
      'X': false,
      'Ca': false,
    };
    testStringsHex.keys.forEach((element) {
      bool actual = HEX.end().accept(element);
      bool expected = testStringsHex[element]!;
      print('HEX $element - actual: $actual, expected: $expected');
      test('HEX case $element', () {
        expect(actual, expected);
      });
    });
  });
}
