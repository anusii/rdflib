import 'package:petitparser/petitparser.dart';
import 'package:rdflib/rdflib.dart';

class ExpressionDefinition extends GrammarDefinition {
  Parser start() => ref0(turtleDoc).end();

  // [171s] 	HEX 	::= 	[0-9] | [A-F] | [a-f]
  Parser HEX() => (pattern('a-f') | pattern('A-F') | pattern('0-9'));

  // [extra] non special chars
  Parser nonSpecialChar() => pattern('^\x00-\x20<>"{}|^`\\');

  // [26] 	UCHAR 	::= 	'\u' HEX HEX HEX HEX | '\U' HEX HEX HEX HEX HEX HEX HEX HEX
  Parser UCHAR() => ((string('\\u') & ref0(HEX).times(4)) |
      (string('\\U') & ref0(HEX).times(8)));

  // [18] 	IRIREF 	::= 	'<' ([^#x00-#x20<>"{}|^`\] | UCHAR)* '>' /* #x00=NULL #01-#x1F=control codes #x20=space */
  Parser IRIREF() => (pattern('<') &
      (ref0(nonSpecialChar) | ref0(UCHAR)).star() &
      (pattern('>')));

  // [163s] 	PN_CHARS_BASE 	::= 	[A-Z] | [a-z] | [#x00C0-#x00D6] | [#x00D8-#x00F6] | [#x00F8-#x02FF] | [#x0370-#x037D] | [#x037F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
  // final PN_CHARS_BASE = pattern('A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\U00010000-\U000EFFFF');
  // FIXME: for unicode \U00010000 to \U000EFFFF
  Parser PN_CHARS_BASE() => pattern(
      'A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD');

  // [164s] 	PN_CHARS_U 	::= 	PN_CHARS_BASE | '_'
  Parser PN_CHARS_U() => (ref0(PN_CHARS_BASE) | pattern('_'));

  // [166s] 	PN_CHARS 	::= 	PN_CHARS_U | '-' | [0-9] | #x00B7 | [#x0300-#x036F] | [#x203F-#x2040]
  Parser PN_CHARS() =>
      ref0(PN_CHARS_U) | pattern('0-9\u00B7\u0300-\u036F\u203F-\u2040\-');

  // [167s] 	PN_PREFIX 	::= 	PN_CHARS_BASE ((PN_CHARS | '.')* PN_CHARS)?
  // '?' zero or one time
  // use starGreedy() to avoid greedy matching all, e.g., (PN_CHARS | '.')* will
  // consume the following PN_CHARS if not careful. In normal regex, a $ will be
  // enough, with petitparser, need to use starGreedy/plusGreedy to make it work
  Parser PN_PREFIX() =>
      ref0(PN_CHARS_BASE) &
      ((ref0(PN_CHARS) | string('.')).starGreedy(ref0(PN_CHARS)) &
              ref0(PN_CHARS))
          .repeat(0, 1);

  // [139s] 	PNAME_NS 	::= 	PN_PREFIX? ':'
  // trim at the end cause there might be spaces between prefix and colon
  Parser PNAME_NS() => ref0(PN_PREFIX).repeat(0, 1) & string(':').trim();

  // [170s] 	PERCENT 	::= 	'%' HEX HEX
  Parser PERCENT() => string('%') & ref0(HEX).times(2);

  // [172s] 	PN_LOCAL_ESC 	::= 	'\' ('_' | '~' | '.' | '-' | '!' | '$' | '&' | "'" | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%')
  // put '-' at last to avoid 'Invalid range' error
  Parser PN_LOCAL_ESC() => pattern('\\') & pattern('_~.!\$&\'()*+,;=/?#@%-');

  // [169s] 	PLX 	::= 	PERCENT | PN_LOCAL_ESC
  Parser PLX() => ref0(PERCENT) | ref0(PN_LOCAL_ESC);

  // [168s] 	PN_LOCAL 	::= 	(PN_CHARS_U | ':' | [0-9] | PLX) ((PN_CHARS | '.' | ':' | PLX)* (PN_CHARS | ':' | PLX))?
  // should not add trim() here as the local string should not contain any whitepaces
  Parser PN_LOCAL() =>
      (ref0(PN_CHARS_U) | string(':') | pattern('0-9') | ref0(PLX)) &
      ((ref0(PN_CHARS) | pattern(':.') | ref0(PLX))
                  .starGreedy(ref0(PN_CHARS) | string(':') | ref0(PLX)) &
              (ref0(PN_CHARS) | string(':') | ref0(PLX)))
          .repeat(0, 1);

  // [140s] 	PNAME_LN 	::= 	PNAME_NS PN_LOCAL
  Parser PNAME_LN() => ref0(PNAME_NS) & ref0(PN_LOCAL);

  // [136s] 	PrefixedName 	::= 	PNAME_LN | PNAME_NS
  Parser PrefixedName() => ref0(PNAME_LN) | ref0(PNAME_NS);

  // [135s] 	iri 	::= 	IRIREF | PrefixedName
  Parser iri() => ref0(IRIREF) | ref0(PrefixedName);

