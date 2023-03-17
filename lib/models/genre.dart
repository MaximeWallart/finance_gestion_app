class Genre {
  String name;
  bool forRevenue;
  List<String> types;

  Genre({required this.name, required this.forRevenue, this.types = const []});

  @override
  String toString() => "Genre<$name>";

  Genre.fromJson(Map<String, dynamic> json)
      : this(
            name: json['name'] as String,
            forRevenue: json['forRevenue'] as bool,
            types: List<String>.from(json['types']));

  Map<String, Object> toJson() =>
      <String, Object>{'name': name, 'forRevenue': forRevenue, 'types': types};
}
