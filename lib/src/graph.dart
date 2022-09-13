import 'dart:io' show File;

import 'package:rdfgraph/src/namespace.dart';
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
    // create a new set if key is not existed
    if (!graphs.containsKey(triple.sub)) {
      graphs[triple.sub] = Set();
    }
    graphs[triple.sub]!.add(triple);
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
            String firstHalf = '${_abbrUrirefToTtl(t.sub, contexts)} ${_abbrUrirefToTtl(t.pre, contexts)}';
            if (t.obj.runtimeType == String) {
              line = '$firstHalf "${t.obj}" ;';
            } else if (t.obj.runtimeType == URIRef) {
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
            } else if (t.obj.runtimeType == URIRef) {
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
