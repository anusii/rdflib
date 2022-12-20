import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[162s] 	ANON 	::= 	'[' WS* ']'""", () {
    Map<String, bool> testStrings = {
      '[\x20]': true,
      '[   ]': true,
      '[\x09\x0A]': true,
      '[]': true,
      '[] ': false,
      '[\x20] ': false,
      '': false,
      '  ': false,
      '[  ': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = ANON.end().accept(element);
      bool expected = testStrings[element]!;
      print('ANON $element - actual: $actual, expected: $expected');
      test('ANON case $element', () {
        expect(actual, expected);
      });
    });
  });
}
