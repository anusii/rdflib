import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group(
      '''Test [18] 	IRIREF 	::= 	'<' ([^#x00-#x20<>"{}|^`\] | UCHAR)* '>' /* #x00=NULL #01-#x1F=control codes #x20=space */''',
      () {
    Map<String, bool> testStrings = {
      '<>': true,
      '': false,
      '<': false,
      '>': false,
      '<<>': false,
      '<{}>': false,
      '<bob>': true,
      '<bob#me>': true,
      '<\u0010>': false,
      '<www.example.com/alice#me>': true,
      '<www.example.com/alice#me>.': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = IRIREF.end().accept(element);
      bool expected = testStrings[element]!;
      print('IRIREF $element - actual: $actual, expected: $expected');
      test('IRIREF case $element', () {
        expect(actual, expected);
      });
    });
  });
}
