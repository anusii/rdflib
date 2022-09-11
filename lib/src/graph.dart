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
