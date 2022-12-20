import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """Test [26] 	UCHAR 	::= 	'\\u' HEX HEX HEX HEX | '\U' HEX HEX HEX HEX HEX HEX HEX HEX""",
      () {
    Map<String, bool> testStrings;
    testStrings = {
      '\\u1234': true,
      '\\uabcd': true,
      'ab': false,
      'z': false,
      // note the following should return false as it is interpreted as a single char instead
      '\uabcd': false,
      '\\U9087a0db': true,
      '\\U9i7b8345': false,
      '\\u56789': false,
      '\\U3456': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = UCHAR.end().accept(element);
      bool expected = testStrings[element]!;
      print('UCHAR $element - actual: $actual, expected: $expected');
      test('UCHAR case $element', () {
        expect(actual, expected);
      });
    });
  });
}
