import 'dart:convert';
import 'dart:io' show File;

import './namespace.dart';
import './term.dart';
import './triple.dart';

class Graph {
  Map<URIRef, Set<Triple>> graphs = {};
  Map<String, String> contexts = {};
  Set triples = {};

  /// add triple to the set, also update the graph to include the triple.
  ///
  /// using a triples set can avoid duplicated records
  void add(Triple triple) {
    triples.add(triple);

    /// create a new set if key is not existed (a new triple group identity)
    if (!graphs.containsKey(triple.sub)) {
      graphs[triple.sub] = Set();
    }
    graphs[triple.sub]!.add(triple);

    /// update the prefixes/contexts by iterating through sub, pre, obj
    _updateContexts(triple.sub, contexts);
    _updateContexts(triple.pre, contexts);
    if (triple.obj.runtimeType == Literal) {
      Literal objLiteral = triple.obj as Literal;
      if (objLiteral.datatype != null) {
        _updateContexts(objLiteral.datatype!, contexts);
      }
    } else if (triple.obj.runtimeType == URIRef) {
      // need to update contexts for URIRef objects as well
      URIRef o = triple.obj as URIRef;
      _updateContexts(o, contexts);
    }
    // print('Contexts now: $contexts');
  }

  /// add named individual to the graph: <subject> rdf:type owl:NamedIndividual
  ///
  bool addNamedIndividual(URIRef sub) {
    /// check if the new individual already exists in the graph
    /// if it's already there, can't add it and return false
    if (_namedIndividualExists(sub)) {
      return false;
    }
    Triple newNamedIndividual = Triple(
        sub: sub,
        pre: RDF.type,
        // both ways work, but OWL.NamedIndividual is more succinct
        // obj: Literal('', datatype: OWL.NamedIndividual));
        obj: OWL.NamedIndividual);
    // call add method to update contexts instead of just adding them to triples
    add(newNamedIndividual);
    return true;
  }

  /// check if a named individual already exists in the graph
  bool _namedIndividualExists(URIRef sub) {
    for (Triple t in triples) {
      if (t.sub == sub) {
        return true;
      }
    }
    return false;
  }

  /// add object property to link two triple subjects together
  ///
  /// throws an [Exception] if object or property is not existed
  void addObjectProperty(URIRef obj, URIRef relation, URIRef prop) {
    // create the triple to represent the new relationship
    Triple newRelation = Triple(sub: obj, pre: relation, obj: prop);
    if (triples.contains(newRelation)) {
      throw Exception('Triples are already linked!');
    } else if (!graphs.containsKey(obj) || !graphs.containsKey(prop)) {
      throw Exception('No triples with $obj or $prop exist');
    } else {
      add(newRelation);
    }
  }

  /// update standard prefixes to include in the contexts
  ///
  /// useful for serialization
  void _updateContexts(URIRef u, Map ctx) {
    for (String sp in standardPrefixes.keys) {
      if (u.inNamespace(Namespace(ns: standardPrefixes[sp]!)) &&
          !ctx.containsKey(sp)) {
        ctx[sp] = standardPrefixes[sp];
      }
    }
  }

  /// bind a namespace to a prefix for readability
  ///
  /// throws an [Exception] if trying to bind the same name twice
  /// [ns] uses its own property to initialize: eg, FOAF(ns: FOAF.foaf)
  void bind(String name, Namespace ns) {
    if (!contexts.containsKey(name)) {
      contexts[name] = ns.ns;
    } else {
      throw Exception("$name already exists!");
    }
  }

  /// find the subjects which have a certain predicate and object
  ///
  /// returns a set
  Set<URIRef> subjects(URIRef pre, dynamic obj) {
    Set<URIRef> subs = {};
    for (Triple t in triples) {
      if (t.pre == pre && t.obj == obj) {
        subs.add(t.sub);
      }
    }
    return subs;
  }

  /// find the objects which have a certain subject and predicate
  ///
  /// returns a set
  Set objects(URIRef sub, URIRef pre) {
    Set objs = {};
    for (Triple t in triples) {
      if (t.sub == sub && t.pre == pre) {
        objs.add(t.obj);
      }
    }
    return objs;
  }

  parse(String filePath) async {
    final file = File(filePath);
    Stream<String> lines =
        file.openRead().transform(utf8.decoder).transform(LineSplitter());
    try {
      Map<String, dynamic> config = {
        'prefix': false,
        'sub': URIRef('http://sub.placeholder.pl'),
        'pre': URIRef('http://pre.placeholder.pl')
      };
      await for (var line in lines) {
        /// remove leading and trailing spaces
        line = line.trim();
        config = _parseLine(line, config);
      }
    } catch (e) {
      print('Error in parsing: $e');
    }
  }

