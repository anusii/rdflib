import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[6s] 	sparqlPrefix 	::= 	"PREFIX" PNAME_NS IRIREF""", () {
    Map<String, bool> testStrings = {
      'Prefix : <>': true,
      'PREFIX : <>': true,
      'PREFIX root: </>': true,
      'PREFIx version5.0: <www.v5.org/>': true,
      '@PREFIx v5: <www.v5.org/>': false,
      'Prefix : <> .': false,
      'PREFIX : <https://xyz.com>>': false,
      'PREFIX root:dir </>': false,
      'PREFIX version5.0 <www.v5.org/>': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = sparqlPrefix.end().accept(element);
      bool expected = testStrings[element]!;
      print('sparqlPrefix $element - actual: $actual, expected: $expected');
      test('sparqlPrefix case $element', () {
        expect(actual, expected);
      });
    });
  });
}
