import 'dart:io' show File;

import 'package:rdfgraph/src/namespace.dart';
import './term.dart';
import './triple.dart';

class Graph {
  Map<URIRef, Set<Triple>> graphs = {};
  Map<String, String> contexts = {};
  Set triples = {};

  void add(Triple triple) {
    triples.add(triple);
    // create a new set if key is not existed
    if (!graphs.containsKey(triple.sub)) {
      graphs[triple.sub] = Set();
    }
    graphs[triple.sub]!.add(triple);
  }

  // bind a namespace to a prefix
  void bind(String name, Namespace ns) {
    if (!contexts.containsKey(name)) {
      contexts[name] = ns.ns;
    } else {
      throw Exception("$name already exists!");
    }
  }

  Set<URIRef> subjects(URIRef pre, dynamic obj) {
    Set<URIRef> subs = {};
    for (Triple t in triples) {
      if (t.pre == pre && t.obj == obj) {
        subs.add(t.sub);
      }
    }
    return subs;
  }

  Set objects(URIRef sub, URIRef pre) {
    Set objs = {};
    for (Triple t in triples) {
      if (t.sub == sub && t.pre == pre) {
        objs.add(t.obj);
      }
    }
    return objs;
  }

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
            String firstHalf = '<${t.sub.value}> <${t.pre.value}>';
            if (t.obj.runtimeType == String) {
              line = '$firstHalf "${t.obj}" ;';
            } else if (t.obj.runtimeType == URIRef) {
              URIRef o = t.obj as URIRef;
              line = '$firstHalf <${o.value}> ;';
            } else {
              line = '$firstHalf ${t.obj} ;';
            }
          } else {
            line += '\n';
            String firstHalf = '$indent<${t.pre.value}>';
            if (t.obj.runtimeType == String) {
              line += '$firstHalf "${t.obj}" ;';
            } else if (t.obj.runtimeType == URIRef) {
              URIRef o = t.obj as URIRef;
              line += '$firstHalf <${o.value}> ;';
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
}
