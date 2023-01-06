import 'package:finance_gestion_app/models/transaction_type.dart';

class Genre {
  String name;
  List<TransactionType> types;

  Genre({required this.name, this.types = const []});

  @override
  String toString() => "Genre<$name>";

  Genre.fromJson(Map<String, Object> json)
      : this(
            name: json['name'] as String,
            types: json['types'] as List<TransactionType>);

  Map<String, Object> toJson() =>
      <String, Object>{'name:': name, 'types': types};
}
