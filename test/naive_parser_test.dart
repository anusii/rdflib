import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import 'package:rdflib/rdflib.dart';

main() {
  // test each rule in the grammar one by one in group
  group('Test [171s] 	HEX 	::= 	[0-9] | [A-F] | [a-f]', () {
    Map<String, bool> testStringsHex;
    // all test strings and expected results
    testStringsHex = {
      'f': true,
      'T5': false,
      '3': true,
      'C': true,
      'X': false,
      'Ca': false,
    };
    testStringsHex.keys.forEach((element) {
      bool actual = HEX.end().accept(element);
      bool expected = testStringsHex[element]!;
      print('HEX $element - actual: $actual, expected: $expected');
      test('HEX case $element', () {
        expect(actual, expected);
      });
    });
  });

  group(
      """Test [26] 	UCHAR 	::= 	'\\u' HEX HEX HEX HEX | '\U' HEX HEX HEX HEX HEX HEX HEX HEX""",
      () {
    Map<String, bool> testStrings;
    testStrings = {
      '\\u1234': true,
      '\\uabcd': true,
      'ab': false,
      'z': false,
      // note the following should return false as it is interpreted as a single char instead
      '\uabcd': false,
      '\\U9087a0db': true,
      '\\U9i7b8345': false,
      '\\u56789': false,
      '\\U3456': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = UCHAR.end().accept(element);
      bool expected = testStrings[element]!;
      print('UCHAR $element - actual: $actual, expected: $expected');
      test('UCHAR case $element', () {
        expect(actual, expected);
      });
    });
  });

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

  group(
      '''[163s] 	PN_CHARS_BASE 	::= 	[A-Z] | [a-z] | [#x00C0-#x00D6] | [#x00D8-#x00F6] | [#x00F8-#x02FF] | [#x0370-#x037D] | [#x037F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]''',
      () {
    Map<String, bool> testStrings = {
      'd': true,
      'Y': true,
      '\u00bf': false,
      '\u00C0': true,
      '\u00D7': false,
      '\u00F6': true,
      '\u00FF': true,
      '\u0355': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = PN_CHARS_BASE.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_CHARS_BASE $element - actual: $actual, expected: $expected');
      test('PN_CHARS_BASE case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[164s] 	PN_CHARS_U 	::= 	PN_CHARS_BASE | '_'""", () {
    Map<String, bool> testStrings = {
      'd': true,
      'Y': true,
      '\u00bf': false,
      '\u00C0': true,
      '\u00D7': false,
      '\u00F6': true,
      '\u00FF': true,
      '\u0355': false,
      '_': true
    };
    testStrings.keys.forEach((element) {
      bool actual = PN_CHARS_U.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_CHARS_U $element - actual: $actual, expected: $expected');
      test('PN_CHARS_U case $element', () {
        expect(actual, expected);
      });
    });
  });

  group(
      """[166s] 	PN_CHARS 	::= 	PN_CHARS_U | '-' | [0-9] | #x00B7 | [#x0300-#x036F] | [#x203F-#x2040]
""", () {
    Map<String, bool> testStrings = {
      'd': true,
      'Y': true,
      '\u00bf': false,
      '\u00C0': true,
      '\u00D7': false,
      '\u00F6': true,
      '\u00FF': true,
      '\u0355': true,
      '_': true,
      '-': true,
      '5': true,
      '\u00B7': true,
      '\u0299': true,
      '\u0300': true,
      '\u203d': false,
      '\u2041': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = PN_CHARS.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_CHARS $element - actual: $actual, expected: $expected');
      test('PN_CHARS case $element', () {
        expect(actual, expected);
      });
    });
  });

  group(
      """[167s] 	PN_PREFIX 	::= 	PN_CHARS_BASE ((PN_CHARS | '.')* PN_CHARS)?""",
      () {
    Map<String, bool> testStrings = {
      'd': true,
      'Y': true,
      '\u00bf': false,
      '\u00C0': true,
      '\u00D7': false,
      '\u00F6': true,
      '\u00FF': true,
      '\u0355': false,
      'd-': true,
      'd.': false,
      'Y507-': true,
      'X8.': false,
      'Z10.9a': true,
      '\u00F6\u0299.\u0300': true,
      '\u00F6\u0299.\u0300.': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = PN_PREFIX.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_PREFIX $element - actual: $actual, expected: $expected');
      test('PN_PREFIX case $element', () {
        expect(actual, expected);
      });
    });
  });

  group(
      """[139s] 	PNAME_NS 	::= 	PN_PREFIX? ':'""",
          () {
        Map<String, bool> testStrings = {
          ':': true,
          'd': false,
          'Y:': true,
          '\u00bf': false,
          '\u00C0': false,
          '\u00FF:': true,
          'b-:': true,
          'Y507-': false,
          'Z10.9a:': true,
          '\u00F6\u0299.\u0300:': true,
        };
        testStrings.keys.forEach((element) {
          bool actual = PNAME_NS.end().accept(element);
          bool expected = testStrings[element]!;
          print('PNAME_NS $element - actual: $actual, expected: $expected');
          test('PNAME_NS case $element', () {
            expect(actual, expected);
          });
        });
      });

  group(
      """[170s] 	PERCENT 	::= 	'%' HEX HEX""",
          () {
        Map<String, bool> testStrings = {
          '%': false,
          '%a9': true,
          '%ft': false,
          '%8': false,
          '%8D': true,
        };
        testStrings.keys.forEach((element) {
          bool actual = PERCENT.end().accept(element);
          bool expected = testStrings[element]!;
          print('PERCENT $element - actual: $actual, expected: $expected');
          test('PERCENT case $element', () {
            expect(actual, expected);
          });
        });
      });

}
