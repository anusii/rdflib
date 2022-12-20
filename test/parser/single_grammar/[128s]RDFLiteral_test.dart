import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[128s] 	RDFLiteral 	::= 	STRING (LANGTAG | '^^' iri)?""", () {
    Map<String, bool> testStrings = {
      '""': true,
      '': false,
      '"abc"@en': true,
      '"xyz"^^<>': true,
      "'xyz'^^<www.fa.cup>": true,
      '"""asd"""^^:zzz': true,
      '""asd"""^^:zzz': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = RDFLiteral.end().accept(element);
      bool expected = testStrings[element]!;
      print('RDFLiteral $element - actual: $actual, expected: $expected');
      test('RDFLiteral case $element', () {
        expect(actual, expected);
      });
    });
  });
}
