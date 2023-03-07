import './term.dart';
import 'constants.dart';

class Namespace {
  final String ns;
  final URIRef? uriRef;

  Namespace({required this.ns}) : uriRef = URIRef.fullUri(ns);

  /// This is used to further shorten the namespace binding
  ///
  /// TODO: note to check validity (not implemented)
  URIRef withAttr(String attr) {
    return URIRef.fullUri(ns + attr);
  }
}

final URIRef _rdf = URIRef.fullUri(rdfAnchor);

/// RDF Schema for the RDF vocabulary terms in the RDF Namespace, defined in RDF 1.1 Concepts.
class RDF extends Namespace {
  final ns = rdfAnchor;
  static final String rdf = rdfAnchor;

  /// http://www.w3.org/1999/02/22-rdf-syntax-ns#List
  static final URIRef nil = _rdf.slash('nil');

  /// http://www.w3.org/1999/02/22-rdf-syntax-ns#Property
  static final URIRef direction = _rdf.slash('direction');
  static final URIRef first = _rdf.slash('first');
  static final URIRef language = _rdf.slash('language');
  static final URIRef object = _rdf.slash('object');
  static final URIRef predicate = _rdf.slash('predicate');
  static final URIRef rest = _rdf.slash('rest');
  static final URIRef subject = _rdf.slash('subject');
  static final URIRef type = _rdf.slash('type');
  static final URIRef value = _rdf.slash('value');

  /// http://www.w3.org/2000/01/rdf-schema#Class
  static final URIRef Alt = _rdf.slash('Alt');
  static final URIRef Bag = _rdf.slash('Bag');
  static final URIRef CompoundLiteral = _rdf.slash('CompoundLiteral');
  static final URIRef List = _rdf.slash('List');
  static final URIRef Property = _rdf.slash('Property');
  static final URIRef Seq = _rdf.slash('Seq');
  static final URIRef Statement = _rdf.slash('Statement');

  /// http://www.w3.org/2000/01/rdf-schema#Datatype
  static final URIRef HTML = _rdf.slash('HTML');
  static final URIRef JSON = _rdf.slash('JSON');
  static final URIRef PlainLiteral = _rdf.slash('PlainLiteral');
  static final URIRef XMLLiteral = _rdf.slash('XMLLiteral');
  static final URIRef langString = _rdf.slash('langString');

  RDF({ns}) : super(ns: ns);
}

final URIRef _foaf = URIRef.fullUri(foafAnchor);

/// Friend of a Friend (FOAF) RDF vocabulary, described using W3C RDF Schema and the Web Ontology Language.
class FOAF extends Namespace {
  final ns = foafAnchor;
  static final String foaf = foafAnchor;

  static final URIRef Person = _foaf.slash('Person');
  static final URIRef nick = _foaf.slash('nick');
  static final URIRef name = _foaf.slash('name');
  static final URIRef mbox = _foaf.slash('mbox');

  FOAF({required super.ns});
}

final URIRef _xsd = URIRef.fullUri(xsdAnchor);

/// W3C XML Schema Definition Language (XSD) 1.1
class XSD extends Namespace {
  final ns = xsdAnchor;
  static final String xsd = xsdAnchor;

  /// https://www.w3.org/TR/xmlschema11-2/#<fundamental facets>
  static final URIRef ordered = _xsd.slash('ordered');
  static final URIRef bounded = _xsd.slash('bounded');
  static final URIRef cardinality = _xsd.slash('cardinality');
  static final URIRef numeric = _xsd.slash('numeric');

  /// https://www.w3.org/TR/xmlschema11-2/#<constraining facets>
  static final URIRef length = _xsd.slash('length');
  static final URIRef minLength = _xsd.slash('minLength');
  static final URIRef maxLength = _xsd.slash('maxLength');
  static final URIRef pattern = _xsd.slash('pattern');
  static final URIRef enumeration = _xsd.slash('enumeration');
  static final URIRef whiteSpace = _xsd.slash('whiteSpace');
  static final URIRef maxExclusive = _xsd.slash('maxExclusive');
  static final URIRef maxInclusive = _xsd.slash('maxInclusive');
  static final URIRef minExclusive = _xsd.slash('minExlusive');
  static final URIRef minInclusive = _xsd.slash('minInclusive');
  static final URIRef totalDigits = _xsd.slash('totalDigits');
  static final URIRef fractionDigits = _xsd.slash('fractionDigits');
  static final URIRef Assertions = _xsd.slash('Assertions');
  static final URIRef explicitTimezone = _xsd.slash('explicitTimezone');

  /// https://www.w3.org/TR/xmlschema11-2/#<7 property model>
  static final URIRef year = _xsd.slash('year');
  static final URIRef month = _xsd.slash('month');
  static final URIRef day = _xsd.slash('day');
  static final URIRef hour = _xsd.slash('hour');
  static final URIRef minute = _xsd.slash('minute');
  static final URIRef second = _xsd.slash('second');
  static final URIRef timezoneOffset = _xsd.slash('timezoneOffset');

