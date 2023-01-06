import 'package:finance_gestion_app/utils/data_getters.dart';
import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:flutter/material.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  List<String> assetsList = [];

  @override
  void initState() {
    loadAssets();
    super.initState();
  }

  void loadAssets() async {
    assetsList = await loadAssetsList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetTransactions(
      documentId: "TestId",
      assetsList: assetsList,
    );
  }
}
