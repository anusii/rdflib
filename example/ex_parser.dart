import 'package:rdflib/rdflib.dart';

main() {
  String turtleSimple = '''
  @prefix ab: <http://www.ex.org/> .
  @prefix : <http://colon.org/> .
  @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
  @prefix foaf:  <http://xmlns.com/foaf/0.1/> .
  
  <> a foaf:PersonalProfileDocument .
  
  ab:cd a ab:company, <logo> ;
    <http://www.pre.com/> <http://www.xyz.com> ;
    <http://www.number.com> 53, 56.7 ;
    <http://www.example.org> "xxx"^^xsd:numeric .
   
  ab:ef ab:type ab:thing, ab:dog ;
    ab:where ab:act .
  ''';

  String turtleRealExample = '''
  @prefix ns1: <http://sii.cecs.anu.edu.au/onto/SOLID-Health#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
<http://silo.net.au/data/SOLID-Health#Patient-p43623> a ns1:Patient,
        owl:NamedIndividual ;
    ns1:birthDay "1990-08-10T00:00:00"^^xsd:dateTime ;
    ns1:hasForm <http://silo.net.au/data/SOLID-Health#Form-p43623-20220727T120913> ;
    ns1:hasGender ns1:Gender-Male ;
    ns1:id "p43623"^^xsd:string ;
    ns1:livesIn ns1:State-QLD ;
    ns1:name "Charlie Breugel"^^xsd:string .
<http://silo.net.au/data/SOLID-Health#AssessmentTab-p43623-20220727T120913> a ns1:AssessmentTab,
        owl:NamedIndividual ;
    ns1:asthmaControl "Poor control"^^xsd:string ;
    ns1:cardiovascularRisk "High Risk: 20-24%"^^xsd:string ;
    ns1:diastolicBloodPressure 22 ;
    ns1:hearingAssessment "Abnormal"^^xsd:string ;
    ns1:height 22 ;
    ns1:leftPTAndDP "Absent"^^xsd:string ;
    ns1:monofilamentLeft "Present"^^xsd:string ;
    ns1:monofilamentRight "Absent"^^xsd:string ;
    ns1:otoscopyLeftEar "Wet perforation"^^xsd:string ;
    ns1:otoscopyRightEar "Wax in canal"^^xsd:string ;
    ns1:requiresKICA "No"^^xsd:string ;
    ns1:rightPTAndDP "Present"^^xsd:string ;
    ns1:symptomCOPD "Not applicable"^^xsd:string ;
    ns1:systolicBloodPressure 8 ;
    ns1:visualAcuityLeftEye "6/24"^^xsd:string ;
    ns1:visualAcuityRightEye "6/30"^^xsd:string ;
    ns1:visualFieldsAssessment "Normal"^^xsd:string ;
    ns1:waistCircumference 22 ;
    ns1:weight 22 .
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-1> a ns1:BloodGlucoseObservation,
        owl:NamedIndividual ;
    ns1:observedTime "2022-07-27T10:53:10Z"^^xsd:dateTimeStamp ;
    ns1:updateTime "2022-07-14T21:02:55Z"^^xsd:dateTimeStamp ;
    ns1:value "7.5"^^xsd:float .
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-2> a ns1:BloodGlucoseObservation,
        owl:NamedIndividual ;
    ns1:observedTime "2022-07-27T10:53:10Z"^^xsd:dateTimeStamp ;
    ns1:updateTime "2022-07-14T21:02:55Z"^^xsd:dateTimeStamp ;
    ns1:value "7.6"^^xsd:float .
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-3> a ns1:BloodGlucoseObservation,
        owl:NamedIndividual ;
    ns1:observedTime "2022-07-27T10:53:10Z"^^xsd:dateTimeStamp ;
    ns1:updateTime "2022-07-14T21:02:55Z"^^xsd:dateTimeStamp ;
    ns1:value "7.8"^^xsd:float .
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-4> a ns1:BloodGlucoseObservation,
        owl:NamedIndividual ;
    ns1:observedTime "2022-07-27T10:53:10Z"^^xsd:dateTimeStamp ;
    ns1:updateTime "2022-07-14T21:02:55Z"^^xsd:dateTimeStamp ;
    ns1:value "7.2"^^xsd:float .
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-5> a ns1:BloodGlucoseObservation,
        owl:NamedIndividual ;
    ns1:observedTime "2022-07-27T10:53:10Z"^^xsd:dateTimeStamp ;
    ns1:updateTime "2022-07-14T21:02:55Z"^^xsd:dateTimeStamp ;
    ns1:value "7.3"^^xsd:float .
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-6> a ns1:BloodGlucoseObservation,
        owl:NamedIndividual ;
    ns1:observedTime "2022-07-27T10:53:10Z"^^xsd:dateTimeStamp ;
    ns1:updateTime "2022-07-14T21:02:55Z"^^xsd:dateTimeStamp ;
    ns1:value "7.0"^^xsd:float .
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-7> a ns1:BloodGlucoseObservation,
        owl:NamedIndividual ;
    ns1:observedTime "2022-07-27T10:53:10Z"^^xsd:dateTimeStamp ;
    ns1:updateTime "2022-07-24T12:23:55Z"^^xsd:dateTimeStamp ;
    ns1:value "6.7"^^xsd:float .
<http://silo.net.au/data/SOLID-Health#Form-p43623-20220727T120913> a ns1:Form,
        owl:NamedIndividual ;
    ns1:comment "h"^^xsd:string ;
    ns1:date "2022-07-27T00:00:00"^^xsd:dateTime ;
    ns1:hasAssessmentTab <http://silo.net.au/data/SOLID-Health#AssessmentTab-p43623-20220727T120913> ;
    ns1:hasInvestigationsTab <http://silo.net.au/data/SOLID-Health#InvestigationsTab-p43623-20220727T120913> ;
    ns1:hasPreCheckMapTab <http://silo.net.au/data/SOLID-Health#PreCheckMapTab-p43623-20220727T120913> ;
    ns1:hasSeeAndDoTab <http://silo.net.au/data/SOLID-Health#SeeAndDoTab-p43623-20220727T120913> ;
    ns1:lastSeenTime "2022-07-27T12:09:13Z"^^xsd:dateTimeStamp ;
    ns1:lastUpdatedTime "2022-07-27T10:54:27Z"^^xsd:dateTimeStamp ;
    ns1:patientDetails "h"^^xsd:string ;
    ns1:recordTime "2022-07-27T12:09:13Z"^^xsd:dateTimeStamp ;
    ns1:submitRecordTime "2022-07-27T10:54:27Z"^^xsd:dateTimeStamp .
<http://silo.net.au/data/SOLID-Health#InvestigationsTab-p43623-20220727T120913> a ns1:InvestigationsTab,
        owl:NamedIndividual ;
    ns1:ACR 11 ;
    ns1:FEV1prePercent "4.0"^^xsd:float ;
    ns1:HbA1c 22 ;
    ns1:TSH 3 ;
    ns1:abdominalUltrasound "fd"^^xsd:string ;
    ns1:chronicDiseasePathology "1"^^xsd:string ;
    ns1:chronicLiver "2d"^^xsd:string ;
    ns1:descriptionECG "c"^^xsd:string ;
    ns1:eGFR 123 ;
    ns1:fibroScanResult "Indetermined"^^xsd:string ;
    ns1:haemoglobinHb 33 ;
    ns1:internationalNormalisedINR "cdsdc"^^xsd:string ;
    ns1:levelHDL 33 ;
    ns1:levelLDL 123 ;
    ns1:requiresECG "Yes"^^xsd:string ;
    ns1:requiresSpirometry "Yes"^^xsd:string ;
    ns1:totalCholesterolLevel 123 ;
    ns1:triglycerideLevel 12 .
<http://silo.net.au/data/SOLID-Health#PreCheckMapTab-p43623-20220727T120913> a ns1:PreCheckMapTab,
        owl:NamedIndividual ;
    ns1:alcoholConsumptionLevel "Non-drinker"^^xsd:string ;
    ns1:currentHealthProblems "h"^^xsd:string ;
    ns1:dietAssessment "Referred to dietician"^^xsd:string ;
    ns1:exerciseLevel "Good = 30min mod. most days"^^xsd:string ;
    ns1:hasBGO <http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-1>,
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-2>,
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-3>,
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-4>,
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-5>,
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-6>,
<http://silo.net.au/data/SOLID-Health#BGO-p43623-20220727T120913-7> ;
    ns1:influenzaVaccinationStatus "Not current"^^xsd:string ;
    ns1:medicationUsageRecord "No"^^xsd:string ;
    ns1:pneumococcalVaccinationStatus "Current (includes given today)"^^xsd:string ;
    ns1:smokingStatus "Current smoker - no intention to quit"^^xsd:string .
<http://silo.net.au/data/SOLID-Health#SeeAndDoOption-p43623-20220727T120913-fitnessDrive> a ns1:SeeAndDoOption,
        owl:NamedIndividual ;
    ns1:option "fitnessDrive"^^xsd:string ;
    ns1:selected "Yes"^^xsd:string ;
    ns1:time "Tomorrow"^^xsd:string .
<http://silo.net.au/data/SOLID-Health#SeeAndDoTab-p43623-20220727T120913> a ns1:SeeAndDoTab,
        owl:NamedIndividual ;
    ns1:actionGPMPA "ds"^^xsd:string ;
    ns1:hasSeeAndDoOption <http://silo.net.au/data/SOLID-Health#SeeAndDoOption-p43623-20220727T120913-fitnessDrive> .
  ''';

  String turtleAclExample = '''
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

  String turtleSimple2 = """
  bob:me a uni:student .
  """;

  // test an example string with valid ttl content
  Graph g = Graph();

  // g.parseTurtle(turtleAclExample);

  // g.parseTurtle(turtleRealExample);

  g.parseTurtle(turtleSimple);
  g.addTripleToGroups('ab:xy.zzz', 'rdf:type', '3');
  g.addTripleToGroups(URIRef(''), a, XSD.anyURI);

  // should not add duplicate triples
  g.addTripleToGroups('<xyz>', 'ab:when', 'yesterday');
  g.addTripleToGroups('<xyz>', 'ab:when', 'yesterday');
  g.addTripleToGroups('<xyz>', 'ab:when', 'yesterday');
  g.addTripleToGroups('<xyz>', 'ab:when', 'today');

  String delim = '-' * 30 + '\n';
  print('${delim}Prefixes:\n${g.ctx}\n');
  print('${delim}Turtles:\n${g.groups}\n');
  g.serialize(format: 'ttl', abbr: 'short');
  String serialized = g.serializedString;
  print('${delim}Serialized Result:\n$serialized\n');

  // test to see if the serialized string is still valid as a ttl input
  Graph g2 = Graph();
  g2.parseTurtle(serialized);
  print('${delim}Serialized Prefixes:\n${g2.ctx}\n');
  print('${delim}Serialized Triples:\n${g2.groups}\n');
  g2.serialize(format: 'ttl', abbr: 'short');
  print('${delim}Serialized Again:\n${g2.serializedString}');
}
