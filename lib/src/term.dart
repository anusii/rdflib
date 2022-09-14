import 'package:logging/logging.dart';

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
    if (!isValidUri(value)) {
      logger.warning('this uri may not be valid, it may break the code later');
    }
    // else if (!value.endsWith("#")) {
    //   value += '#';
    // }
  }

  String fragment() {
    return Uri.parse(value).fragment;
  }

  void slash(String name) {
    if (name.startsWith('/')) {
      name = name.substring(1);
    }
    // TODO: check if there's invalid char in name
    // update value
    value += name;
  }

  bool isValidUri(String uri) {
    return Uri.tryParse(uri)?.hasAbsolutePath ?? false;
  }

  @override
  String toString() {
    // TODO: implement toString
    return value;
  }
}

main() {
  URIRef u1 = URIRef.fullUri('val');
  print(u1);
  URIRef u2 = URIRef(value: '', base: 'http://www.cecs.anu.edu.au/#bob');
  print(u2);
  print(u2.fragment());
}
