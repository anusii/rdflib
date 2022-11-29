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
