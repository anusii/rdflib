import './term.dart';

class Namespace {
  final String ns;
  final URIRef? uriRef;

  Namespace({required this.ns}) : uriRef=URIRef.fullUri(ns);

  URIRef withAttr(String attr) {
    return URIRef.fullUri(ns + attr);
  }

}