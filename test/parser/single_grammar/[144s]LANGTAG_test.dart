import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[144s] 	LANGTAG 	::= 	'@' [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*""", () {
    Map<String, bool> testStrings = {
      '': false,
      '@': false,
      '@q': true,
      '@q-w': true,
      '@q-': false,
      '@q-w-12': true,
      '@q-x-9t-': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = LANGTAG.end().accept(element);
      bool expected = testStrings[element]!;
      print('LANGTAG $element - actual: $actual, expected: $expected');
      test('LANGTAG case $element', () {
        expect(actual, expected);
      });
    });
  });
}
