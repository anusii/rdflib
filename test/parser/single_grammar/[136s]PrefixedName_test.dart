import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[136s] 	PrefixedName 	::= 	PNAME_LN | PNAME_NS""", () {
    Map<String, bool> testStrings = {
      '::': true,
      'rdf:type': true,
      ':xyz': true,
      'www': false,
      'Z10.9a:%b23c': true,
      '_:': false,
      '_:burg': false,
      '_:_': false,
      'burg:_do': true,
      'd:': true,
      'j:': true,
      '': false,
      't': false,
      'www:': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = PrefixedName.end().accept(element);
      bool expected = testStrings[element]!;
      print('PrefixedName $element - actual: $actual, expected: $expected');
      test('PrefixedName case $element', () {
        expect(actual, expected);
      });
    });
  });
}