  // [159s] 	ECHAR 	::= 	'\' [tbnrf"'\]
  Parser ECHAR() => pattern('\\') & pattern('tbnrf"\'\\');

  // [22] 	STRING_LITERAL_QUOTE 	::= 	'"' ([^#x22#x5C#xA#xD] | ECHAR | UCHAR)* '"' /* #x22=" #x5C=\ #xA=new line #xD=carriage return */
  Parser STRING_LITERAL_QUOTE() =>
      pattern('"') &
      (pattern('^\x22\x5C\x0A\x0D') | ref0(ECHAR) | ref0(UCHAR)).star() &
      pattern('"');

  // [23] 	STRING_LITERAL_SINGLE_QUOTE 	::= 	"'" ([^#x27#x5C#xA#xD] | ECHAR | UCHAR)* "'" /* #x27=' #x5C=\ #xA=new line #xD=carriage return */
  Parser STRING_LITERAL_SINGLE_QUOTE() =>
      pattern('\'') &
      (pattern('^\x27\x5C\x0A\x0D') | ref0(ECHAR) | ref0(UCHAR)).star() &
      pattern('\'');

  // [24] 	STRING_LITERAL_LONG_SINGLE_QUOTE 	::= 	"'''" (("'" | "''")? ([^'\] | ECHAR | UCHAR))* "'''"
  Parser STRING_LITERAL_LONG_SINGLE_QUOTE() =>
      pattern('\'').times(3) &
      ((pattern('\'') | pattern('\'').times(2)).repeat(0, 1) &
              (pattern('^\'\\') | ref0(ECHAR) | ref0(UCHAR)))
          .star() &
      pattern('\'').times(3);

  // [25] 	STRING_LITERAL_LONG_QUOTE 	::= 	'"""' (('"' | '""')? ([^"\] | ECHAR | UCHAR))* '"""'
  Parser STRING_LITERAL_LONG_QUOTE() =>
      pattern('"').times(3) &
      ((pattern('"') | pattern('"').times(2)).repeat(0, 1) &
              (pattern('^"\\') | ref0(ECHAR) | ref0(UCHAR)))
          .star() &
      pattern('"').times(3);

  // [17] 	STRING 	::= 	STRING_LITERAL_QUOTE | STRING_LITERAL_SINGLE_QUOTE | STRING_LITERAL_LONG_SINGLE_QUOTE | STRING_LITERAL_LONG_QUOTE
  Parser STRING() =>
      ref0(STRING_LITERAL_QUOTE) |
      ref0(STRING_LITERAL_SINGLE_QUOTE) |
      ref0(STRING_LITERAL_LONG_SINGLE_QUOTE) |
      ref0(STRING_LITERAL_LONG_QUOTE);

  // [133s] 	BooleanLiteral 	::= 	'true' | 'false'
  Parser BooleanLiteral() => string('true') | string('false');

  // [144s] 	LANGTAG 	::= 	'@' [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*
  Parser LANGTAG() =>
      pattern('@') &
      pattern('a-zA-Z').plus() &
      (pattern('-') & pattern('a-zA-Z0-9').plus()).star();

  // [128s] 	RDFLiteral 	::= 	STRING (LANGTAG | '^^' iri)?
  Parser RDFLiteral() =>
      ref0(STRING) & (ref0(LANGTAG) | string('^^') & ref0(iri)).repeat(0, 1);

  // [19] 	INTEGER 	::= 	[+-]? [0-9]+
  Parser INTEGER() => pattern('+-').repeat(0, 1) & pattern('0-9').plus();

  // [20] 	DECIMAL 	::= 	[+-]? [0-9]* '.' [0-9]+
  Parser DECEMAL() =>
      pattern('+-').repeat(0, 1) &
      pattern('0-9').star() &
      string('.') &
      pattern('0-9').plus();

  // [154s] 	EXPONENT 	::= 	[eE] [+-]? [0-9]+
  Parser EXPONENT() =>
      pattern('eE') & pattern('+-').repeat(0, 1) & pattern('0-9').plus();

  // [21] 	DOUBLE 	::= 	[+-]? ([0-9]+ '.' [0-9]* EXPONENT | '.' [0-9]+ EXPONENT | [0-9]+ EXPONENT)
  Parser DOUBLE() =>
      pattern('+-').repeat(0, 1) &
      ((pattern('0-9').plus() &
              string('.') &
              pattern('0-9').star() &
              ref0(EXPONENT)) |
          (string('.') & pattern('0-9').plus() & ref0(EXPONENT)) |
          (pattern('0-9').plus() & ref0(EXPONENT)));

  // [16] 	NumericLiteral 	::= 	INTEGER | DECIMAL | DOUBLE
  Parser NumerialLiteral() => ref0(INTEGER) | ref0(DECEMAL) | ref0(DOUBLE);

  // [13] 	literal 	::= 	RDFLiteral | NumericLiteral | BooleanLiteral
  Parser literal() =>
      ref0(RDFLiteral) | ref0(NumerialLiteral) | ref0(BooleanLiteral);

