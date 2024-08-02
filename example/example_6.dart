import 'package:rdflib/rdflib.dart';

main() async {
  String webLink = 'https://www.w3.org/TR/turtle/examples/example3.ttl';

  // Create a graph to read Turtle file and store info.
  Graph g = Graph();

  // Parse the Turtle file from the web.
  await g.parseTurtleFromWeb(webLink);

  // Serialize the Graph for output.
  g.serialize(format: 'ttl', abbr: 'short');
  print('-------Serialized String--------\n${g.serializedString}');

  // Print out full format of triples (will use shorthand in serialization/export).
  print('--------All triples in the graph-------');
  for (Triple t in g.triples) {
    print(t);
  }
}
