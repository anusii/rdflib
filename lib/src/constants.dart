enum BaseType { shorthandBase, defaultBase }

extension ParseToString on BaseType {
  String get name => this.toString().split('.').last;
}

// keyword @base
const BASE = 'BASE';

/// Most common namespace addresses including RDF, FOAF, XSD, RDFS, OWL
///
/// Reference:
/// [1]: Reserved Vocabulary of OWL 2 - https://www.w3.org/TR/owl-syntax/#IRIs
/// [2]: Built-in datatypes and definitions (XSD is preferred): https://www.w3.org/TR/xmlschema11-2/#built-in-datatypes
/// [3]: XSD datatypes: https://www.w3.org/2011/rdf-wg/wiki/XSD_Datatypes
const String rdfAnchor = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
const String foafAnchor = 'http://xmlns.com/foaf/0.1/';
const String xsdAnchor = 'http://www.w3.org/2001/XMLSchema#';
const String rdfsAnchor = 'http://www.w3.org/2000/01/rdf-schema#';
const String owlAnchor = 'http://www.w3.org/2002/07/owl#';
