import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[14] 	blankNodePropertyList 	::= 	'[' predicateObjectList ']'""",
      () {
    Map<String, bool> testStrings = {
      '[a rdf:example, <xyz.com>]': true,
      '[ <2023> _:burg, _:_, x:, "a", <empty>, <whoiswho> ]': true,
      '[ a <www.example.com/alice#me>, [], _:2 ]': true,
      '[  <check#status> :_denied, _:_accepted.sub, hello:me; ;; ;]': true,
      '[abc:time [   ], :whitespaces, "now", (:c1 :c3), 9.8; a rdf:number, owl:vocabulary ; ]':
          true,
      '[a rdf:example, <xyz.com> .]': false,
      '[<2023> _:burg, _:_, x:, "a", <empty>, <whoiswho>, ]': false,
      '[ \na <thing>; \n]': true,
      '[a <thing>; ,<football>]': false,
      '[a <thing>, <football>;;;]': true,
      '[a ]': false,
      '[]': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = blankNodePropertyList.end().accept(element);
      bool expected = testStrings[element]!;
      print(
          'blankNodePropertyList $element - actual: $actual, expected: $expected');
      test('blankNodePropertyList case $element', () {
        expect(actual, expected);
      });
    });
  });
}
