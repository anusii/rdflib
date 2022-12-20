import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[141s] 	BLANK_NODE_LABEL 	::= 	'_:' (PN_CHARS_U | [0-9]) ((PN_CHARS | '.')* PN_CHARS)?""",
      () {
    Map<String, bool> testStrings = {
      '_:0': true,
      '_:0.a': true,
      '_:': false,
      ':ar': false,
      '_:ar': true,
      '_:hello.dart': true,
      '_:.ignore': false,
      '_:_denied': true,
      '_:_accepted.': false,
      '_:_accepted.sub': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = BLANK_NODE_LABEL.end().accept(element);
      bool expected = testStrings[element]!;
      print('BLANK_NODE_LABEL $element - actual: $actual, expected: $expected');
      test('BLANK_NODE_LABEL case $element', () {
        expect(actual, expected);
      });
    });
  });
}
