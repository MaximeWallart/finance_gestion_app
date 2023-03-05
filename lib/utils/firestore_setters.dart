import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/models/transaction_type.dart';

void addTransaction(AppTransaction transaction) {
  FirebaseFirestore.instance.collection("Users").doc("TestId").update({
    "Transactions": FieldValue.arrayUnion([transaction.toJson()])
  }).then((value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}

void deleteTransaction(AppTransaction transaction) {
  FirebaseFirestore.instance.collection("Users").doc("TestId").update({
    "Transactions": FieldValue.arrayRemove([transaction.toJson()])
  }).then((value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}

void addTransactionType(TransactionType transactionType) {
  FirebaseFirestore.instance.collection("Users").doc("TestId").update({
    "Types": FieldValue.arrayUnion([transactionType.name])
  }).then((value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}

void deleteTransactionType(String transactionType) {
  FirebaseFirestore.instance.collection("Users").doc("TestId").update({
    "Types": FieldValue.arrayRemove([transactionType])
  }).then((value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}
