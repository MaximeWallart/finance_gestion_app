import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:finance_gestion_app/models/global.dart' as global;

import '../models/app_transaction.dart';
import '../models/genre.dart';
import 'firestore_setters.dart';

void updateTransaction(AppTransaction transaction, String transactionType) {
  deleteTransaction(transaction);
  transaction.type = transactionType;
  addTransaction(transaction);
}

void updateTransactionsByTransactionType(
    String oldTransactionType, String newTransactionType) async {
  List<AppTransaction> transactions =
      await getAppTransactions(global.docId, oldTransactionType);
  for (var element in transactions) {
    updateTransaction(element, newTransactionType);
  }
}

void deleteTransactionTypeFromGenre(bool forRevenue, String transactionType) {
  List<Genre> result = global.genres;

  result
      .firstWhere((element) => (element.forRevenue == forRevenue &&
          element.types.contains(transactionType)))
      .types
      .remove(transactionType);

  updateGenres(result);
}

void addTransactionTypeToGenre(bool forRevenue, String transactionType) {
  List<Genre> result = global.genres;

  result
      .firstWhere((element) => element.forRevenue == forRevenue)
      .types
      .add(transactionType);

  updateGenres(result);
}

void updateTransactionTypeFromGenre(
    bool forRevenue, String oldTransactionType, String newTransactionType) {
  deleteTransactionTypeFromGenre(forRevenue, oldTransactionType);
  addTransactionTypeToGenre(forRevenue, newTransactionType);
}
