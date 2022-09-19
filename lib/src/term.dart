import 'package:logging/logging.dart';
import 'package:rdfgraph/src/namespace.dart';

Logger logger = Logger('term');

class URIRef {
  String value;
  String? base;

  /// modify default constructor's base to be optional
  URIRef(this.value, {this.base}) {
    if (base == null) {
      base = '';
    } else {
      if (!base!.endsWith('/') || !base!.endsWith('#')) {
        base = base! + '/';
      }
    }
    value = base! + value;
    checkUri();
  }

  /// construct an instance from a full uri which is ofter handier
  ///
  /// need to find a way to extract base in the future
  URIRef.fullUri(this.value) : base = '' {
    checkUri();
  }

  /// set a different base
  void updateBase({required String newBase}) {
    if (!value.startsWith(newBase)) {
      /// if new base is not contained in value, all existed URIRefs have to update values
      /// so it's not allowed in this case
      throw Exception('new base is not in original uri, forbidden');
    } else {
      base = newBase;
    }
  }

  /// check valid uri
  ///
  /// log a warning if uri seems invalid
  void checkUri() {
    String warningInfo =
        'this uri may not be valid, it may break the code later';
    if (!isValidUri(value)) {
      logger.warning(warningInfo);
      // print(warningInfo);
    }
  }

  /// extract fragment after '#'
  String fragment() {
    return Uri.parse(value).fragment;
  }

  /// add attribute to form a concrete URIRef
  ///
  /// returns a new instance, e.g., URIRef.fullUri('http://example.org').slash('donna')
  URIRef slash(String name) {
    /// check if there's any delimiter such as '/' or '#' in the end
    if (name.startsWith('/') && value.endsWith('/')) {
      name = name.substring(1);
    } else if (!name.startsWith('/') &&
        !value.endsWith('/') &&
        !value.endsWith('#')) {
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

  /// two URIRef are equal if they have the same value
  @override
  bool operator ==(Object other) {
    return other is URIRef &&
        runtimeType == other.runtimeType &&
        value == other.value;
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

class Literal {
  final String value;
  URIRef? datatype;
  String? lang;

  Literal(this.value, {this.datatype, this.lang}) {
    if (datatype != null && lang != null) {
      throw Exception(
          'A Literal can only have one of lang or datatype, per http://www.w3.org/TR/rdf-concepts/#section-Graph-Literal');
    } else if (datatype == null && lang == null) {
      datatype = XSD.string;
    }
  }

  /// convert a Literal to a turtle format for an object
  String toTtl() {
    String subType = 'Conversion to ttl not implemented!';
    if (lang != null) {
      return '\"$value\"@$lang';
    } else if (datatype!.inNamespace(XSD(ns: XSD.xsd))) {
      subType = datatype!.value.substring(XSD.xsd.length);
      return '\"$value\"^^xsd:$subType';
    } else {
      throw Exception('$subType');
    }
  }

  @override
  String toString() {
    if (datatype != null) {
      return 'Literal($value, datatype: $datatype)';
    } else {
      return 'Literal($value, lang: $lang)';
    }
  }
}
