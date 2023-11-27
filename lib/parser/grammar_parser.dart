import 'package:petitparser/petitparser.dart';

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
  Parser DECIMAL() =>
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
  // rearrange the order as INTEGER will greedy match for the default sequence
  Parser NumericalLiteral() => ref0(DOUBLE) | ref0(DECIMAL) | ref0(INTEGER);

  // [13] 	literal 	::= 	RDFLiteral | NumericLiteral | BooleanLiteral
  Parser literal() =>
      ref0(RDFLiteral) | ref0(NumericalLiteral) | ref0(BooleanLiteral);

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
  // need clarification in whitespaces between two objects.
  // based on the example here: https://www.w3.org/TR/turtle/#collections,
  // there can be whitespaces, but it's not consistent.
  // e.g. in [20] 	DECIMAL 	::= 	[+-]? [0-9]* '.' [0-9]+
  // the [0-9]* part can't have any whitespaces in between
  Parser collection() => string('(') & ref0(object).trim().star() & string(')');

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
  // Keywords in double quotes ("BASE", "PREFIX") are case-insensitive.
  // refer to: https://www.w3.org/TR/turtle/#sec-grammar-grammar
  Parser sparqlPrefix() =>
      stringIgnoreCase('PREFIX') & ref0(PNAME_NS).trim() & ref0(IRIREF);

  // [5s] 	sparqlBase 	::= 	"BASE" IRIREF
  Parser sparqlBase() => stringIgnoreCase('BASE') & ref0(IRIREF).trim();

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

class EvaluatorDefinition extends ExpressionDefinition {
  // extract IRIREF => <iriref>
  Parser IRIREF() => super.IRIREF().map((values) {
        List iriref = values[1] as List;
        String irirefStr = iriref.join();
        return '<$irirefStr>';
      });

  // extract PN_PREFIX => flattened string
  Parser PN_PREFIX() => super.PN_PREFIX().map((values) {
        return '${values[0]}${flattenList(values[1]).join()}';
      });

  // extract PNAME_NS => prefix:
  Parser PNAME_NS() => super.PNAME_NS().map((values) {
        return '${values[0].join()}${values[1]}';
      });

  // extract prefixID => @prefix PNAME_NS IRIREF .
  Parser prefixID() => super.prefixID().map((values) {
        // return '${values[0]} ${values[1]} ${values[2]} ${values[3]}';
        final prefixIdList = values as List;
        // return prefixIdList.join(' ');
        return prefixIdList;
      });

  // extract
  Parser base() => super.base().map((values) {
        final baseList = values as List;
        // return baseList.join(' ');
        return baseList;
      });

  // extract PERCENT =>
  Parser PERCENT() => super.PERCENT().map((values) {
        final hexList = values[1] as List;
        return '${values[0]}${hexList.join()}';
      });

  // extract PN_LOCAL
  Parser PN_LOCAL() => super.PN_LOCAL().map((values) {
        final first = values[0];
        final remainingList = values[1] as List;
        final remaining = flattenList(remainingList).join();
        return '$first$remaining';
      });

  // extract PNAME_LN =>
  Parser PNAME_LN() => super.PNAME_LN().map((values) {
        final pNameLocal = '${values[0]}${values[1]}';
        return pNameLocal;
      });

  // extract PrefixedName =>
  Parser PrefixedName() => super.PrefixedName().map((values) {
        return values;
      });

  // extract objectList =>
  Parser objectList() => super.objectList().map((values) {
        final rtnList = [];
        final firstObject = values[0];
        rtnList.add(firstObject);
        final restObjects = values[1] as List;
        for (var i = 0; i < restObjects.length; i++) {
          rtnList.add(restObjects[i][1]);
        }
        return rtnList;
      });

  // extract predicateObjectList =>
  Parser predicateObjectList() => super.predicateObjectList().map((values) {
        final rtnList = [];
        final firstPreObj = [values[0], values[1]];
        rtnList.add(firstPreObj);
        final restPreObjs = values[2] as List;
        for (var i = 0; i < restPreObjs.length; i++) {
          rtnList.add(restPreObjs[i][1][0]);
        }
        return rtnList;
      });

  // // extract RDFLiteral =>
  Parser RDFLiteral() => super.RDFLiteral().map((values) {
        String rtnStr = '';
        rtnStr += values[0];
        rtnStr += flattenList(values[1] as List).join();
        return rtnStr;
      });

  // extract STRING =>
  Parser STRING_LITERAL_QUOTE() => super.STRING_LITERAL_QUOTE().map((values) {
        return (values[1] as List).join();
      });

  Parser STRING_LITERAL_SINGLE_QUOTE() =>
      super.STRING_LITERAL_SINGLE_QUOTE().map((values) {
        return (values[1] as List).join();
      });

  Parser STRING_LITERAL_LONG_SINGLE_QUOTE() =>
      super.STRING_LITERAL_LONG_SINGLE_QUOTE().map((values) {
        return flattenList(values[1] as List).join();
      });

  Parser STRING_LITERAL_LONG_QUOTE() =>
      super.STRING_LITERAL_LONG_QUOTE().map((values) {
        return flattenList(values[1] as List).join();
      });

  // extract NumericalLiteral
  Parser NumericalLiteral() => super.NumericalLiteral().map((values) {
        return flattenList(values).join();
      });
}

// helper function to flatten a nested list to a single list recursively
List<dynamic> flattenList(List<dynamic> list) {
  // Keep track of current nesting level, add each element to a new list if it's not a list
  List<dynamic> result = [];

  for (var element in list) {
    if (element is List) {
      // If the element is a list, recursively flatten it
      result.addAll(flattenList(element));
    } else {
      // If the element is not a list, add it to the result list
      result.add(element);
    }
  }

  return result;
}
