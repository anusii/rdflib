import 'package:http/http.dart' as http;

import 'package:rdflib/rdflib.dart';

main() async {
  // https://github.com/anusii/rdflib/blob/main/example/sample_acl_1.acl
  // https://raw.githubusercontent.com/anusii/rdflib/main/example/sample_acl_1.acl
  var url = Uri.https('raw.githubusercontent.com',
      'anusii/rdflib/main/example/sample_acl_1.acl');
  // Get the contents of the acl file
  var res = await http.get(url);
  String aclContents = res.body;
  print('-------Original ACL Contents-------\n${res.body}\n');

  // Initialize a Graph to store all the info
  Graph g = Graph();
  // Parse the contents and update the triples
  g.parseTurtle(aclContents);
  g.serialize(format: 'ttl', abbr: 'short');
  print('-------Serialized ACL Contents------\n${g.serializedString}\n');

  // Add 'zack' to the ACL file
  g.addTripleToGroups('<#zack>', a, 'acl:Authorization');
  // Specify which document/fold
  g.addTripleToGroups('<#zack>', 'acl:accessTo', '<./README>');
  // Specify the target by its webID card
  g.addTripleToGroups('<#zack>', 'acl:agent',
      '<https://solid.dev.yarrabah.net/zack-collins/profile/card#me>');
  // Grant him access to Read only
  g.addTripleToGroups('<#zack>', 'acl:mode', 'acl:Read');
  // Need to serialize before exporting
  g.serialize(format: 'ttl', abbr: 'short');
  print('-------Serialized ACL Contents (New)------\n${g.serializedString}\n');
}
