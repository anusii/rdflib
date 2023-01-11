import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/grammar_parser.dart';

main() {
  final evaluatorDef = EvaluatorDefinition();
  final evaluatorParser = evaluatorDef.build();
  group("""[4] 	prefixID 	::= 	'@prefix' PNAME_NS IRIREF '.'""", () {
    Map<String, List> testStrings = {
      '@prefix : </etc/> .\n@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .':
          [
        ['@prefix', ':', '</etc/>', '.'],
        [
          '@prefix',
          'rdf:',
          '<http://www.w3.org/1999/02/22-rdf-syntax-ns#>',
          '.'
        ]
      ],
      '''
      @prefix : </etc/> .
      @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
      ''': [
        ['@prefix', ':', '</etc/>', '.'],
        [
          '@prefix',
          'rdf:',
          '<http://www.w3.org/1999/02/22-rdf-syntax-ns#>',
          '.'
        ]
      ],
      '@prefix c: <./> .': [
        ['@prefix', 'c:', '<./>', '.']
      ],
      '''
      @prefix abc: <https://abc.net.au/> .
      @prefix v2.7: <www.anu.cecs.au/> .
      ''': [
        ['@prefix', 'abc:', '<https://abc.net.au/>', '.'],
        ['@prefix', 'v2.7:', '<www.anu.cecs.au/>', '.']
      ],
    };
    testStrings.keys.forEach((element) {
      List actual = evaluatorParser.parse(element).value;
      List expected = testStrings[element]!;
      print('prefixID $element - actual: $actual, expected: $expected');
      test('prefixID case $element', () {
        expect(actual, expected);
      });
    });
  });
}
