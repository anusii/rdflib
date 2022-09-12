import './term.dart';

class Namespace {
  final String ns;
  final URIRef? uriRef;

  Namespace({required this.ns}) : uriRef = URIRef.fullUri(ns);

  URIRef withAttr(String attr) {
    return URIRef.fullUri(ns + attr);
  }
}

const String rdfAnchor = 'http://www.w3.org/1999/02/22-rdf-syntax-ns/';
final URIRef rdfProperty = URIRef.fullUri(rdfAnchor);

class RDF extends Namespace {
  final ns = rdfAnchor;

  RDF({ns}) : super(ns: ns);
  static URIRef type = rdfProperty.slash('#type');
  static String rdf = rdfAnchor;
}

const String foafAnchor = 'http://xmlns.com/foaf/0.1/';
final URIRef foafProperty = URIRef.fullUri(foafAnchor);

class FOAF extends Namespace {
  final ns = foafAnchor;

  static URIRef Person = foafProperty.slash('Person');
  static URIRef nick = foafProperty.slash('nick');
  static URIRef name = foafProperty.slash('name');
  static URIRef mbox = foafProperty.slash('mbox');
  static String foaf = foafAnchor;

  FOAF({required super.ns});
}
