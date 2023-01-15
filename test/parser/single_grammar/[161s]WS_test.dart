import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[161s] 	WS 	::= 	#x20 | #x9 | #xD | #xA""", () {
    Map<String, bool> testStrings = {
      // '\x20': true,
      ' ': true,
      '\x09': true,
      '\x0D': true,
      '\x0A': true,
      '': false,
      '  ': false,
      // '\x0d': true,
      '\x09\x09': false
    };
    testStrings.keys.forEach((element) {
      bool actual = WS.end().accept(element);
      bool expected = testStrings[element]!;
      print('WS $element - actual: $actual, expected: $expected');
      test('WS case $element', () {
        expect(actual, expected);
      });
    });
  });
}
