import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[140s] 	PNAME_LN 	::= 	PNAME_NS PN_LOCAL""", () {
    Map<String, bool> testStrings = {
      '::': true,
      'rdf:type': true,
      ':xyz': true,
      'www': false,
      'www:': false,
      'Z10.9a:%b23c': true,
      '_:': false,
      '_:burg': false,
      '_:_': false,
      'burg:_do': true,
      ' card:i    ': true,
      '   rdfs:seeAlso    ': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = PNAME_LN.end().accept(element);
      bool expected = testStrings[element]!;
      print('PNAME_LN $element - actual: $actual, expected: $expected');
      test('PNAME_LN case $element', () {
        expect(actual, expected);
      });
    });
  });
}
