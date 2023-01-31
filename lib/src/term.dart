import 'package:logging/logging.dart';
import './namespace.dart';

Logger logger = Logger('term');

class URIRef {
  String value;
  String? base;

  /// Modifies default constructor's base to be optional.
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

  /// Constructs an instance from a full uri which is often handier.
  ///
  /// TODO: find a way to extract base used in a Graph.
  URIRef.fullUri(this.value) : base = '' {
    checkUri();
  }

  /// Sets a different base with some limitations.
  void updateBase({required String newBase}) {
    if (!value.startsWith(newBase)) {
      /// If new base is not contained in value, all existed URIRefs have to
      /// update values, so it's not allowed in this case for now.
      throw Exception('new base is not in original uri, forbidden');
    } else {
      base = newBase;
    }
  }

  /// Checks valid uri and log relevant information.
  void checkUri() {
    String warningInfo =
        'this uri may not be valid, it may break the code later';
    if (!isValidUri(value)) {
      logger.warning(warningInfo);
    }
  }

  /// Extracts fragment after '#' for a valid URI.
  String fragment() {
    return Uri.parse(value).fragment;
  }

  /// Adds attribute to form a concrete URIRef
  ///
  /// Returns a new instance.
  /// For example: URIRef.fullUri('http://example.org').slash('donna').
  URIRef slash(String name) {
    // Check if there's any delimiter such as '/' or '#' in the end.
    if (name.startsWith('/') && value.endsWith('/')) {
      name = name.substring(1);
    } else if (!name.startsWith('/') &&
        !value.endsWith('/') &&
        !value.endsWith('#')) {
      name = '/' + name;
    }

    /// TODO: check if there's invalid char in name, may use uri parser as an
    /// alternative way for turtle.
    return URIRef.fullUri(value + name);
  }

  /// Checks if a uri if valid based on the discussion in stackoverflow.
  ///
  /// Reference:
  /// https://stackoverflow.com/questions/52975739/dart-flutter-validating-a-string-for-url
  static bool isValidUri(String uri) {
    // TODO: find a robust way to validate uri
    var u = Uri.tryParse(uri);
    return u?.hasAbsolutePath != null &&
        u?.scheme != null &&
        u!.scheme.startsWith('http');
  }

  /// Uses value as the main identifier, useful for saving URIRef type in set.
  @override
  int get hashCode => value.hashCode;

  /// Two URIRef instances are equal if they have the same value/hashcode.
  @override
  bool operator ==(Object other) {
    return other is URIRef &&
        runtimeType == other.runtimeType &&
        value == other.value;
  }

  /// Checks if a full URIRef contains the namespace.
  bool inNamespace(Namespace ns) {
    return value.startsWith(ns.ns);
  }

  @override
  String toString() {
    // Return raw form of URIRef instance.
    // Note: this is mainly for debug purpose for now.
    return '$runtimeType($value)';
  }
}

class Literal {
  final String value;
  URIRef? datatype;
  String? lang;

  Literal(this.value, {this.datatype, this.lang}) {
    if (datatype != null && lang != null) {
      throw Exception('A Literal can only have one of lang or datatype,\n'
          'per http://www.w3.org/TR/rdf-concepts/#section-Graph-Literal');
    } else if (datatype == null && lang == null) {
      /// Check for default data types including numeric and datetime
      if (_isInteger(value)) {
        datatype = XSD.int;
      } else if (_isDouble(value)) {
        // Default to float instead of double for now.
        // TODO: differentiate between float and double.
        datatype = XSD.float;
      } else if (_isDateTime(value)) {
        datatype = XSD.dateTime;
      } else if (_isDateTimeStamp(value)) {
        datatype = XSD.dateTimeStamp;
      } else {
        datatype = XSD.string;
      }
    }
  }

  /// Converts a Literal to a turtle format for an object.
  ///
  /// Can extend to more common cases specified in W3 docs for convenience.
  String toTtl() {
    String subType = 'Conversion to ttl not implemented!';
    if (lang != null) {
      return '\"$value\"@$lang';
    } else if (datatype!.inNamespace(XSD(ns: XSD.xsd))) {
      subType = datatype!.value.substring(XSD.xsd.length);
      return '\"$value\"^^xsd:$subType';
    } else if (datatype!.inNamespace(OWL(ns: OWL.owl)) && value == '') {
      // Naive way of handling a general owl type.
      return 'owl:${datatype!.value.substring(OWL.owl.length)}';
    } else {
      throw Exception('$subType');
    }
  }

  /// Helper function to make Literal more robust to read float/double numbers.
  bool _isDouble(String s) {
    return double.tryParse(s) != null && !_isInteger(s);
  }

  /// Helper function to make Literal more robust to read integers.
  bool _isInteger(String s) {
    return int.tryParse(s) != null;
  }

  /// Helper function to make Literal more robust to read datetime.
  bool _isDateTimeStamp(String s) {
    return DateTime.tryParse(s) != null && s.endsWith('Z');
  }

  /// Helper function to make Literal more robust to read datetime.
  bool _isDateTime(String s) {
    return DateTime.tryParse(s) != null && !s.endsWith('Z');
  }

  /// Uses toString() to distinguish between different Literals.
  @override
  int get hashCode => toString().hashCode;

  /// Checks if two triples are equal when adding them to a set.
  @override
  bool operator ==(Object other) {
    return other is Literal &&
        runtimeType == other.runtimeType &&
        value == other.value &&
        datatype == other.datatype &&
        lang == other.lang;
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
