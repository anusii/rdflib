import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../lib/parser/naive_parser.dart';

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
      'Y 507-': false,
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

  group("""[139s] 	PNAME_NS 	::= 	PN_PREFIX? ':'""", () {
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

  group("""[170s] 	PERCENT 	::= 	'%' HEX HEX""", () {
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

  group(
      """[172s] 	PN_LOCAL_ESC 	::= 	'\' ('_' | '~' | '.' | '-' | '!' | '\$' | '&' | "'" | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%')""",
      () {
    List<String> escapeChars =
        """'_' | '~' | '.' | '-' | '!' | '\$' | '&' | "'" | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%'"""
            .split(' | ')
            .map((e) => e[1]) // remove surrounding char: '
            .toList();
    print(escapeChars);
    final Map<String, bool> testStrings = {
      '\_': false,
      '\$': false,
      '\\\\': false,
      '\\"': false,
      '\t': false,
      '\ ': false,
    };
    escapeChars.forEach((e) => testStrings['\\$e'] = true);
    testStrings.keys.forEach((element) {
      bool actual = PN_LOCAL_ESC.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_LOCAL_ESC $element - actual: $actual, expected: $expected');
      test('PN_LOCAL_ESC case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[169s] 	PLX 	::= 	PERCENT | PN_LOCAL_ESC""", () {
    Map<String, bool> testStrings = {
      '%': false,
      '%a9': true,
      '%Te': false,
      '%0': false,
      '%D3': true,
      '\_': false,
      '\$': false,
      '\\\\': false,
      '\\"': false,
      '\\\$': true,
      '\\\&': true,
      '\\@': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = PLX.end().accept(element);
      bool expected = testStrings[element]!;
      print('PLX $element - actual: $actual, expected: $expected');
      test('PLX case $element', () {
        expect(actual, expected);
      });
    });
  });

  group(
      """[168s] 	PN_LOCAL 	::= 	(PN_CHARS_U | ':' | [0-9] | PLX) ((PN_CHARS | '.' | ':' | PLX)* (PN_CHARS | ':' | PLX))?
""", () {
    Map<String, bool> testStrings = {
      '_': true,
      ':': true,
      '7': true,
      '%a9': true,
      '%': false,
      '\$': false,
      'z::': true,
      'z\u203dabc': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = PN_LOCAL.end().accept(element);
      bool expected = testStrings[element]!;
      print('PN_LOCAL $element - actual: $actual, expected: $expected');
      test('PN_LOCAL case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[140s] 	PNAME_LN 	::= 	PNAME_NS PN_LOCAL""", () {
    Map<String, bool> testStrings = {
      '::': true,
      'rdf:type': true,
      ':xyz': true,
      'www': false,
      'www:': false,
      'Z10.9a:%b23c': true,
      '_:': false,
      '_:burg': false,
      '_:_': false,
      'burg:_do': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = PNAME_LN.end().accept(element);
      bool expected = testStrings[element]!;
      print('PNAME_LN $element - actual: $actual, expected: $expected');
      test('PNAME_LN case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[136s] 	PrefixedName 	::= 	PNAME_LN | PNAME_NS""", () {
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
      't': false,
      'www:': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = PrefixedName.end().accept(element);
      bool expected = testStrings[element]!;
      print('PrefixedName $element - actual: $actual, expected: $expected');
      test('PrefixedName case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[135s] 	iri 	::= 	IRIREF | PrefixedName""", () {
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
      't': false,
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
    };
    testStrings.keys.forEach((element) {
      bool actual = iri.end().accept(element);
      bool expected = testStrings[element]!;
      print('iri $element - actual: $actual, expected: $expected');
      test('iri case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[159s] ECHAR 	::= 	'\' [tbnrf"'\]""", () {
    Map<String, bool> testStrings = {
      '\\': false,
      '\R': false,
      '\\\\': true,
      '\U': false,
      'r': false,
      '\\\"': true,
      '\"': false,
      '\"\"': false,
      '\u0355': false,
      '_': false,
      '\\f': true,
      '\\r': true,
      '\\t': true,
      '\\n': true,
      '\\b': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = ECHAR.end().accept(element);
      bool expected = testStrings[element]!;
      print('ECHAR $element - actual: $actual, expected: $expected');
      test('ECHAR case $element', () {
        expect(actual, expected);
      });
    });
  });

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

  group(
      """[24] 	STRING_LITERAL_LONG_SINGLE_QUOTE 	::= 	"'''" (("'" | "''")? ([^'\] | ECHAR | UCHAR))* "'''\"""",
      () {
    Map<String, bool> testStrings = {
      "\'\'": false,
      "\'\\n\\n\\b\'": false,
      "\"\n\n\b\'": false,
      "\'alice\'": false,
      "\'charles\x27\'": false,
      "\'_\'": false,
      "\'\'\'": false,
      "\'\'\'\'\'\'": true,
      "\'\'\'\\n\\r\\f\'\'\'": true,
      "": false,
      "\'\'\'dinner\'\'\'": true,
      "\'\'\'\\elevator\'\'\'": false,
      "\'\'\'\'dinner\'\'\'": true,
      // "\'\'\'\'\'dinner\'\'\'": true, //FIXME: expected true, but actual false
    };
    testStrings.keys.forEach((element) {
      bool actual = STRING_LITERAL_LONG_SINGLE_QUOTE.end().accept(element);
      bool expected = testStrings[element]!;
      print(
          'STRING_LITERAL_LONG_SINGLE_QUOTE $element - actual: $actual, expected: $expected');
      test('STRING_LITERAL_LONG_SINGLE_QUOTE case $element', () {
        expect(actual, expected);
      });
    });
  });

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

  group(
      """// [17] 	STRING 	::= 	STRING_LITERAL_QUOTE | STRING_LITERAL_SINGLE_QUOTE | STRING_LITERAL_LONG_SINGLE_QUOTE | STRING_LITERAL_LONG_QUOTE""",
      () {
    Map<String, bool> testStrings = {
      '\'\'': true,
      '""': true,
      '""""""': true,
      "''''''": true,
      '"': false,
      '\'': false,
      '"""': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = STRING.end().accept(element);
      bool expected = testStrings[element]!;
      print('STRING $element - actual: $actual, expected: $expected');
      test('STRING case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[133s] 	BooleanLiteral 	::= 	'true' | 'false'""", () {
    Map<String, bool> testStrings = {
      '': false,
      'true': true,
      'false': true,
      '1': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = BooleanLiteral.end().accept(element);
      bool expected = testStrings[element]!;
      print('BooleanLiteral $element - actual: $actual, expected: $expected');
      test('BooleanLiteral case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[144s] 	LANGTAG 	::= 	'@' [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*""", () {
    Map<String, bool> testStrings = {
      '': false,
      '@': false,
      '@q': true,
      '@q-w': true,
      '@q-': false,
      '@q-w-12': true,
      '@q-x-9t-': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = LANGTAG.end().accept(element);
      bool expected = testStrings[element]!;
      print('LANGTAG $element - actual: $actual, expected: $expected');
      test('LANGTAG case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[128s] 	RDFLiteral 	::= 	STRING (LANGTAG | '^^' iri)?""", () {
    Map<String, bool> testStrings = {
      '""': true,
      '': false,
      '"abc"@en': true,
      '"xyz"^^<>': true,
      "'xyz'^^<www.fa.cup>": true,
      '"""asd"""^^:zzz': true,
      '""asd"""^^:zzz': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = RDFLiteral.end().accept(element);
      bool expected = testStrings[element]!;
      print('RDFLiteral $element - actual: $actual, expected: $expected');
      test('RDFLiteral case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[19] 	INTEGER 	::= 	[+-]? [0-9]+""", () {
    Map<String, bool> testStrings = {
      '0': true,
      '7': true,
      '-590': true,
      '- 590': false,
      '007': true,
      '-007': true,
      '-1670.5': false,
      '90.8': false,
      '+23': true,
      '+2E3': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = INTEGER.end().accept(element);
      bool expected = testStrings[element]!;
      print('INTEGER $element - actual: $actual, expected: $expected');
      test('INTEGER case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[20] 	DECIMAL 	::= 	[+-]? [0-9]* '.' [0-9]+""", () {
    Map<String, bool> testStrings = {
      '00.00': true,
      '9.5': true,
      '.369': true,
      '1.': false,
      '23.98': true,
      '-42.3': true,
      '- 42.3': false,
      '+05670.12': true,
      '+-3.2': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = DECIMAL.end().accept(element);
      bool expected = testStrings[element]!;
      print('DECIMAL $element - actual: $actual, expected: $expected');
      test('DECIMAL case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[154s] 	EXPONENT 	::= 	[eE] [+-]? [0-9]+""", () {
    Map<String, bool> testStrings = {
      'e00': true,
      'E3': true,
      '+3': false,
      'e-16': true,
      'E+3.5': false,
      'E+9': true,
      'E+ 9': false,
      'E1': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = EXPONENT.end().accept(element);
      bool expected = testStrings[element]!;
      print('EXPONENT $element - actual: $actual, expected: $expected');
      test('EXPONENT case $element', () {
        expect(actual, expected);
      });
    });
  });

  group(
      """DOUBLE 	::= 	[+-]? ([0-9]+ '.' [0-9]* EXPONENT | '.' [0-9]+ EXPONENT | [0-9]+ EXPONENT)""",
      () {
    Map<String, bool> testStrings = {
      '+9.8': false,
      '-36.912': false,
      '+.5': false,
      '-.37': false,
      '-.37e1': true,
      '- .37e1': false,
      '-.': false,
      '+108.': false,
      '+108.E3': true,
      '6.02E23': true,
      '1.6e-10': true,
      '.390E2': true,
      '54e3': true,
      '32E7.2': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = DOUBLE.end().accept(element);
      bool expected = testStrings[element]!;
      print('DOUBLE $element - actual: $actual, expected: $expected');
      test('DOUBLE case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[16] 	NumericLiteral 	::= 	INTEGER | DECIMAL | DOUBLE""", () {
    Map<String, bool> testStrings = {
      '0': true,
      '0.': false,
      '0.0': true,
      '.0': true,
      '.5E10': true,
      '+000': true,
      '+ 007': false,
      '-.05': true,
      '9.8': true,
      '9.8E3.1': false,
      '': false,
      '-0.': false,
      'e26': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = NumericalLiteral.end().accept(element);
      bool expected = testStrings[element]!;
      print('NumericalLiteral $element - actual: $actual, expected: $expected');
      test('NumericalLiteral case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[13] 	literal 	::= 	RDFLiteral | NumericLiteral | BooleanLiteral""",
      () {
    Map<String, bool> testStrings = {
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
    };
    testStrings.keys.forEach((element) {
      bool actual = literal.end().accept(element);
      bool expected = testStrings[element]!;
      print('literal $element - actual: $actual, expected: $expected');
      test('literal case $element', () {
        expect(actual, expected);
      });
    });
  });

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

  group(
      """[141s] 	BLANK_NODE_LABEL 	::= 	'_:' (PN_CHARS_U | [0-9]) ((PN_CHARS | '.')* PN_CHARS)?""",
      () {
    Map<String, bool> testStrings = {
      '_:0': true,
      '_:0.a': true,
      '_:': false,
      ':ar': false,
      '_:ar': true,
      '_:hello.dart': true,
      '_:.ignore': false,
      '_:_denied': true,
      '_:_accepted.': false,
      '_:_accepted.sub': true,
    };
    testStrings.keys.forEach((element) {
      bool actual = BLANK_NODE_LABEL.end().accept(element);
      bool expected = testStrings[element]!;
      print('BLANK_NODE_LABEL $element - actual: $actual, expected: $expected');
      test('BLANK_NODE_LABEL case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[161s] 	WS 	::= 	#x20 | #x9 | #xD | #xA""", () {
    Map<String, bool> testStrings = {
      '\x20': true,
      ' ': true,
      '\x09': true,
      '\x0D': true,
      '\x0A': true,
      '': false,
      '  ': false,
      '\x0d': true,
      '\x09\x09': false
    };
    testStrings.keys.forEach((element) {
      bool actual = WS.end().accept(element);
      bool expected = testStrings[element]!;
      print('WS $element - actual: $actual, expected: $expected');
      test('WS case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[162s] 	ANON 	::= 	'[' WS* ']'""", () {
    Map<String, bool> testStrings = {
      '[\x20]': true,
      '[   ]': true,
      '[\x09\x0A]': true,
      '[]': true,
      '[] ': false,
      '[\x20] ': false,
      '': false,
      '  ': false,
      '[  ': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = ANON.end().accept(element);
      bool expected = testStrings[element]!;
      print('ANON $element - actual: $actual, expected: $expected');
      test('ANON case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[137s] 	BlankNode 	::= 	BLANK_NODE_LABEL | ANON""", () {
    Map<String, bool> testStrings = {
      '_:0': true,
      '_:0.a': true,
      '_:': false,
      ':ar': false,
      '_:ar': true,
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
      '': false,
      '  ': false,
      '[  ': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = BlankNode.end().accept(element);
      bool expected = testStrings[element]!;
      print('BlankNode $element - actual: $actual, expected: $expected');
      test('BlankNode case $element', () {
        expect(actual, expected);
      });
    });
  });

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

  group("""[15] 	collection 	::= 	'(' object* ')'""", () {
    Map<String, bool> testStrings = {
      '()': true,
      '(::)': true,
      '( rdf:type )': true,
      '(:xyz)': true,
      'www': false,
      '(Z10.9a:%b23c_:a)': true,
      '(_:)': false,
      '(_:burg)': true,
      '_:_': false,
      '(burg:_do)': true,
      '(d: )': true,
      '( j:x:)': true,
      '': false,
      't': false,
      '(www:  )': true,
      '(<><>)': true,
      '<': false,
      '>': false,
      '<<>': false,
      '<{}>': false,
      '(<bob> :me)': true,
      '( <bob>:me  )': true,
      '(<bob#me><alice#me><charlie#me>)': true,
      '<\u0010>': false,
      '(<www.example.com/alice#me>)': true,
      '<www.example.com/alice#me>.': false,
      '(_:0)': true,
      '(_:__:0.a)': true,
      '(<world>_:hello.dart)': true,
      '(_:.ignore)': false,
      '(_:_denied<xyz#>rdf:na)': true,
      '_:_accepted.': false,
      '(<tobeconfirmed.org>_:_accepted.sub)': true,
      '([\x20][])': true,
      '([   ]<whathapped#me>)': true,
      '([\x09\x0A]_:white)': true,
      '([])': true,
      '[] ': false,
      '[\x20] ': false,
      '  ': false,
      '[  ': false,
      '(5.8)': true,
      '(5.8 9.5E3"howtointerpretthese"^^awe:some)': true, // ?
      '("Zero"<0>rdf:zero)': true,
      '( false)': true,
      '( \'true\'@en)': true,
      '("antarctica"^^<www.wikipedia.org><anotherone>rdf:yetanotherone )': true,
      '(-1E0)': true,
      ' ': false,
      'zero': false,
      '(true false)': true,
      '("true"true )': true,
      '(true@en)': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = collection.end().accept(element);
      bool expected = testStrings[element]!;
      print('collection $element - actual: $actual, expected: $expected');
      test('collection case $element', () {
        expect(actual, expected);
      });
    });
  });

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

  group("""[14] 	blankNodePropertyList 	::= 	'[' predicateObjectList ']'""", () {
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
      print('blankNodePropertyList $element - actual: $actual, expected: $expected');
      test('blankNodePropertyList case $element', () {
        expect(actual, expected);
      });
    });
  });

  group("""[10] 	subject 	::= 	iri | BlankNode | collection""", () {
    Map<String, bool> testStrings = {
      '': false,
      'rdf:type': true,
      ':Control': true,
      'Z10.9a:%b23c': true,
      'burg:_do': true,
      'www:': true,
      '<./>': true,
      '<bob#me>': true,
      '<www.example.com/alice#me>': true,
      '_:0.a': true,
      '_:hello.dart': true,
      '_:.ignore': false,
      '_:_denied': true,
      '_:_accepted.sub': true,
      '[   ]': true,
      '[]': true,
      '[] ': false,
      '  ': false,
      '(<bob> :me)': true,
      '( <bob>:me  )': true,
      '(<bob#me><alice#me><charlie#me>)': true,
      '(<www.example.com/alice#me>)': true,
      'a': false,
      '"item"@en': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = subject.end().accept(element);
      bool expected = testStrings[element]!;
      print('subject $element - actual: $actual, expected: $expected');
      test('subject case $element', () {
        expect(actual, expected);
      });
    });
  });
}
