import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[137s] 	BlankNode 	::= 	BLANK_NODE_LABEL | ANON""", () {
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
      bool actual = BlankNode.end().accept(element);
      bool expected = testStrings[element]!;
      print('BlankNode $element - actual: $actual, expected: $expected');
      test('BlankNode case $element', () {
        expect(actual, expected);
      });
    });
  });
}
