import 'package:petitparser/petitparser.dart';

class ExpressionDefinition extends GrammarDefinition {
  Parser start() => ref0(term).end();

  Parser term() => ref0(add) | ref0(prod);

  Parser add() => ref0(prod) & char('+').trim() & ref0(term);

  Parser prod() => ref0(mul) | ref0(prim);

  Parser mul() => ref0(prim) & char('*').trim() & ref0(prod);

  Parser prim() => ref0(parens) | ref0(number);

  Parser parens() => char('(').trim() & ref0(term) & char(')').trim();

  Parser number() => digit().plus().flatten().trim();
}

class EvaluatorDefinition extends ExpressionDefinition {
  final lst = [];
  final addLst = [];
  final mulLst = [];
  final parensLst = [];
  final numberLst = [];

  // Parser add() => super.add().map((values) => values[0] + values[2]);
  Parser add() => super.add().map((values) {
        int rtn = values[0] + values[2];
        lst.add(rtn);
        return rtn;
      });

  Parser mul() => super.mul().map((values) => values[0] * values[2]);

  Parser parens() => super.parens().castList<num>().pick(1);

  Parser number() => super.number().map((value) {
        int rtn = int.parse(value);
        numberLst.add(rtn);
        return rtn;
      });
}

main() {
  final definition = EvaluatorDefinition();
  final parser = definition.build();
  print(parser.parse('1 + (2 + 5) * (3+9)'));
  print(definition.numberLst);
  print(definition.lst);

  // final definition = ExpressionDefinition();
  // final parser = definition.build();
  // print(parser.parse('1 + (2+5) * 3'));
}