  Map<String, dynamic> _parseLine(String line, Map<String, dynamic> config) {
    URIRef sub = config['sub']! as URIRef;
    URIRef pre = config['pre']! as URIRef;

    /// 1. parse prefix line to store in map contexts
    if (line.startsWith('@') && line.endsWith('.')) {
      /// update contexts
      _parsePrefix(line);
      return {'prefix': true, 'sub': sub, 'pre': pre};
    } else {
      /// use regex for parsing space in side quotes: \s(?=(?:[^'"`]*(['"`])[^'"`]*\1)*[^'"`]*$)
      /// instead of just using List<String> lst = line.split(' '); which will
      /// not work for line like 'foaf:name "Edward Scissorhands"^^xsd:string ;'
      final re = RegExp(r'\s(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)');
      List<String> lst = line.split(re);
      dynamic obj;
      if (line.endsWith(';')) {
        /// 2. parse triple line ending with ';'
        /// triple line with next line containing two elements of predicate and object
        /// depending on how many elements in the line (the last one is ';')
        if (lst.length == 3 + 1) {
          /// full triple line with 3 elements
          /// sub will be re-used for following lines with 2 or 1 element(s)
          sub = _parseElement(lst[0]) as URIRef;

          /// pre will be re-used for following line with 1 element
          pre = _parseElement(lst[1]) as URIRef;
          obj = _parseElement(lst[2]);

          /// add to triples set
          add(Triple(sub: sub, pre: pre, obj: obj));
        } else if (lst.length == 2 + 1) {
          /// sub is omitted with 2 elements in this line
          pre = _parseElement(lst[0]) as URIRef;
          obj = _parseElement(lst[1]);

          /// re-use last sub
          add(Triple(sub: sub, pre: pre, obj: obj));
        } else if (lst.length == 1 + 1) {
          /// sub pre obj1 ,
          ///         obj ;
          obj = _parseElement(lst[0]);
          add(Triple(sub: sub, pre: pre, obj: obj));
        } else {
          throw Exception('Error: illegal line ending with ";" $line');
        }
      } else if (line.endsWith(',')) {
        /// 3. parse triple line ending with ','
        /// triple line with next line containing one element of object
        if (lst.length == 1 + 1) {
          /// reuse the previous sub and pre
          obj = _parseElement(lst[0]);
          add(Triple(sub: sub, pre: pre, obj: obj));
        } else if (lst.length == 2 + 1) {
          /// sub pre1 obj1 ,
          ///         obj ;
          ///     pre2 obj2 ,
          ///          obj3 ,
          pre = _parseElement(lst[0]) as URIRef;
          obj = _parseElement(lst[1]);
          add(Triple(sub: sub, pre: pre, obj: obj));
        } else if (lst.length == 3 + 1) {
          /// sub pre obj1 ,
          ///         obj2 ;
          /// sub will be re-used for following lines with 2 or 1 element(s)
          sub = _parseElement(lst[0]) as URIRef;

          /// pre will be re-used for following line with 1 element
          pre = _parseElement(lst[1]) as URIRef;
          obj = _parseElement(lst[2]);
          add(Triple(sub: sub, pre: pre, obj: obj));
        } else {
          throw Exception('Error: illegal line ending with "," $line');
        }
      } else if (line.endsWith('.')) {
        /// 4. parse triple line ending with '.'
        if (lst.length == 3 + 1) {
          sub = _parseElement(lst[0]) as URIRef;
          pre = _parseElement(lst[1]) as URIRef;
          obj = _parseElement(lst[2]);
          add(Triple(sub: sub, pre: pre, obj: obj));
        } else if (lst.length == 2 + 1) {
          pre = _parseElement(lst[0]) as URIRef;
          obj = _parseElement(lst[1]);
          add(Triple(sub: sub, pre: pre, obj: obj));
        } else if (lst.length == 1 + 1) {
          obj = _parseElement(lst[0]);
          add(Triple(sub: sub, pre: pre, obj: obj));
        } else {
          throw Exception('Error: illegal line ending with "." $line');
        }
      } else {
        /// if it's an empty line or starts with '#', just ignore it
        /// throw Exception('Error: cannot parse line $line');
      }
      return {'prefix': false, 'sub': sub, 'pre': pre};
    }
  }

  /// first need to store prefixes to contexts map
  void _parsePrefix(String prefixLine) {
    if (!prefixLine.startsWith('@') || !prefixLine.endsWith('.')) {
      throw Exception('Error: Illegal prefix $prefixLine');
    } else if (prefixLine.toLowerCase().startsWith('@prefix') &&
        prefixLine.endsWith('.')) {
      /// example: ['@prefix', 'owl:', '<http://abc.com>', '.']
      List<String> lst = prefixLine.split(' ');

      /// not considering the trailing single ':' (be aware of a single ':')
      String k = lst[1].substring(0, lst[1].length - 1);
      String v = lst[2].substring(1, lst[2].length - 1);

      /// update contexts, adding to triple will be handled by line
      contexts[k] = v;
    } else {
      throw Exception('Error: unable to parse this line $prefixLine');
    }
  }

