import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[7] 	predicateObjectList 	::= 	verb objectList (';' (verb objectList)?)*""",
      () {
    Map<String, bool> testStrings = {
      'a rdf:example, <xyz.com>': true,
      '<2023> _:burg, _:_, x:, "a", <empty>, <whoiswho> ': true,
      'a <www.example.com/alice#me>, [], _:2': true,
      '<check#status> :_denied, _:_accepted.sub, hello:me; ;; ;': true,
      'abc:time [   ], :whitespaces, "now", (:c1 :c3), 9.8; a rdf:number, owl:vocabulary ;':
          true,
      'a rdf:example, <xyz.com> .': false,
      '<2023> _:burg, _:_, x:, "a", <empty>, <whoiswho>, ': false,
      'a <thing>;': true,
      'a <thing>; ,<football>': false,
      'a <thing>, <football>;;;': true,
      'a ': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = predicateObjectList.end().accept(element);
      bool expected = testStrings[element]!;
      print(
          'predicateObjectList $element - actual: $actual, expected: $expected');
      test('predicateObjectList case $element', () {
        expect(actual, expected);
      });
    });
  });
}
