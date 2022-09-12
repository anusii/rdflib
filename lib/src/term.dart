import 'package:logging/logging.dart';
import 'package:rdfgraph/src/namespace.dart';

Logger logger = Logger('term');

class URIRef {
  String value;
  String base;

  URIRef({required this.value, required this.base}) {
    value = base + value;
    checkUri();
  }

  URIRef.fullUri(this.value) : base = '' {
    checkUri();
  }

  // check valid uri
  void checkUri() {
    String warningInfo =
        'this uri may not be valid, it may break the code later';
    if (!isValidUri(value)) {
      logger.warning(warningInfo);
      print(warningInfo);
    }
  }

  String fragment() {
    // extract fragment after '#'
    return Uri.parse(value).fragment;
  }

  // add attribute, e.g., URIRef.fullUri('http://example.org').slash('donna')
  URIRef slash(String name) {
    if (name.startsWith('/') && value.endsWith('/')) {
      name = name.substring(1);
    } else if (!name.startsWith('/') && !value.endsWith('/')) {
      name = '/' + name;
    }
    // TODO: check if there's invalid char in name
    // update value
    return URIRef.fullUri(value + name);
  }

  bool isValidUri(String uri) {
    // TODO: find a robust way to validate uri
    return Uri.tryParse(uri)?.hasAbsolutePath ?? false;
  }

  bool inNamespace(Namespace ns) {
    return value.startsWith(ns.ns);
  }

  @override
  String toString() {
    // return raw form of URIRef instance
    return '$runtimeType($value)';
  }
}
