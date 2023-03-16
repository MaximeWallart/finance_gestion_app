class Genre {
  String name;
  bool forRevenue;
  List<String> types;

  Genre({required this.name, required this.forRevenue, this.types = const []});

  @override
  String toString() => "Genre<$name>";

  Genre.fromJson(Map<String, Object> json)
      : this(
            name: json['name'] as String,
            forRevenue: json['forRevenue'] as bool,
            types: json['types'] as List<String>);

  Map<String, Object> toJson() =>
      <String, Object>{'name': name, 'forRevenue': forRevenue, 'types': types};
}
