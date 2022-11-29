import 'package:petitparser/petitparser.dart';
import 'package:rdflib/rdflib.dart';

class IrirefExpDefinition extends GrammarDefinition {
  @override
  Parser start() {
    return ref0(iriref).end();
  }

  Parser iriref() =>
      pattern('<') &
      (ref0(nonSpecialChar) | ref0(uchar)).star().trim() &
      pattern('>');

  Parser nonSpecialChar() => pattern('^\x00-\x20<>"{}|^`\\');

  Parser uchar() => ((string('\\u') & ref0(hex).times(4)) |
      (string('\\U') & ref0(hex).times(8)));

  Parser hex() => pattern('a-f') | pattern('A-F') | pattern('0-9');
}

class IrirefEvaluatorDefinition extends IrirefExpDefinition {
  Parser iriref() => super.iriref().map((values) => URIRef(values[1].join()));
}

main() {
  // local tests for expression definition and evaluator definition classes
  final irirefDef = IrirefExpDefinition();
  final parser = irirefDef.build();
  print(parser.parse('<www.ex.org>'));

  final irirefEvDef = IrirefEvaluatorDefinition();
  final evParser = irirefEvDef.build();
  // extract the parser result by value and typecast
  URIRef uriRef = evParser.parse('<www.ex.org>').value as URIRef;
  print(uriRef.value);
}
