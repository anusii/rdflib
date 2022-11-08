enum BaseType { shorthandBase, defaultBase }

extension ParseToString on BaseType {
  String get name => this.toString().split('.').last;
}
