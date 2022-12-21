import './term.dart';

class Triple {
  final URIRef sub;
  final URIRef pre;
  dynamic obj;

  Triple({required this.sub, required this.pre, required this.obj}) {
    if (obj.runtimeType == String) {
      obj = Literal(obj);
    }
  }

  /// for checking if two triples are the same for them to be put
  /// in the set of the graph efficiently (without duplicates)
  @override
  bool operator ==(Object other) {
    return other is Triple &&
        runtimeType == other.runtimeType &&
        sub.value == other.sub.value &&
        pre.value == other.pre.value &&
        obj == other.obj;
  }

  @override
  int get hashCode => '$sub $pre $obj'.hashCode;

  @override
  String toString() {
    if (obj.runtimeType == String) {
      return 'Triple<sub: ${sub.value}, pre: ${pre.value}, obj: "$obj">';
    }
    return 'Triple<sub: ${sub.value}, pre: ${pre.value}, obj: $obj>';
  }
}