  /// rest of the properties https://www.w3.org/TR/xmlschema11-2/#<property>
  static final URIRef ENTITIES = _xsd.slash('ENTITIES');
  static final URIRef ENTITY = _xsd.slash('ENTITY');
  static final URIRef ID = _xsd.slash('ID');
  static final URIRef IDREF = _xsd.slash('IDREF');
  static final URIRef IDREFS = _xsd.slash('IDREFS');
  static final URIRef NCName = _xsd.slash('NCName');
  static final URIRef NMTOKEN = _xsd.slash('NMTOKEN');
  static final URIRef NMTOKENS = _xsd.slash('NMTOKENS');
  static final URIRef NOTATION = _xsd.slash('NOTATION');
  static final URIRef Name = _xsd.slash('Name');
  static final URIRef QName = _xsd.slash('QName');
  static final URIRef anyURI = _xsd.slash('anyURI');
  static final URIRef base64Binary = _xsd.slash('base64Binary');
  static final URIRef boolean = _xsd.slash('boolean');
  static final URIRef byte = _xsd.slash('byte');
  static final URIRef date = _xsd.slash('date');
  static final URIRef dateTime = _xsd.slash('dateTime');
  static final URIRef dateTimeStamp = _xsd.slash('dateTimeStamp');
  static final URIRef dateTimeDuration = _xsd.slash('dateTimeDuration');
  static final URIRef decimal = _xsd.slash('decimal');
  static final URIRef double = _xsd.slash('double');
  static final URIRef duration = _xsd.slash('duration');
  static final URIRef float = _xsd.slash('float');
  static final URIRef gDay = _xsd.slash('gDay');
  static final URIRef gMonth = _xsd.slash('gMonth');
  static final URIRef gMonthDay = _xsd.slash('gMonthDay');
  static final URIRef gYear = _xsd.slash('gYear');
  static final URIRef gYearMonth = _xsd.slash('gYearMonth');
  static final URIRef hexBinary = _xsd.slash('hexBinary');
  static final URIRef int = _xsd.slash('int');
  static final URIRef integer = _xsd.slash('integer');
  static final URIRef language = _xsd.slash('language');
  static final URIRef long = _xsd.slash('long');
  static final URIRef negativeInteger = _xsd.slash('negativeInteger');
  static final URIRef nonNegativeInteger = _xsd.slash('nonNegativeInteger');
  static final URIRef nonPositiveInteger = _xsd.slash('nonPositiveInteger');
  static final URIRef normalizedString = _xsd.slash('normalizedString');
  static final URIRef positiveInteger = _xsd.slash('positiveInteger');
  static final URIRef short = _xsd.slash('short');
  static final URIRef string = _xsd.slash('string');
  static final URIRef time = _xsd.slash('time');
  static final URIRef token = _xsd.slash('token');
  static final URIRef unsignedByte = _xsd.slash('unsignedByte');
  static final URIRef unsignedInt = _xsd.slash('unsignedInt');
  static final URIRef unsignedLong = _xsd.slash('unsignedLong');
  static final URIRef unsignedShort = _xsd.slash('unsignedShort');
  static final URIRef yearMonthDuration = _xsd.slash('yearMonthDuration');

  XSD({required super.ns});
}

final URIRef _rdfs = URIRef.fullUri(rdfsAnchor);

/// RDFS Schema
class RDFS extends Namespace {
  final ns = rdfsAnchor;
  static final String rdfs = rdfsAnchor;

  RDFS({required super.ns});

  /// Refer to W3 specification: http://www.w3.org/2000/01/rdf-schema#
  static final URIRef comment = _rdfs.slash('comment');
  static final URIRef isDefinedBy = _rdfs.slash('isDefinedBy');
  static final URIRef label = _rdfs.slash('label');
  static final URIRef Literal = _rdfs.slash('Literal');
  static final URIRef seeAlso = _rdfs.slash('seeAlso');
}

final URIRef _owl = URIRef.fullUri(owlAnchor);

/// OWL vocabulary
class OWL extends Namespace {
  final String ns = owlAnchor;
  static final String owl = owlAnchor;

  OWL({required super.ns});

  static final URIRef backwardCompatibleWith =
      _owl.slash('backwardCompatibleWith');
  static final URIRef bottomDataProperty = _owl.slash('bottomDataProperty');
  static final URIRef bottomObjectProperty = _owl.slash('bottomObjectProperty');
  static final URIRef deprecated = _owl.slash('deprecated');
  static final URIRef incompatibleWith = _owl.slash('incompatibleWith');
  static final URIRef Nothing = _owl.slash('Nothing');
  static final URIRef priorVersion = _owl.slash('priorVersion');
  static final URIRef rational = _owl.slash('rational');
  static final URIRef real = _owl.slash('real');
  static final URIRef versionInfo = _owl.slash('versionInfo');
  static final URIRef Thing = _owl.slash('Thing');
  static final URIRef topDataProperty = _owl.slash('topDataProperty');
  static final URIRef topObjectProperty = _owl.slash('topObjectProperty');
  static final URIRef objectProperty = _owl.slash('ObjectProperty');
  static final URIRef NamedIndividual = _owl.slash('NamedIndividual');
}

/// Includes standard prefixes for namespace checking and shortening to export
/// to other formats.
final Map<String, String> standardPrefixes = {
  'foaf': foafAnchor,
  'xsd': xsdAnchor,
  'owl': owlAnchor,
  'rdf': rdfAnchor,
  'rdfs': rdfsAnchor,
};

/// This constant [a] is a shorthand predicate for rdf:type.
final a = RDF.type;
