import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[139s] 	PNAME_NS 	::= 	PN_PREFIX? ':'""", () {
    Map<String, bool> testStrings = {
      ':': true,
      'd': false,
      'Y:': true,
      '\u00bf': false,
      '\u00C0': false,
      '\u00FF:': true,
      'b-:': true,
      'Y507-': false,
      'Z10.9a:': true,
      '\u00F6\u0299.\u0300:': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = PNAME_NS.end().accept(element);
      bool expected = testStrings[element]!;
      print('PNAME_NS $element - actual: $actual, expected: $expected');
      test('PNAME_NS case $element', () {
        expect(actual, expected);
      });
    });
  });
}
