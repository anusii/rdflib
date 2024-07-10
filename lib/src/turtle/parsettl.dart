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

/// Parses a TTL (Terse RDF Triple Language) string [ttlStr] and returns
/// the key-value pairs from triples where the subject matches [webId].
///
/// This function processes the provided TTL string and extracts the key-value,
/// based on the given Web ID. It ensures there are no duplicate keys for the 
/// same subject.
///
/// Example usage:
/// ```dart
/// final ttlStr = '''
/// @prefix ex: <http://example.com/> .
/// ex:webID ex:key "value" .
/// ''';
/// final webId = 'http://example.com/webID';
/// final result = await parseTTLStr(ttlStr, webId);
/// print(result);
/// // Output: [{key: key, value: value}]
/// ```
Future<List<({String key, dynamic value})>> parseTTLStr(
    String ttlStr, String? webId) async {
  // Ensure that the TTL string is not empty.
  assert(ttlStr.isNotEmpty, 'The TTL string should not be empty.');

  // Create a new graph instance and parse the TTL content into it.
  final g = Graph();
  g.parseTurtle(ttlStr);

  // Initialize a set to track unique keys and a list to store key-value pairs.
  final keys = <String>{};
  final pairs = <({String key, dynamic value})>[];

  // Ensure that webId is not null.
  assert(webId != null, 'Web ID should not be null.');
  
  // Helper function to extract the local name from a URI or blank node.
  String extract(String str) => str.contains('#') ? str.split('#')[1] : str;

  // Iterate over all triples in the graph.
  for (final t in g.triples) {
    // Extract the subject from the triple.
    final sub = t.sub.value as String;

    // Check if the subject matches the given webId.
    if (sub == webId) {
      // Extract the predicate and object from the triple.
      final pre = extract(t.pre.value as String);
      final obj = extract(t.obj.value as String);

      // Ensure that the key (predicate) is unique for the subject.
      assert(!keys.contains(pre), 'Duplicate key found for the subject.');

      // Add the key to the set of unique keys and the key-value pair to the list.
      keys.add(pre);
      pairs.add((key: pre, value: obj));
    }
  }

  // Ensure that the parsed TTL content contains at least one matching triple.
  assert(pairs.isNotEmpty, 'No matching triples found for the given Web ID.');

  // Return the list of key-value pairs.
  return pairs;
}
