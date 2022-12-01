import 'package:petitparser/petitparser.dart';

// [171s] 	HEX 	::= 	[0-9] | [A-F] | [a-f]
final HEX = (pattern('a-f') | pattern('A-F') | pattern('0-9'));

// [extra] non special chars
final nonSpecialChar = pattern('^\x00-\x20<>"{}|^`\\');

// [26] 	UCHAR 	::= 	'\u' HEX HEX HEX HEX | '\U' HEX HEX HEX HEX HEX HEX HEX HEX
final UCHAR = ((string('\\u') & HEX.times(4)) | (string('\\U') & HEX.times(8)));

// [18] 	IRIREF 	::= 	'<' ([^#x00-#x20<>"{}|^`\] | UCHAR)* '>' /* #x00=NULL #01-#x1F=control codes #x20=space */
final IRIREF =
    (pattern('<') & (nonSpecialChar | UCHAR).star() & (pattern('>')));

// [163s] 	PN_CHARS_BASE 	::= 	[A-Z] | [a-z] | [#x00C0-#x00D6] | [#x00D8-#x00F6] | [#x00F8-#x02FF] | [#x0370-#x037D] | [#x037F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
// final PN_CHARS_BASE = pattern('A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\U00010000-\U000EFFFF');
// FIXME: for unicode \U00010000 to \U000EFFFF
final PN_CHARS_BASE = pattern(
    'A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD');

// [164s] 	PN_CHARS_U 	::= 	PN_CHARS_BASE | '_'
final PN_CHARS_U = (PN_CHARS_BASE | pattern('_'));

// [166s] 	PN_CHARS 	::= 	PN_CHARS_U | '-' | [0-9] | #x00B7 | [#x0300-#x036F] | [#x203F-#x2040]
final PN_CHARS = PN_CHARS_U | pattern('0-9\u00B7\u0300-\u036F\u203F-\u2040\-');

// [167s] 	PN_PREFIX 	::= 	PN_CHARS_BASE ((PN_CHARS | '.')* PN_CHARS)?
// '?' zero or one time
// use starGreedy() to avoid greedy matching all, e.g., (PN_CHARS | '.')* will
// consume the following PN_CHARS if not careful. In normal regex, a $ will be
// enough, with petitparser, need to use starGreedy/plusGreedy to make it work
final PN_PREFIX = PN_CHARS_BASE &
    ((PN_CHARS | string('.')).starGreedy(PN_CHARS) & PN_CHARS).repeat(0, 1);

// [139s] 	PNAME_NS 	::= 	PN_PREFIX? ':'
final PNAME_NS = PN_PREFIX.repeat(0, 1) & string(':');

// [170s] 	PERCENT 	::= 	'%' HEX HEX
final PERCENT = string('%') & HEX.times(2);

// [172s] 	PN_LOCAL_ESC 	::= 	'\' ('_' | '~' | '.' | '-' | '!' | '$' | '&' | "'" | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%')
// put '-' at last to avoid 'Invalid range' error
final PN_LOCAL_ESC = pattern('\\') & pattern('_~.!\$&\'()*+,;=/?#@%-');

// [169s] 	PLX 	::= 	PERCENT | PN_LOCAL_ESC
final PLX = PERCENT | PN_LOCAL_ESC;

// [168s] 	PN_LOCAL 	::= 	(PN_CHARS_U | ':' | [0-9] | PLX) ((PN_CHARS | '.' | ':' | PLX)* (PN_CHARS | ':' | PLX))?
final PN_LOCAL = (PN_CHARS_U | string(':') | pattern('0-9') | PLX) &
    ((PN_CHARS | pattern(':.') | PLX)
                .starGreedy(PN_CHARS | string(':') | PLX)
                .trim() &
            (PN_CHARS | string(':') | PLX))
        .repeat(0, 1)
        .trim();

// [140s] 	PNAME_LN 	::= 	PNAME_NS PN_LOCAL
final PNAME_LN = PNAME_NS & PN_LOCAL;

