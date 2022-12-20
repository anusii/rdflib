import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[12] 	object 	::= 	iri | BlankNode | collection | blankNodePropertyList | literal""",
      () {
    Map<String, bool> testStrings = {
      ' ': false,
      '::': true,
      'a': false,
      'rdf:type': true,
      ':xyz': true,
      'www': false,
      'Z10.9a:%b23c': true,
      '_:': false,
      '_:burg': true,
      '_:_': true,
      'burg:_do': true,
      'd:': true,
      'j:': true,
      '': false,
      't': false,
      'www:': true,
      '<>': true,
      '<': false,
      '>': false,
      '<<>': false,
      '<{}>': false,
      '<xyz.com>': true,
      '<bob#me>': true,
      '<\u0010>': false,
      '<www.example.com/alice#me>': true,
      '<www.example.com/alice#me>.': false,
      '_:0': true,
      '_:0.a': true,
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
      '  ': false,
      '[  ': false,
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
      '()': true,
      '(::)': true,
      '( rdf:type awe:ful <madeup.com>)': true,
      '(:xyz)': true,
      '(Z10.9a:%b23c_:a)': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = object.end().accept(element);
      bool expected = testStrings[element]!;
      print('object $element - actual: $actual, expected: $expected');
      test('object case $element', () {
        expect(actual, expected);
      });
    });
  });
}
