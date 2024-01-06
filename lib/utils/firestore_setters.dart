import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/models/genre.dart';
import 'package:finance_gestion_app/models/global.dart' as global;
import 'package:finance_gestion_app/utils/firestore_getters.dart';

void addTransaction(AppTransaction transaction) {
  FirebaseFirestore.instance
      .collection(global.collectionName)
      .doc(global.docId)
      .update({
    "Transactions": FieldValue.arrayUnion([transaction.toJson()])
  }).then((value) {
    print("DocumentSnapshot successfully updated!");
    if (transaction.isRevenue) {
      addToBalance(transaction);
    } else {
      removeFromBalance(transaction);
    }
  }, onError: (e) => print("Error updating document $e"));
}

void deleteTransaction(AppTransaction transaction) {
  FirebaseFirestore.instance
      .collection(global.collectionName)
      .doc(global.docId)
      .update({
    "Transactions": FieldValue.arrayRemove([transaction.toJson()])
  }).then((value) {
    print("DocumentSnapshot successfully updated! - Deleted Transaction");
    if (transaction.isRevenue) {
      removeFromBalance(transaction);
    } else {
      addToBalance(transaction);
    }
  }, onError: (e) => print("Error updating document $e"));
}

void modifyTransaction(
    AppTransaction oldTransaction, AppTransaction newTransaction) {
  deleteTransaction(oldTransaction);
  addTransaction(newTransaction);
}

void addGenre(Genre genre) {
  FirebaseFirestore.instance
      .collection(global.collectionName)
      .doc(global.docId)
      .update({
    "Genres": FieldValue.arrayUnion([genre.toJson()])
  }).then((value) async {
    print("DocumentSnapshot successfully updated!");
    global.genres = await getGenres(global.docId);
  }, onError: (e) => print("Error updating document $e"));
}

void updateGenres(List<Genre> genres) {
  FirebaseFirestore.instance
      .collection(global.collectionName)
      .doc(global.docId)
      .update({"Genres": genres.map((e) => e.toJson()).toList()}).then(
          (value) async {
    print("DocumentSnapshot successfully updated!");
    global.genres = await getGenres(global.docId);
  }, onError: (e) => print("Error updating document $e"));
}

void addToBalance(AppTransaction transaction) {
  double newBalance = global.account.balance + transaction.value;
  global.account.balance = newBalance;
  updateBalance(newBalance);
}

void removeFromBalance(AppTransaction transaction) {
  double newBalance = global.account.balance - transaction.value;
  global.account.balance = newBalance;
  updateBalance(newBalance);
}

void resetBalance() async {
  List<AppTransaction> transactions = await getAppTransactions(global.docId);
  double balance = 0;
  for (var element in transactions) {
    if (element.isRevenue) {
      balance += element.value;
    } else {
      balance -= element.value;
    }
  }
  updateBalance(balance);
}

void updateBalance(double value) {
  FirebaseFirestore.instance
      .collection(global.collectionName)
      .doc(global.docId)
      .update({"Balance": value}).then(
          (value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
}
