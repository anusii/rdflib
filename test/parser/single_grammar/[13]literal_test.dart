import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[13] 	literal 	::= 	RDFLiteral | NumericLiteral | BooleanLiteral""",
      () {
    Map<String, bool> testStrings = {
      '5.8': true,
      '"Zero"': true,
      'false': true,
      '\'true\'@en': true,
      '"antarctica"^^<www.wikipedia.org>': true,
      '-1E0': true,
      ' ': false,
      'zero': false,
      'true': true,
      '"true"': true,
      'true@en': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = literal.end().accept(element);
      bool expected = testStrings[element]!;
      print('literal $element - actual: $actual, expected: $expected');
      test('literal case $element', () {
        expect(actual, expected);
      });
    });
  });
}
