import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[4] 	prefixID 	::= 	'@prefix' PNAME_NS IRIREF '.'""", () {
    Map<String, bool> testStrings = {
      '@prefix : </etc/> .': true,
      '@prefix c: <./> .': true,
      '@prefix abc: <https://abc.net.au/> .': true,
      '@prefix v2.7: <www.anu.cecs.au/> .': true,
      '@prefix r <./> .': false,
      '@Prefix abc: <https://abc.net.au/> .': false,
      '@prefix v2.: <www.anu.cecs.au/> ': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = prefixID.end().accept(element);
      bool expected = testStrings[element]!;
      print('prefixID $element - actual: $actual, expected: $expected');
      test('prefixID case $element', () {
        expect(actual, expected);
      });
    });
  });
}
