import './term.dart';
import './triple.dart';

class Graph {
  List<Map> graphs = [];
  Map contexts = {};
  Set triples = {};

  void add(Triple triple) {
      triples.add(triple);
  }
}

main() {
  Graph g = Graph();
  g.add(Triple(sub: URIRef.fullUri('s'), pre: URIRef.fullUri('p'), obj: 'o'));
  print(g.triples);
  g.add(Triple(sub: URIRef.fullUri('s'), pre: URIRef.fullUri('p'), obj: 'o'));
  print(g.triples);
  g.add(Triple(sub: URIRef.fullUri('s'), pre: URIRef.fullUri('p'), obj: 'o'));
  print(g.triples);
}