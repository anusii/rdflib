import './term.dart';

class Namespace {
  final String ns;
  final URIRef? uriRef;

  Namespace({required this.ns}) : uriRef = URIRef.fullUri(ns);

  URIRef withAttr(String attr) {
    return URIRef.fullUri(ns + attr);
  }
}

final URIRef rdfProperty =
    URIRef.fullUri('http://www.w3.org/1999/02/22-rdf-syntax-ns/');

class RDF {
  static URIRef type = rdfProperty.slash('#type');
}

final URIRef foafProperty = URIRef.fullUri('http://xmlns.com/foaf/0.1/');

class FOAF {
  static URIRef Person = foafProperty.slash('Person');
  static URIRef nick = foafProperty.slash('nick');
  static URIRef name = foafProperty.slash('name');
  static URIRef mbox = foafProperty.slash('mbox');
}
