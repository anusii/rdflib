import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      """[23] 	STRING_LITERAL_SINGLE_QUOTE 	::= 	"'" ([^#x27#x5C#xA#xD] | ECHAR | UCHAR)* "'" /* #x27=' #x5C=\ #xA=new line #xD=carriage return */
""", () {
    Map<String, bool> testStrings = {
      "\'\'": true,
      "\'": false,
      "\"\"": false,
      "\'\\n\\n\\b\'": true,
      "\"\n\n\b\'": false,
      "": false,
      "\'\ua91f\u4559d\'": true,
      "\'alice\'": true,
      "\'charles\x27\'": false,
      "\'_\'": true
    };
    testStrings.keys.forEach((element) {
      bool actual = STRING_LITERAL_SINGLE_QUOTE.end().accept(element);
      bool expected = testStrings[element]!;
      print(
          'STRING_LITERAL_SINGLE_QUOTE $element - actual: $actual, expected: $expected');
      test('STRING_LITERAL_SINGLE_QUOTE case $element', () {
        expect(actual, expected);
      });
    });
  });
}