  /// 1. parse form such as <http://www.w3.org/2002/07/owl#>
  /// 2. parse form such as xsd:string to full URIRef
  URIRef _toFullUriref(String s) {
    /// case 1: <uri>
    if (s.startsWith('<') && s.endsWith('>')) {
      return URIRef(s.substring(1, s.length - 1));
    } else if (s.contains(':')) {
      /// case 2: ':'
      if (':'.allMatches(s).length != 1) {
        throw Exception('Error: $s does not have ":" or too many ":"');
      } else {
        List<String> lst = s.split(':');
        String vocab = lst[0];
        String type = lst[1];
        if (!contexts.containsKey(vocab)) {
          throw Exception('Error: $vocab not existed in contexts!');
        } else {
          return URIRef(contexts[vocab]! + type);
        }
      }
    } else {
      throw Exception('Error: unable to convert $s to URIRef');
    }
  }

  /// parse single element in a triple or prefix line
  ///
  /// need to be more robust
  dynamic _parseElement(String element) {
    element = element.trim();

    /// 1. <element> --> URIRef(element)
    if (element.startsWith('<') && element.endsWith('>')) {
      return _toFullUriref(element);
    } else if ('"'.allMatches(element).length == 2) {
      List<String> lst = element.split('^^');
      String val = lst[0].substring(1, lst[0].length - 1);

      /// 2. "val"^^xsd:string
      /// need to consider case like "e.scissorhands@example.org"^^xsd:anyURI
      if (!element.contains('@') ||
          (element.contains('@') && element.split('@')[1].contains('.'))) {
        if (element.contains('^^')) {
          URIRef dType = _toFullUriref(lst[1]);
          return Literal(val, datatype: dType);
        } else {
          /// 3. "val"
          return Literal(val);
        }
      } else {
        /// 4. "val"@en (exclude the above case @example.org)
        List<String> lst = element.split('@');
        String val = lst[0].substring(1, lst[0].length - 1);
        String lang = lst[1];
        return Literal(val, lang: lang);
      }
    } else if (element.contains(':')) {
      /// 5. abc:def (such as rdf:type)
      return _toFullUriref(element);
    }
  }

  /// serialize the graph to certain format and export to file
  ///
  /// now support exporting to turtle file (will be the default format)
  /// needs to check the [dest] before writing to file (not implemented)
  /// also needs to optimize the namespace binding instead of full URIRef
  void serialize({String format = 'ttl', String? dest}) {
    String indent = ' ' * 4;
    if (dest != null) {
      var file = File(dest);

      var output = StringBuffer();
      String line = '';
      // read and write prefixes
      for (var c in contexts.keys) {
        line = '@prefix $c: <${contexts[c]}> .\n';
        output.write(line);
      }

      // read and write every graph
      for (var k in graphs.keys) {
        output.write('\n');
        bool isNewGraph = true;
        Set<Triple>? g = graphs[k];
        for (Triple t in g!) {
          if (isNewGraph) {
            isNewGraph = !isNewGraph;
            String firstHalf =
                '${_abbrUrirefToTtl(t.sub, contexts)} ${_abbrUrirefToTtl(t.pre, contexts)}';
            if (t.obj.runtimeType == String) {
              line = '$firstHalf "${t.obj}" ;';
            } else if (t.obj.runtimeType == Literal) {
              /// Literal
              Literal o = t.obj as Literal;
              line = '$firstHalf ${o.toTtl()} ;';
            } else if (t.obj.runtimeType == URIRef) {
              /// URIRef
              URIRef o = t.obj as URIRef;
              line = '$firstHalf ${_abbrUrirefToTtl(o, contexts)} ;';
            } else {
              line = '$firstHalf ${t.obj} ;';
            }
          } else {
            line += '\n';
            String firstHalf = '$indent${_abbrUrirefToTtl(t.pre, contexts)}';
            if (t.obj.runtimeType == String) {
              line += '$firstHalf "${t.obj}" ;';
            } else if (t.obj.runtimeType == Literal) {
              /// Literal
              Literal o = t.obj as Literal;
              line += '$firstHalf ${o.toTtl()} ;';
            } else if (t.obj.runtimeType == URIRef) {
              /// URIRef
              URIRef o = t.obj as URIRef;
              line += '$firstHalf ${_abbrUrirefToTtl(o, contexts)} ;';
            } else {
              line += '$firstHalf ${t.obj} ;';
            }
          }
        }
        if (line.endsWith(';')) {
          line = line.substring(0, line.length - 1) + '.\n';
        }
        output.write(line);
      }
      var sink = file.openWrite();
      sink.write(output);
      sink.close();
    }
  }

  /// abbreviate uriref in namespace to bound short name for better readability
  ///
  /// this is useful when serializing and exporting to files to turtle
  String _abbrUrirefToTtl(URIRef uriRef, Map<String, String> ctx) {
    for (String abbr in ctx.keys) {
      String ns = ctx[abbr]!;
      if (uriRef.inNamespace(Namespace(ns: ns))) {
        return '$abbr:${uriRef.value.substring(ns.length)}';
      }
    }
    return '<${uriRef.value}>';
  }
}
