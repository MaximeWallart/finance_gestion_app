import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_gestion_app/models/app_transaction.dart';

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
