import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:finance_gestion_app/models/global.dart' as global;

import '../models/app_transaction.dart';
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
