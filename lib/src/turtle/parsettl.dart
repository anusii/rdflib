import '../graph.dart';

/// Parses Turtle (Terse RDF Triple Language) content and extracts it into a map.
///
/// This function processes the provided Turtle content string. It uses a graph-based
/// approach to parse the Turtle data and extract key attributes and their values.
/// The resulting map will have subjects as keys, and their corresponding predicates
/// and objects as nested key-value pairs.
///
/// Example usage:
/// ```dart
/// final ttlContent = '''
/// @prefix ex: <http://example.com/> .
/// ex:subject ex:predicate "object" .
/// ''';
/// final data = parseTTL(ttlContent);
/// print(data);
/// // Output: {subject: {predicate: object}}
/// ```
Map<String, dynamic> parseTTL(String ttlContent) {
  // Create a new graph instance and parse the Turtle content into it.
  final g = Graph();
  g.parseTurtle(ttlContent);

  // Initialize an empty map to store the parsed data.
  final dataMap = <String, dynamic>{};

  // A helper function to extract the local name from a URI or blank node.
  String extract(String str) => str.contains('#') ? str.split('#')[1] : str;

  // Iterate over all triples in the graph.
  for (final t in g.triples) {
    // Extract the subject, predicate, and object from the triple.
    final sub = extract(t.sub.value as String);
    final pre = extract(t.pre.value as String);
    final obj = extract(t.obj.value as String);

    // Check if the subject already exists in the map.
    if (dataMap.containsKey(sub)) {
      // Ensure that the predicate does not already exist for the subject.
      assert(!(dataMap[sub] as Map).containsKey(pre));
      // Add the predicate and object to the existing subject entry.
      dataMap[sub][pre] = obj;
    } else {
      // Create a new entry for the subject with the predicate and object.
      dataMap[sub] = {pre: obj};
    }
  }

  // Return the populated map.
  return dataMap;
}