// [136s] 	PrefixedName 	::= 	PNAME_LN | PNAME_NS
final PrefixedName = PNAME_LN | PNAME_NS;
// Parser();

// [135s] 	iri 	::= 	IRIREF | PrefixedName
final iri = IRIREF | PrefixedName;

// [159s] 	ECHAR 	::= 	'\' [tbnrf"'\]
final ECHAR = pattern('\\') & pattern('tbnrf"\'\\');

// [22] 	STRING_LITERAL_QUOTE 	::= 	'"' ([^#x22#x5C#xA#xD] | ECHAR | UCHAR)* '"' /* #x22=" #x5C=\ #xA=new line #xD=carriage return */
final STRING_LITERAL_QUOTE = pattern('"') &
    (pattern('^\x22\x5C\x0A\x0D') | ECHAR | UCHAR).star() &
    pattern('"');

// [23] 	STRING_LITERAL_SINGLE_QUOTE 	::= 	"'" ([^#x27#x5C#xA#xD] | ECHAR | UCHAR)* "'" /* #x27=' #x5C=\ #xA=new line #xD=carriage return */
final STRING_LITERAL_SINGLE_QUOTE = pattern('\'') &
    (pattern('^\x27\x5C\x0A\x0D') | ECHAR | UCHAR).star() &
    pattern('\'');

// [24] 	STRING_LITERAL_LONG_SINGLE_QUOTE 	::= 	"'''" (("'" | "''")? ([^'\] | ECHAR | UCHAR))* "'''"
final STRING_LITERAL_LONG_SINGLE_QUOTE = pattern('\'').times(3) &
    ((pattern('\'') | pattern('\'').times(2)).repeat(0, 1) &
            (pattern('^\'\\') | ECHAR | UCHAR))
        .star() &
    pattern('\'').times(3);

// [25] 	STRING_LITERAL_LONG_QUOTE 	::= 	'"""' (('"' | '""')? ([^"\] | ECHAR | UCHAR))* '"""'
final STRING_LITERAL_LONG_QUOTE = pattern('"').times(3) &
    ((pattern('"') | pattern('"').times(2)).repeat(0, 1) &
            (pattern('^"\\') | ECHAR | UCHAR))
        .star() &
    pattern('"').times(3);

// [17] 	STRING 	::= 	STRING_LITERAL_QUOTE | STRING_LITERAL_SINGLE_QUOTE | STRING_LITERAL_LONG_SINGLE_QUOTE | STRING_LITERAL_LONG_QUOTE
final STRING = STRING_LITERAL_QUOTE |
    STRING_LITERAL_SINGLE_QUOTE |
    STRING_LITERAL_LONG_SINGLE_QUOTE |
    STRING_LITERAL_LONG_QUOTE;

// [133s] 	BooleanLiteral 	::= 	'true' | 'false'
final BooleanLiteral = string('true') | string('false');

// [144s] 	LANGTAG 	::= 	'@' [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*
final LANGTAG = pattern('@') &
    pattern('a-zA-Z').plus() &
    (pattern('-') & pattern('a-zA-Z0-9').plus()).star();

// [128s] 	RDFLiteral 	::= 	STRING (LANGTAG | '^^' iri)?
final RDFLiteral = STRING & (LANGTAG | string('^^') & iri).repeat(0, 1);

// [19] 	INTEGER 	::= 	[+-]? [0-9]+
final INTEGER = pattern('+-').repeat(0, 1) & pattern('0-9').plus();

// [20] 	DECIMAL 	::= 	[+-]? [0-9]* '.' [0-9]+
final DECEMAL = pattern('+-').repeat(0, 1) &
    pattern('0-9').star() &
    string('.') &
    pattern('0-9').plus();

// [154s] 	EXPONENT 	::= 	[eE] [+-]? [0-9]+
final EXPONENT =
    pattern('eE') & pattern('+-').repeat(0, 1) & pattern('0-9').plus();

