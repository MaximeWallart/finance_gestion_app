import 'package:cloud_firestore/cloud_firestore.dart';

class AppTransaction {
  DateTime date;
  double value;
  String title;
  String type;
  bool isRevenue;

  AppTransaction(
      {required this.date,
      required this.value,
      required this.title,
      required this.type,
      required this.isRevenue});

  @override
  String toString() => "Transaction<$title>";

  AppTransaction.fromJson(Map<String, dynamic> json)
      : this(
            date: (json['Date'] as Timestamp).toDate(),
            value: json['Value'] * 1.0 as double,
            title: json['Title'] as String,
            type: json['Type'] as String,
            isRevenue: json['IsRevenue'] as bool);

  Map<String, Object> toJson() => <String, Object>{
        'Date': date,
        'Value': value,
        'Title': title,
        'Type': type,
        'IsRevenue': isRevenue
      };
}
