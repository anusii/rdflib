import 'package:rdfgraph/rdfgraph.dart';

main() async {
  String filePath = 'example/ex1.ttl';
  // create a graph to read turtle file and store info
  Graph g = Graph();
  await g.parse(filePath);
  // full format of triples (will use shorthand in serialization/export)
  for (Triple t in g.triples) {
    print(t);
  }
  // export it to a new file (should equivalent to the original one)
  g.serialize(format: 'ttl', dest: 'example/ex3.ttl');
}