// [21] 	DOUBLE 	::= 	[+-]? ([0-9]+ '.' [0-9]* EXPONENT | '.' [0-9]+ EXPONENT | [0-9]+ EXPONENT)
final DOUBLE = pattern('+-').repeat(0, 1) &
    ((pattern('0-9').plus() & string('.') & pattern('0-9').star() & EXPONENT) |
        (string('.') & pattern('0-9').plus() & EXPONENT) |
        (pattern('0-9').plus() & EXPONENT));

// [16] 	NumericLiteral 	::= 	INTEGER | DECIMAL | DOUBLE
final NumerialLiteral = INTEGER | DECEMAL | DOUBLE;

// [13] 	literal 	::= 	RDFLiteral | NumericLiteral | BooleanLiteral
final literal = RDFLiteral | NumerialLiteral | BooleanLiteral;

// [11] 	predicate 	::= 	iri
final predicate = iri;

// [9] 	verb 	::= 	predicate | 'a'
final verb = predicate | string('a');

// [141s] 	BLANK_NODE_LABEL 	::= 	'_:' (PN_CHARS_U | [0-9]) ((PN_CHARS | '.')* PN_CHARS)?
final BLANK_NODE_LABEL = string('_:') &
    (PN_CHARS_U | pattern('0-9')) &
    ((PN_CHARS | string('.')).starGreedy(PN_CHARS) & PN_CHARS).repeat(0, 1);

// [161s] 	WS 	::= 	#x20 | #x9 | #xD | #xA /* #x20=space #x9=character tabulation #xD=carriage return #xA=new line */
final WS = pattern('\x20\x09\x0D\x0A');

// [162s] 	ANON 	::= 	'[' WS* ']'
final ANON = string('[') & WS.star() & string(']');

// [137s] 	BlankNode 	::= 	BLANK_NODE_LABEL | ANON
final BlankNode = BLANK_NODE_LABEL | ANON;

// helper function to generate inter-dependent parsers, e.g. [15] collection and [12] object
Map<String, Parser> genObjCol() {
  Map<String, Parser> rtn = {};
  final collection = undefined();
  final object = undefined();
  final objectList = undefined();
  final predicateObjectList = undefined();
  final blankNodePropertyList = undefined();
  // [15] 	collection 	::= 	'(' object* ')'
  collection.set(string('(') & object.star().trim() & string(')'));
  // [12] 	object 	::= 	iri | BlankNode | collection | blankNodePropertyList | literal
  object.set(iri | BlankNode | collection | blankNodePropertyList | literal);
  // [7] 	predicateObjectList 	::= 	verb objectList (';' (verb objectList)?)*
  predicateObjectList.set(verb &
      objectList.trim() &
      (string(';').trim() & (verb & objectList).repeat(0, 1).trim())
          .star()
          .trim());
  // [8] 	objectList 	::= 	object (',' object)*
  objectList.set(object & (string(',') & object).star().trim());
  // [14] 	blankNodePropertyList 	::= 	'[' predicateObjectList ']'
  blankNodePropertyList
      .set(string('[') & predicateObjectList.trim() & string(']'));
  rtn['object'] = object;
  rtn['collection'] = collection;
  rtn['objectList'] = objectList;
  rtn['predicateObjectList'] = predicateObjectList;
  rtn['blankNodePropertyList'] = blankNodePropertyList;
  return rtn;
}

final objColMap = genObjCol();
final object = objColMap['object']!;
final objectList = objColMap['objectList']!;
final collection = objColMap['collection']!;
final predicateObjectList = objColMap['predicateObjectList']!;
final blankNodePropertyList = objColMap['blankNodePropertyList']!;

// [10] 	subject 	::= 	iri | BlankNode | collection
final subject = iri | BlankNode | collection;

// [6] 	triples 	::= 	subject predicateObjectList | blankNodePropertyList predicateObjectList?
final triples = (subject & predicateObjectList.trim()) |
    (blankNodePropertyList & predicateObjectList.repeat(0, 1).trim());
