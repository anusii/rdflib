import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[22] STRING_LITERAL_QUOTE 	::= 	'"' ([^#x22#x5C#xA#xD] | ECHAR | UCHAR)* '"' /* #x22=" #x5C=\ #xA=new line #xD=carriage return */
""", () {
    Map<String, bool> testStrings = {
      '\"\"': true,
      '\"': false,
      '\'\'': false,
      '\"\\n\\n\\b\"': true,
      '\"\n\n\b\"': false,
      '': false,
      '\"\ua91f\u4559d\"': true,
      '\"alice\"': true,
      '\"charles\x22\"': false,
      '\"_\"': true
    };
    testStrings.keys.forEach((element) {
      bool actual = STRING_LITERAL_QUOTE.end().accept(element);
      bool expected = testStrings[element]!;
      print(
          'STRING_LITERAL_QUOTE $element - actual: $actual, expected: $expected');
      test('STRING_LITERAL_QUOTE case $element', () {
        expect(actual, expected);
      });
    });
  });
}
