import './term.dart';

class Triple {
  final URIRef sub;
  final URIRef pre;
  dynamic obj;

  Triple({required this.sub, required this.pre, required this.obj});

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
  int get hashCode => '$sub $pre $obj .'.hashCode;

  @override
  String toString() {
    if (obj.runtimeType == String) {
      return '$sub $pre "$obj" .';
    }
    return '$sub $pre $obj .';
  }
}
