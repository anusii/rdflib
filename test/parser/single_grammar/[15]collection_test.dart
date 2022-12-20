import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
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
}
