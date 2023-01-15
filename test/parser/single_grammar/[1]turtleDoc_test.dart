import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import '../../../lib/parser/naive_parser.dart';

main() {
  group("""[1] 	turtleDoc 	::= 	statement*""", () {
    // ttl file
    String sampleTurtle0 = '''
    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
  @prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<https://solid.silo.net.au/charlie_bruegel> rdf:type owl:NamedIndividual ;
    <http://xmlns.com/foaf/0.1/name> "Charlie Bruegel"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bmiM> "0,3,2,6"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bmiF> "1,10,2,6"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bloodPreasureM> "11,81,64,39"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bloodPreasureF> "39,11,81,64"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#cholesterolLevelM> "8,1,2"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#cholesterolLevelF> "11,5,3"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#smoking0> "26"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#smoking1> "4"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#bloodGlucoseReal> "5.1,6.0,8.1,7.2,8.6,7.8,7.3,7.1,4.5,6.7,6.3,6.6,6.9"^^xsd:string ;
    <http://silo.net.au/predicates/analytic#BMIList> "18,35,20,32,23"^^xsd:string .
    ''';
    // acl file
    String sampleTurtle1 = '''
    @prefix : <#>.
  @prefix acl: <http://www.w3.org/ns/auth/acl#>.
@prefix foaf: <http://xmlns.com/foaf/0.1/>.
@prefix c: <https://solid.udula.net.au/charlie_bruegel/profile/card#>.
@prefix c0: <https://solid.udula.net.au/leslie_smith/profile/card#>.
@prefix c1: <https://solid.ecosysl.net/phitest00/profile/card#>.

:ControlReadWrite
    a acl:Authorization;
    acl:accessTo <employment>;
    acl:agent c:me;
    acl:mode acl:Control, acl:Read, acl:Write.
:ReadWrite
    a acl:Authorization;
    acl:accessTo <employment>;
    acl:agent c0:me, c1:me;
    acl:mode acl:Read, acl:Write.
    ''';
    // Two lines are deleted because they are not a valid triple, the rest is the same:
    // card:i is doap:developer of <http://www.w3.org/2000/10/swap/data#Cwm>,
    //     <http://dig.csail.mit.edu/2005/ajar/ajaw/data#Tabulator>.
    // From Tim Berners-Lee's card: http://www.w3.org/People/Berners-Lee/card
    String sampleTurtle2 = '''
    @prefix foaf:  <http://xmlns.com/foaf/0.1/> .
@prefix doap:  <http://usefulinc.com/ns/doap#>.
@prefix :      <http://www.w3.org/2000/10/swap/pim/contact#>.
@prefix s:     <http://www.w3.org/2000/01/rdf-schema#>.
@prefix cert:  <http://www.w3.org/ns/auth/cert#>.
@prefix cc:    <http://creativecommons.org/ns#>.
@prefix dc:    <http://purl.org/dc/elements/1.1/>.
@prefix dct:   <http://purl.org/dc/terms/>.
@prefix ldp:   <http://www.w3.org/ns/ldp#>.
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#>.
@prefix geo:   <http://www.w3.org/2003/01/geo/wgs84_pos#>.
@prefix w3c:   <http://www.w3.org/data#>.
@prefix card:  <https://www.w3.org/People/Berners-Lee/card#>.
@prefix rsa:   <http://www.w3.org/ns/auth/rsa#> .
@prefix schema: <http://schema.org/>.
@prefix sioc: <http://rdfs.org/sioc/ns#>.
@prefix solid: <http://www.w3.org/ns/solid/terms#>.
@prefix space: <http://www.w3.org/ns/pim/space#> .
@prefix vcard: <http://www.w3.org/2006/vcard/ns#>.
@prefix xsd: <http://www.w3.org/2001/XMLSchema#>.

    <>   a foaf:PersonalProfileDocument;
         cc:license <http://creativecommons.org/licenses/by-nc/3.0/>;
	 dc:title "Tim Berners-Lee's FOAF file";
         foaf:maker card:i;
         foaf:primaryTopic card:i.

card:i    rdfs:seeAlso <https://timbl.com/timbl/Public/friends.ttl>.
card:i   solid:editableProfile <https://timbl.com/timbl/Public/friends.ttl>.
<https://timbl.com/timbl/Public/friends.ttl>
        a foaf:PersonalProfileDocument;
        cc:license <http://creativecommons.org/licenses/by-nc/3.0/>;
        dc:title "Tim Berners-Lee's editable profile";
        foaf:maker card:i;
        foaf:primaryTopic card:i.

card:i solid:oidcIssuer <https://timbl.com> .
card:i  solid:publicTypeIndex  <https://timbl.com/timbl/Public/PublicTypeIndex.ttl>.
card:i space:preferencesFile <https://timbl.com/timbl/Data/preferences.n3>.
card:i ldp:inbox <https://timbl.com/timbl/Public/Inbox> .
card:i schema:owns <https://timblbot.inrupt.net/profile/card#me> .
card:i  space:storage  <https://timbl.solid.community/>,
  <https://timbl.inrupt.net/>,
  <https://timbl.com/timbl/Public/> .

w3c:W3C foaf:member card:i.
<http://dig.csail.mit.edu/data#DIG> foaf:member card:i.

card:i
    s:label  	"Tim Berners-Lee";
    vcard:fn  "Tim Berners-Lee";
    vcard:hasAddress
        [ a    vcard:Work;
        vcard:locality "Cambridge";
        vcard:postal-code "02139";
        vcard:region "MA";
        vcard:street-address "32 Vassar Street" ];
    a :Male;
    :office [
    	geo:location [geo:lat "42.361860"; geo:long "-71.091840"];
    	:address [
    		:street "32 Vassar Street";
    		:street2 "MIT CSAIL Building 32";
    		:city "Cambridge";
    		:postalCode "02139";
    		:country "USA"
	]
    ];
    :publicHomePage <../Berners-Lee/>;
    :homePage <../Berners-Lee/>;
    :assistant card:amy;
    a foaf:Person;
    foaf:based_near [geo:lat "42.361860"; geo:long "-71.091840"];
    :preferredURI "https://www.w3.org/People/Berners-Lee/card#i";
    foaf:mbox <mailto:timbl@w3.org>;
    foaf:mbox_sha1sum "965c47c5a70db7407210cef6e4e6f5374a525c5c";
    foaf:openid <https://www.w3.org/People/Berners-Lee/>;
    sioc:avatar <images/timbl-image-by-Coz-cropped.jpg>;
    foaf:img <https://www.w3.org/Press/Stock/Berners-Lee/2001-europaeum-eighth.jpg>;
    foaf:family_name "Berners-Lee";
    foaf:givenname "Timothy";
    foaf:title "Sir".
    
card:i
    foaf:homepage <https://www.w3.org/People/Berners-Lee/>;
     foaf:mbox <mailto:timbl@w3.org>;
     foaf:name "Timothy Berners-Lee";
     foaf:nick "TimBL", "timbl";
    foaf:account <http://twitter.com/timberners_lee>,
        <http://www.reddit.com/user/timbl/>,
        <http://en.wikipedia.org/wiki/User:Timbl>;
     foaf:workplaceHomepage <https://www.w3.org/>.

card:i solid:profileHighlightColor "#00467E";
 solid:profileBackgroundColor "#ffffff".

<#i> cert:key  [ a cert:RSAPublicKey;
    cert:modulus
"ebe99c737bd3670239600547e5e2eb1d1497da39947b6576c3c44ffeca32cf0f2f7cbee3c47001278a90fc7fc5bcf292f741eb1fcd6bbe7f90650afb519cf13e81b2bffc6e02063ee5a55781d420b1dfaf61c15758480e66d47fb0dcb5fa7b9f7f1052e5ccbd01beee9553c3b6b51f4daf1fce991294cd09a3d1d636bc6c7656e4455d0aff06daec740ed0084aa6866fcae1359de61cc12dbe37c8fa42e977c6e727a8258bb9a3f265b27e3766fe0697f6aa0bcc81c3f026e387bd7bbc81580dc1853af2daa099186a9f59da526474ef6ec0a3d84cf400be3261b6b649dea1f78184862d34d685d2d587f09acc14cd8e578fdd2283387821296f0af39b8d8845"^^xsd:hexBinary ;
        cert:exponent "65537"^^xsd:integer ] .
        
<http://dig.csail.mit.edu/2007/01/camp/data#course> foaf:maker card:i.
<http://www.w3.org/2011/Talks/0331-hyderabad-tbl/data#talk>
    dct:title "Designing the Web for an Open Society";
    foaf:maker card:i.
<http://www.ecs.soton.ac.uk/~dt2/dlstuff/www2006_data#panel-panelk01>
	s:label  "The Next Wave of the Web (Plenary Panel)";
	:participant card:i.
<http://wiki.ontoworld.org/index.php/_IRW2006>
	:participant card:i.
<http://wiki.ontoworld.org/index.php/_IRW2006>
    dc:title "Identity, Reference and the Web workshop 2006".
    
card:i foaf:weblog
<http://dig.csail.mit.edu/breadcrumbs/blog/4> .
<http://dig.csail.mit.edu/breadcrumbs/blog/4>
    rdfs:seeAlso <http://dig.csail.mit.edu/breadcrumbs/blog/feed/4>;
    dc:title "timbl's blog on DIG";
    foaf:maker card:i.

<../../DesignIssues/Overview.html>
    dc:title "Design Issues for the World Wide Web";
    foaf:maker card:i
    ''';
    // OWL ontology: http://www.w3.org/2002/07/owl#
    String sampleTurtle3 = '''
    @prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix grddl: <http://www.w3.org/2003/g/data-view#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xml: <http://www.w3.org/XML/1998/namespace> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<http://www.w3.org/2002/07/owl> a owl:Ontology ;
     dc:title "The OWL 2 Schema vocabulary (OWL 2)" ;
     rdfs:comment """
  This ontology partially describes the built-in classes and
  properties that together form the basis of the RDF/XML syntax of OWL 2.
  The content of this ontology is based on Tables 6.1 and 6.2
  in Section 6.4 of the OWL 2 RDF-Based Semantics specification,
  available at http://www.w3.org/TR/owl2-rdf-based-semantics/.
  Please note that those tables do not include the different annotations
  (labels, comments and rdfs:isDefinedBy links) used in this file.
  Also note that the descriptions provided in this ontology do not
  provide a complete and correct formal description of either the syntax
  or the semantics of the introduced terms (please see the OWL 2
  recommendations for the complete and normative specifications).
  Furthermore, the information provided by this ontology may be
  misleading if not used with care. This ontology SHOULD NOT be imported
  into OWL ontologies. Importing this file into an OWL 2 DL ontology
  will cause it to become an OWL 2 Full ontology and may have other,
  unexpected, consequences.
   """ ;
     rdfs:isDefinedBy
          <http://www.w3.org/TR/owl2-mapping-to-rdf/>,
          <http://www.w3.org/TR/owl2-rdf-based-semantics/>,
          <http://www.w3.org/TR/owl2-syntax/> ;
     rdfs:seeAlso   <http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-classes>,
                    <http://www.w3.org/TR/owl2-rdf-based-semantics/#table-axiomatic-properties> ;
     owl:imports <http://www.w3.org/2000/01/rdf-schema> ;
     owl:versionIRI <http://www.w3.org/2002/07/owl> ;
     owl:versionInfo "\$Date: 2009/11/15 10:54:12 \$" ;
     grddl:namespaceTransformation <http://dev.w3.org/cvsweb/2009/owl-grddl/owx2rdf.xsl> . 


owl:AllDifferent a rdfs:Class ;
     rdfs:label "AllDifferent" ;
     rdfs:comment "The class of collections of pairwise different individuals." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Resource . 

owl:AllDisjointClasses a rdfs:Class ;
     rdfs:label "AllDisjointClasses" ;
     rdfs:comment "The class of collections of pairwise disjoint classes." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Resource . 

owl:AllDisjointProperties a rdfs:Class ;
     rdfs:label "AllDisjointProperties" ;
     rdfs:comment "The class of collections of pairwise disjoint properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Resource . 

owl:Annotation a rdfs:Class ;
     rdfs:label "Annotation" ;
     rdfs:comment "The class of annotated annotations for which the RDF serialization consists of an annotated subject, predicate and object." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Resource . 

owl:AnnotationProperty a rdfs:Class ;
     rdfs:label "AnnotationProperty" ;
     rdfs:comment "The class of annotation properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdf:Property . 

owl:AsymmetricProperty a rdfs:Class ;
     rdfs:label "AsymmetricProperty" ;
     rdfs:comment "The class of asymmetric properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf owl:ObjectProperty . 

owl:Axiom a rdfs:Class ;
     rdfs:label "Axiom" ;
     rdfs:comment "The class of annotated axioms for which the RDF serialization consists of an annotated subject, predicate and object." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Resource . 

owl:Class a rdfs:Class ;
     rdfs:label "Class" ;
     rdfs:comment "The class of OWL classes." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Class . 

owl:DataRange a rdfs:Class ;
     rdfs:label "DataRange" ;
     rdfs:comment "The class of OWL data ranges, which are special kinds of datatypes. Note: The use of the IRI owl:DataRange has been deprecated as of OWL 2. The IRI rdfs:Datatype SHOULD be used instead." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Datatype . 

owl:DatatypeProperty a rdfs:Class ;
     rdfs:label "DatatypeProperty" ;
     rdfs:comment "The class of data properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdf:Property . 

owl:DeprecatedClass a rdfs:Class ;
     rdfs:label "DeprecatedClass" ;
     rdfs:comment "The class of deprecated classes." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Class . 

owl:DeprecatedProperty a rdfs:Class ;
     rdfs:label "DeprecatedProperty" ;
     rdfs:comment "The class of deprecated properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdf:Property . 

owl:FunctionalProperty a rdfs:Class ;
     rdfs:label "FunctionalProperty" ;
     rdfs:comment "The class of functional properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdf:Property . 

owl:InverseFunctionalProperty a rdfs:Class ;
     rdfs:label "InverseFunctionalProperty" ;
     rdfs:comment "The class of inverse-functional properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf owl:ObjectProperty . 

owl:IrreflexiveProperty a rdfs:Class ;
     rdfs:label "IrreflexiveProperty" ;
     rdfs:comment "The class of irreflexive properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf owl:ObjectProperty . 

owl:NamedIndividual a rdfs:Class ;
     rdfs:label "NamedIndividual" ;
     rdfs:comment "The class of named individuals." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf owl:Thing . 

owl:NegativePropertyAssertion a rdfs:Class ;
     rdfs:label "NegativePropertyAssertion" ;
     rdfs:comment "The class of negative property assertions." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Resource . 

owl:Nothing a owl:Class ;
     rdfs:label "Nothing" ;
     rdfs:comment "This is the empty class." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf owl:Thing . 

owl:ObjectProperty a rdfs:Class ;
     rdfs:label "ObjectProperty" ;
     rdfs:comment "The class of object properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdf:Property . 

owl:Ontology a rdfs:Class ;
     rdfs:label "Ontology" ;
     rdfs:comment "The class of ontologies." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdfs:Resource . 

owl:OntologyProperty a rdfs:Class ;
     rdfs:label "OntologyProperty" ;
     rdfs:comment "The class of ontology properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf rdf:Property . 

owl:ReflexiveProperty a rdfs:Class ;
     rdfs:label "ReflexiveProperty" ;
     rdfs:comment "The class of reflexive properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf owl:ObjectProperty . 

owl:Restriction a rdfs:Class ;
     rdfs:label "Restriction" ;
     rdfs:comment "The class of property restrictions." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf owl:Class . 

owl:SymmetricProperty a rdfs:Class ;
     rdfs:label "SymmetricProperty" ;
     rdfs:comment "The class of symmetric properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf owl:ObjectProperty . 

owl:TransitiveProperty a rdfs:Class ;
     rdfs:label "TransitiveProperty" ;
     rdfs:comment "The class of transitive properties." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:subClassOf owl:ObjectProperty . 

owl:Thing a owl:Class ;
     rdfs:label "Thing" ;
     rdfs:comment "The class of OWL individuals." ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> .
     
owl:allValuesFrom a rdf:Property ;
     rdfs:label "allValuesFrom" ;
     rdfs:comment "The property that determines the class that a universal property restriction refers to." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Class . 

owl:annotatedProperty a rdf:Property ;
     rdfs:label "annotatedProperty" ;
     rdfs:comment "The property that determines the predicate of an annotated axiom or annotated annotation." ;
     rdfs:domain rdfs:Resource ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Resource . 

owl:annotatedSource a rdf:Property ;
     rdfs:label "annotatedSource" ;
     rdfs:comment "The property that determines the subject of an annotated axiom or annotated annotation." ;
     rdfs:domain rdfs:Resource ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Resource . 

owl:annotatedTarget a rdf:Property ;
     rdfs:label "annotatedTarget" ;
     rdfs:comment "The property that determines the object of an annotated axiom or annotated annotation." ;
     rdfs:domain rdfs:Resource ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Resource . 

owl:assertionProperty a rdf:Property ;
     rdfs:label "assertionProperty" ;
     rdfs:comment "The property that determines the predicate of a negative property assertion." ;
     rdfs:domain owl:NegativePropertyAssertion ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:Property . 

owl:backwardCompatibleWith a owl:AnnotationProperty, owl:OntologyProperty ;
     rdfs:label "backwardCompatibleWith" ;
     rdfs:comment "The annotation property that indicates that a given ontology is backward compatible with another ontology." ;
     rdfs:domain owl:Ontology ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Ontology . 

owl:bottomDataProperty a owl:DatatypeProperty ;
     rdfs:label "bottomDataProperty" ;
     rdfs:comment "The data property that does not relate any individual to any data value." ;
     rdfs:domain owl:Thing ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Literal . 

owl:bottomObjectProperty a owl:ObjectProperty ;
     rdfs:label "bottomObjectProperty" ;
     rdfs:comment "The object property that does not relate any two individuals." ;
     rdfs:domain owl:Thing ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Thing . 

owl:cardinality a rdf:Property ;
     rdfs:label "cardinality" ;
     rdfs:comment "The property that determines the cardinality of an exact cardinality restriction." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range xsd:nonNegativeInteger . 

owl:complementOf a rdf:Property ;
     rdfs:label "complementOf" ;
     rdfs:comment "The property that determines that a given class is the complement of another class." ;
     rdfs:domain owl:Class ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Class . 

owl:datatypeComplementOf a rdf:Property ;
     rdfs:label "datatypeComplementOf" ;
     rdfs:comment "The property that determines that a given data range is the complement of another data range with respect to the data domain." ;
     rdfs:domain rdfs:Datatype ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Datatype . 

owl:deprecated a owl:AnnotationProperty ;
     rdfs:label "deprecated" ;
     rdfs:comment "The annotation property that indicates that a given entity has been deprecated." ;
     rdfs:domain rdfs:Resource ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Resource . 

owl:differentFrom a rdf:Property ;
     rdfs:label "differentFrom" ;
     rdfs:comment "The property that determines that two given individuals are different." ;
     rdfs:domain owl:Thing ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Thing . 

owl:disjointUnionOf a rdf:Property ;
     rdfs:label "disjointUnionOf" ;
     rdfs:comment "The property that determines that a given class is equivalent to the disjoint union of a collection of other classes." ;
     rdfs:domain owl:Class ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List . 

owl:disjointWith a rdf:Property ;
     rdfs:label "disjointWith" ;
     rdfs:comment "The property that determines that two given classes are disjoint." ;
     rdfs:domain owl:Class ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Class . 

owl:distinctMembers a rdf:Property ;
     rdfs:label "distinctMembers" ;
     rdfs:comment "The property that determines the collection of pairwise different individuals in a owl:AllDifferent axiom." ;
     rdfs:domain owl:AllDifferent ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List . 

owl:equivalentClass a rdf:Property ;
     rdfs:label "equivalentClass" ;
     rdfs:comment "The property that determines that two given classes are equivalent, and that is used to specify datatype definitions." ;
     rdfs:domain rdfs:Class ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Class . 

owl:equivalentProperty a rdf:Property ;
     rdfs:label "equivalentProperty" ;
     rdfs:comment "The property that determines that two given properties are equivalent." ;
     rdfs:domain rdf:Property ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:Property . 

owl:hasKey a rdf:Property ;
     rdfs:label "hasKey" ;
     rdfs:comment "The property that determines the collection of properties that jointly build a key." ;
     rdfs:domain owl:Class ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List . 

owl:hasSelf a rdf:Property ;
     rdfs:label "hasSelf" ;
     rdfs:comment "The property that determines the property that a self restriction refers to." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Resource . 

owl:hasValue a rdf:Property ;
     rdfs:label "hasValue" ;
     rdfs:comment "The property that determines the individual that a has-value restriction refers to." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Resource . 

owl:imports a owl:OntologyProperty ;
     rdfs:label "imports" ;
     rdfs:comment "The property that is used for importing other ontologies into a given ontology." ;
     rdfs:domain owl:Ontology ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Ontology . 

owl:incompatibleWith a owl:AnnotationProperty, owl:OntologyProperty ;
     rdfs:label "incompatibleWith" ;
     rdfs:comment "The annotation property that indicates that a given ontology is incompatible with another ontology." ;
     rdfs:domain owl:Ontology ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Ontology . 

owl:intersectionOf a rdf:Property ;
     rdfs:label "intersectionOf" ;
     rdfs:comment "The property that determines the collection of classes or data ranges that build an intersection." ;
     rdfs:domain rdfs:Class ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List . 

owl:inverseOf a rdf:Property ;
     rdfs:label "inverseOf" ;
     rdfs:comment "The property that determines that two given properties are inverse." ;
     rdfs:domain owl:ObjectProperty ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:ObjectProperty . 

owl:maxCardinality a rdf:Property ;
     rdfs:label "maxCardinality" ;
     rdfs:comment "The property that determines the cardinality of a maximum cardinality restriction." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range xsd:nonNegativeInteger . 

owl:maxQualifiedCardinality a rdf:Property ;
     rdfs:label "maxQualifiedCardinality" ;
     rdfs:comment "The property that determines the cardinality of a maximum qualified cardinality restriction." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range xsd:nonNegativeInteger . 

owl:members a rdf:Property ;
     rdfs:label "members" ;
     rdfs:comment "The property that determines the collection of members in either a owl:AllDifferent, owl:AllDisjointClasses or owl:AllDisjointProperties axiom." ;
     rdfs:domain rdfs:Resource ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List . 

owl:minCardinality a rdf:Property ;
     rdfs:label "minCardinality" ;
     rdfs:comment "The property that determines the cardinality of a minimum cardinality restriction." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range xsd:nonNegativeInteger . 

owl:minQualifiedCardinality a rdf:Property ;
     rdfs:label "minQualifiedCardinality" ;
     rdfs:comment "The property that determines the cardinality of a minimum qualified cardinality restriction." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range xsd:nonNegativeInteger . 

owl:onClass a rdf:Property ;
     rdfs:label "onClass" ;
     rdfs:comment "The property that determines the class that a qualified object cardinality restriction refers to." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Class . 

owl:onDataRange a rdf:Property ;
     rdfs:label "onDataRange" ;
     rdfs:comment "The property that determines the data range that a qualified data cardinality restriction refers to." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Datatype . 

owl:onDatatype a rdf:Property ;
     rdfs:label "onDatatype" ;
     rdfs:comment "The property that determines the datatype that a datatype restriction refers to." ;
     rdfs:domain rdfs:Datatype ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Datatype . 

owl:oneOf a rdf:Property ;
     rdfs:label "oneOf" ;
     rdfs:comment "The property that determines the collection of individuals or data values that build an enumeration." ;
     rdfs:domain rdfs:Class ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List . 

owl:onProperties a rdf:Property ;
     rdfs:label "onProperties" ;
     rdfs:comment "The property that determines the n-tuple of properties that a property restriction on an n-ary data range refers to." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List .

owl:onProperty a rdf:Property ;
     rdfs:label "onProperty" ;
     rdfs:comment "The property that determines the property that a property restriction refers to." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:Property . 

owl:priorVersion a owl:AnnotationProperty, owl:OntologyProperty ;
     rdfs:label "priorVersion" ;
     rdfs:comment "The annotation property that indicates the predecessor ontology of a given ontology." ;
     rdfs:domain owl:Ontology ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Ontology . 

owl:propertyChainAxiom a rdf:Property ;
     rdfs:label "propertyChainAxiom" ;
     rdfs:comment "The property that determines the n-tuple of properties that build a sub property chain of a given property." ;
     rdfs:domain owl:ObjectProperty ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List . 

owl:propertyDisjointWith a rdf:Property ;
     rdfs:label "propertyDisjointWith" ;
     rdfs:comment "The property that determines that two given properties are disjoint." ;
     rdfs:domain rdf:Property ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:Property . 

owl:qualifiedCardinality a rdf:Property ;
     rdfs:label "qualifiedCardinality" ;
     rdfs:comment "The property that determines the cardinality of an exact qualified cardinality restriction." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range xsd:nonNegativeInteger . 

owl:sameAs a rdf:Property ;
     rdfs:label "sameAs" ;
     rdfs:comment "The property that determines that two given individuals are equal." ;
     rdfs:domain owl:Thing ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Thing . 

owl:someValuesFrom a rdf:Property ;
     rdfs:label "someValuesFrom" ;
     rdfs:comment "The property that determines the class that an existential property restriction refers to." ;
     rdfs:domain owl:Restriction ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Class . 

owl:sourceIndividual a rdf:Property ;
     rdfs:label "sourceIndividual" ;
     rdfs:comment "The property that determines the subject of a negative property assertion." ;
     rdfs:domain owl:NegativePropertyAssertion ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Thing . 

owl:targetIndividual a rdf:Property ;
     rdfs:label "targetIndividual" ;
     rdfs:comment "The property that determines the object of a negative object property assertion." ;
     rdfs:domain owl:NegativePropertyAssertion ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Thing . 

owl:targetValue a rdf:Property ;
     rdfs:label "targetValue" ;
     rdfs:comment "The property that determines the value of a negative data property assertion." ;
     rdfs:domain owl:NegativePropertyAssertion ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Literal . 

owl:topDataProperty a owl:DatatypeProperty ;
     rdfs:label "topDataProperty" ;
     rdfs:comment "The data property that relates every individual to every data value." ;
     rdfs:domain owl:Thing ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Literal . 

owl:topObjectProperty a owl:ObjectProperty ;
     rdfs:label "topObjectProperty" ;
     rdfs:comment "The object property that relates every two individuals." ;
     rdfs:domain owl:Thing ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Thing . 

owl:unionOf a rdf:Property ;
     rdfs:label "unionOf" ;
     rdfs:comment "The property that determines the collection of classes or data ranges that build a union." ;
     rdfs:domain rdfs:Class ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List . 

owl:versionInfo a owl:AnnotationProperty ;
     rdfs:label "versionInfo" ;
     rdfs:comment "The annotation property that provides version information for an ontology or another OWL construct." ;
     rdfs:domain rdfs:Resource ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdfs:Resource .
     
owl:versionIRI a owl:OntologyProperty ;
     rdfs:label "versionIRI" ;
     rdfs:comment "The property that identifies the version IRI of an ontology." ;
     rdfs:domain owl:Ontology ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range owl:Ontology . 

owl:withRestrictions a rdf:Property ;
     rdfs:label "withRestrictions" ;
     rdfs:comment "The property that determines the collection of facet-value pairs that define a datatype restriction." ;
     rdfs:domain rdfs:Datatype ;
     rdfs:isDefinedBy <http://www.w3.org/2002/07/owl#> ;
     rdfs:range rdf:List .
     
    ''';
    Map<String, bool> testStrings = {
      '': true,
      sampleTurtle0: true,
      '$sampleTurtle0 .': false,
      sampleTurtle1: true,
      sampleTurtle2: true,
      sampleTurtle3: true,
      '.': false,
      ' ': false,
      '@prefix : </etc/> . @prefix c: <./> . @base <./> .': true,
      '@prefix abc: <https://abc.net.au/> .\n@prefix v2.7: <www.anu.cecs.au/> . \n_:0.a a <unknown> . ':
          true,
      'Prefix : <> \n PREFIX root: </> \n BasE <www.example.com> <www.example.com/alice#me> located: "ACT"^^earth:australia .':
          true,
      '@base <http://www.example.org> .': true,
      'rdf:type a rdf:example, <xyz.com> .': true,
      '<bob#me> a <person>, <staff>;;; .': true,
      'rdf:type a rdf:example, <xyz.com>, .': false,
      ':Control \n  <2023> _:burg, _:_, x:, "a", <empty>, <whoiswho>': false,
      '<bob#me> xyz:loves .': false,
    };
    testStrings.keys.forEach((element) {
      bool actual = turtleDoc.end().accept(element);
      bool expected = testStrings[element]!;
      print('turtleDoc $element - actual: $actual, expected: $expected');
      test('turtleDoc case $element', () {
        expect(actual, expected);
      });
    });
  });
}
