import 'package:rdflib/rdflib.dart';

main() async {
  String filePath = 'example/ex_full_original.ttl';

  // create a graph to read turtle file and store info
  Graph g = Graph();
  await g.parse(filePath);

  // full format of triples (will use shorthand in serialization/export)
  for (Triple t in g.triples) {
    print(t);
  }

  // verify contexts
  print('Contexts: ${g.contexts}');

  // export it to a new file (should be equivalent to the original one)
  g.serialize(format: 'ttl', dest: 'example/ex_full_processed.ttl');
}
