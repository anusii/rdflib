import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[8] 	objectList 	::= 	object (',' object)*""", () {
    Map<String, bool> testStrings = {
      'rdf:example, <xyz.com>': true,
      '_:burg, _:_, x:, "a", <empty>, <whoiswho> ': true,
      '_:burg, _:_, x:, a, <empty>': false,
      '<www.example.com/alice#me>, [], _:2': true,
      '_:_denied, _:_accepted.sub, hello:me': true,
      '[\x09\x0A], :whitespaces, "now", (:c1 :c3), 9.8': true,
      'true': true,
      '"true"': true,
      '()': true,
      '( rdf:type awe:ful <madeup.com>)': true,
      '(:xyz)': true,
      '(Z10.9a:%b23c_:a)': true,
      'rdf:ex; "abc"': false,
      '_:example .': false,
      '1^^xdf:odd': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = objectList.end().accept(element);
      bool expected = testStrings[element]!;
      print('objectList $element - actual: $actual, expected: $expected');
      test('objectList case $element', () {
        expect(actual, expected);
      });
    });
  });
}
