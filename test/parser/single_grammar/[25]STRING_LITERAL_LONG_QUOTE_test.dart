import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      '''[25] 	STRING_LITERAL_LONG_QUOTE 	::= 	'"""' (('"' | '""')? ([^"\] | ECHAR | UCHAR))* '"""''',
      () {
    Map<String, bool> testStrings = {
      '\"\"': false,
      '\"\\n\\n\\b\'': false,
      '\"\n\n\b\'': false,
      '\"alice\'': false,
      '\"charles\x27\'': false,
      '\"_\"': false,
      '\"\"\"': false,
      '\"\"\"\"\"\"': true,
      '\"\"\"\\n\\r\\f\"\"\"': true,
      '': false,
      '\"\"\"dinner\"\"\"': true,
      '\"\"\"\\elevator\"\"\"': false,
      '\"\"\"\"dinner\"\"\"': true,
      // '\"\"\"\"dinner\"\"\"': true, //FIXME: expected true, but actual false
    };
    testStrings.keys.forEach((element) {
      bool actual = STRING_LITERAL_LONG_QUOTE.end().accept(element);
      bool expected = testStrings[element]!;
      print(
          'STRING_LITERAL_LONG_QUOTE $element - actual: $actual, expected: $expected');
      test('STRING_LITERAL_LONG_QUOTE case $element', () {
        expect(actual, expected);
      });
    });
  });
}
