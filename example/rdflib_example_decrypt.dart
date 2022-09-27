import 'package:rdflib/rdflib.dart';

main() async {
  /// create a new graph to hold the data
  Graph g = Graph();

  /// need to use await keyword
  await g.parseEncrypted('example/ex1.enc.ttl', passphrase: 'helloworld!');
  print('Contexts:\n${g.contexts}');
  print('Data:\n${g.triples}');

  /// serialize it to specified location, should be equivalent to original file
  g.serialize(format: 'ttl', dest: 'example/ex1.dec.ttl');
}
