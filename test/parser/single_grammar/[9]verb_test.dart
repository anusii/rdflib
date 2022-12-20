import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[9] 	verb 	::= 	predicate | 'a'""", () {
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
      'www:': true,
      '<>': true,
      '<': false,
      '>': false,
      '<<>': false,
      '<{}>': false,
      '<bob>': true,
      '<bob#me>': true,
      '<\u0010>': false,
      '<www.example.com/alice#me>': true,
      '<www.example.com/alice#me>.': false,
      'a': true,
      'b': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = verb.end().accept(element);
      bool expected = testStrings[element]!;
      print('verb $element - actual: $actual, expected: $expected');
      test('verb case $element', () {
        expect(actual, expected);
      });
    });
  });
}
