import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[10] 	subject 	::= 	iri | BlankNode | collection""", () {
    Map<String, bool> testStrings = {
      '': false,
      'rdf:type': true,
      ':Control': true,
      'Z10.9a:%b23c': true,
      'burg:_do': true,
      'www:': true,
      '<./>': true,
      '<bob#me>': true,
      '<www.example.com/alice#me>': true,
      '_:0.a': true,
      '_:hello.dart': true,
      '_:.ignore': false,
      '_:_denied': true,
      '_:_accepted.sub': true,
      '[   ]': true,
      '[]': true,
      '[] ': false,
      '  ': false,
      '(<bob> :me)': true,
      '( <bob>:me  )': true,
      '(<bob#me><alice#me><charlie#me>)': true,
      '(<www.example.com/alice#me>)': true,
      'a': false,
      '"item"@en': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = subject.end().accept(element);
      bool expected = testStrings[element]!;
      print('subject $element - actual: $actual, expected: $expected');
      test('subject case $element', () {
        expect(actual, expected);
      });
    });
  });
}
