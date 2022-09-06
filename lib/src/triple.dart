import './term.dart';

class Triple {
  final URIRef sub;
  final URIRef pre;
  dynamic obj;

  Triple({required this.sub, required this.pre, required this.obj});

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
    return '$sub $pre $obj .';
  }
}

main() {
  Triple t = Triple(
      sub: URIRef.fullUri('sublink'), pre: URIRef.fullUri('prelink'), obj: 5);
  Triple t1 = Triple(
      sub: URIRef.fullUri('sublink'), pre: URIRef.fullUri('prelink'), obj: 5);
  Set se = {};
  se.add(t);
  print(se);
  print(t == t1);
  print(t.hashCode == t1.hashCode);
  se.add(t1);
  print(se);
}
