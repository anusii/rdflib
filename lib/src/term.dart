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

  /// construct an instance from a full uri which is ofter handier
  ///
  /// need to find a way to extract base in the future
  URIRef.fullUri(this.value) : base = '' {
    checkUri();
  }

  /// check valid uri
  ///
  /// log a warning if uri seems invalid
  void checkUri() {
    String warningInfo =
        'this uri may not be valid, it may break the code later';
    if (!isValidUri(value)) {
      logger.warning(warningInfo);
      print(warningInfo);
    }
  }

  /// extract fragment after '#'
  String fragment() {
    return Uri.parse(value).fragment;
  }

  // add attribute to form a concrete URIRef
  //
  // returns a new instance,
  // e.g., URIRef.fullUri('http://example.org').slash('donna')
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

  /// check if a uri if valid based on the discussion in stackoverflow
  ///
  /// ref: https://stackoverflow.com/questions/52975739/dart-flutter-validating-a-string-for-url
  bool isValidUri(String uri) {
    // TODO: find a robust way to validate uri
    var u = Uri.tryParse(uri);
    return u?.hasAbsolutePath != null &&
        u?.scheme != null &&
        u!.scheme.startsWith('http');
  }

  /// check if a full URIRef contains the namespace
  ///
  /// can be useful in serializing process
  bool inNamespace(Namespace ns) {
    return value.startsWith(ns.ns);
  }

  /// this is just for debug purpose for now
  @override
  String toString() {
    // return raw form of URIRef instance
    return '$runtimeType($value)';
  }
}
