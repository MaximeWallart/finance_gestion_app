import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/models/genre.dart';
import 'package:finance_gestion_app/models/global.dart' as global;

Future<double> getBalance(String docId) async {
  double result = 0;
  var doc =
      FirebaseFirestore.instance.collection(global.collectionName).doc(docId);
  DocumentSnapshot documentSnapshot = await doc.get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> optionsDoc =
        documentSnapshot.data() as Map<String, dynamic>;
    result = double.parse(optionsDoc['Balance'].toString());
  }
  return result;
}

Future<List<Genre>> getGenres(String docId, [bool? forRevenue]) async {
  List<Genre> genres = [];
  var doc =
      FirebaseFirestore.instance.collection(global.collectionName).doc(docId);
  DocumentSnapshot documentSnapshot = await doc.get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> optionsDoc =
        documentSnapshot.data() as Map<String, dynamic>;
    List fetchedGenres = optionsDoc['Genres'];
    for (var element in fetchedGenres) {
      Genre genre = Genre.fromJson(element);
      if (forRevenue != null) {
        if (genre.forRevenue == forRevenue) {
          genres.add(genre);
        }
      } else {
        genres.add(genre);
      }
    }
  }
  return genres;
}

Future<List<AppTransaction>> getAppTransactions(String docId,
    [String? transactionType, bool? isRevenue]) async {
  List<AppTransaction> transactions = [];
  var doc =
      FirebaseFirestore.instance.collection(global.collectionName).doc(docId);
  DocumentSnapshot documentSnapshot = await doc.get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> optionsDoc =
        documentSnapshot.data() as Map<String, dynamic>;
    List experiences = optionsDoc['Transactions'];
    for (var element in experiences) {
      AppTransaction transaction = AppTransaction.fromJson(element);
      if (isTransactionType(transactionType, transaction.type) &&
          isItRevenue(isRevenue, transaction.isRevenue)) {
        transactions.add(transaction);
      }
    }
  }
  return transactions;
}

bool isTransactionType(String? type, String transactionType) {
  if (type != null) {
    if (type == transactionType) {
      return true;
    } else {
      return false;
    }
  }
  return true;
}

bool isItRevenue(bool? isRevenue, bool transactionIsRevenue) {
  if (isRevenue != null) {
    if (isRevenue == transactionIsRevenue) {
      return true;
    } else {
      return false;
    }
  }
  return true;
}
