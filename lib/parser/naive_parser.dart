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