  // [11] 	predicate 	::= 	iri
  Parser predicate() => ref0(iri);

  // [9] 	verb 	::= 	predicate | 'a'
  Parser verb() => ref0(predicate) | string('a');

  // [141s] 	BLANK_NODE_LABEL 	::= 	'_:' (PN_CHARS_U | [0-9]) ((PN_CHARS | '.')* PN_CHARS)?
  Parser BLANK_NODE_LABEL() =>
      string('_:') &
      (ref0(PN_CHARS_U) | pattern('0-9')) &
      ((ref0(PN_CHARS) | string('.')).starGreedy(ref0(PN_CHARS)) &
              ref0(PN_CHARS))
          .repeat(0, 1);

  // [161s] 	WS 	::= 	#x20 | #x9 | #xD | #xA /* #x20=space #x9=character tabulation #xD=carriage return #xA=new line */
  Parser WS() => pattern('\x20\x09\x0D\x0A');

  // [162s] 	ANON 	::= 	'[' WS* ']'
  Parser ANON() => string('[') & ref0(WS).star() & string(']');

  // [137s] 	BlankNode 	::= 	BLANK_NODE_LABEL | ANON
  Parser BlankNode() => ref0(BLANK_NODE_LABEL) | ref0(ANON);

  // [15] 	collection 	::= 	'(' object* ')'
  Parser collection() => string('(') & ref0(object).star().trim() & string(')');

  // [12] 	object 	::= 	iri | BlankNode | collection | blankNodePropertyList | literal
  Parser object() =>
      ref0(iri) |
      ref0(BlankNode) |
      ref0(collection) |
      ref0(blankNodePropertyList) |
      ref0(literal);

  // [7] 	predicateObjectList 	::= 	verb objectList (';' (verb objectList)?)*
  // should trim after every element in between the expression
  Parser predicateObjectList() =>
      ref0(verb) &
      ref0(objectList).trim() &
      (string(';').trim() &
              (ref0(verb).trim() & ref0(objectList).trim()).repeat(0, 1).trim())
          .star()
          .trim();

  // [8] 	objectList 	::= 	object (',' object)*
  Parser objectList() =>
      ref0(object) & (string(',').trim() & ref0(object)).star().trim();

  // [14] 	blankNodePropertyList 	::= 	'[' predicateObjectList ']'
  Parser blankNodePropertyList() =>
      string('[') & ref0(predicateObjectList).trim() & string(']');

  // [10] 	subject 	::= 	iri | BlankNode | collection
  Parser subject() => ref0(iri) | ref0(BlankNode) | ref0(collection);

  // [6] 	triples 	::= 	subject predicateObjectList | blankNodePropertyList predicateObjectList?
  Parser triples() =>
      (ref0(subject) & ref0(predicateObjectList).trim()) |
      (ref0(blankNodePropertyList) &
          ref0(predicateObjectList).repeat(0, 1).trim());

  // [6s] 	sparqlPrefix 	::= 	"PREFIX" PNAME_NS IRIREF
  Parser sparqlPrefix() => string('PREFIX') & ref0(PNAME_NS) & ref0(IRIREF);

  // [5s] 	sparqlBase 	::= 	"BASE" IRIREF
  Parser sparqlBase() => string('BASE') & ref0(IRIREF);

  // [5] 	base 	::= 	'@base' IRIREF '.'
  Parser base() => string('@base') & ref0(IRIREF).trim() & string('.');

  // [4] 	prefixID 	::= 	'@prefix' PNAME_NS IRIREF '.'
  Parser prefixID() =>
      string('@prefix') &
      ref0(PNAME_NS).trim() &
      ref0(IRIREF).trim() &
      string('.').trim();

  // [3] 	directive 	::= 	prefixID | base | sparqlPrefix | sparqlBase
  Parser directive() =>
      ref0(prefixID) | ref0(base) | ref0(sparqlPrefix) | ref0(sparqlBase);

  // [2] 	statement 	::= 	directive | triples '.'
  Parser statement() =>
      ref0(directive).trim() | (ref0(triples) & string('.')).trim();

  // [1] 	turtleDoc 	::= 	statement*
  Parser turtleDoc() => ref0(statement).star();
}

main() {
  // local tests for expression definition and evaluator definition classes

  final definition = ExpressionDefinition();
  final parser = definition.build();
  final result = parser.parse('''
<http://example.org/donna> rdf:type foaf:Person ;
foaf:nick "donna"@en ; foaf:name "Donna Fales"^^xsd:string ;
    foaf:mbox <mailto:donna@example.org> .

<http://example.org/edward> rdf:type foaf:Person ;
    foaf:nick "ed"^^xsd:string ; foaf:name "Edward Scissorhands"^^xsd:string ; foaf:mbox "e.scissorhands@example.org"^^xsd:anyURI .

     @base <www.ex.co> .
    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
   @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
  @prefix foaf: <http://xmlns.com/foaf/0.1/> .
    ''');
  print(result);
  print(result.value.length);
}
