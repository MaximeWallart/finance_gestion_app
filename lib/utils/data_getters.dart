import 'dart:convert';

import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:flutter/services.dart';
import 'package:finance_gestion_app/models/global.dart' as global;

Future<List<String>> loadAssetsList() async {
  // >> To get paths you need these 2 lines
  final manifestContent = await rootBundle.loadString('AssetManifest.json');

  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  // >> To get paths you need these 2 lines

  final imagePaths = manifestMap.keys
      .where((String key) => key.contains('transaction_images/'))
      .toList();

  return imagePaths;
}

List<String> getTransactionTypes(bool forRevenue,
    [String withoutThisOne = ""]) {
  List<String> result = [];
  for (var element in global.genres) {
    if (element.forRevenue == forRevenue) {
      result.addAll(element.types);
    }
  }
  if (withoutThisOne != "") {
    result.remove(withoutThisOne);
  }
  return result;
}

Future<List<AppTransaction>> getTransactionFromMonth(int month) async {
  List<AppTransaction> transactions = await getAppTransactions(global.docId);
  transactions.removeWhere((element) => element.date.month != month);
  return transactions;
}

Future<bool> anyTransactionsUseTransactionType(String transactionType, [bool isRevenue = false]) async {
  List<AppTransaction> transactions =
      await getAppTransactions(global.docId, transactionType, isRevenue);
  if (transactions.isNotEmpty) {
    return true;
  }
  return false;
}
