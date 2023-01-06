class TransactionType {
  String name;

  TransactionType({required this.name});

  @override
  String toString() => "Type<$name>";

  TransactionType.fromJson(Map<String, dynamic> json)
      : this(name: json['name'] as String);

  Map<String, dynamic> toJson() => <String, dynamic>{'name': name};

  isEqual(TransactionType s) {
    return name.compareTo(s.name);
  }
}
