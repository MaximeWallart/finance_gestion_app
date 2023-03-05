import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/utils/data_getters.dart';
import 'package:finance_gestion_app/utils/data_changer.dart';
import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:flutter/material.dart';

import '../widgets/transaction_widget.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  List<String> assetsList = [];
  List<AppTransaction> appTransactionsList = [];

  @override
  void initState() {
    loadAssets();
    loadAppTransactionsList();
    super.initState();
  }

  void loadAssets() async {
    assetsList = await loadAssetsList();
    setState(() {});
  }

  void loadAppTransactionsList() async {
    appTransactionsList = await getAppTransactions("TestId")
        .then((value) => value.reversed.toList());
    setState(() {});
  }

  refresh() {
    loadAssets();
    loadAppTransactionsList();
  }

  @override
  Widget build(BuildContext context) {
    String previousMonth = "";
    return ListView.builder(
        itemCount: appTransactionsList.length,
        itemBuilder: ((context, index) {
          String currentMonth =
              appTransactionsList[index].date.getMonthString();
          bool monthInfo = false;
          if (previousMonth != currentMonth) {
            previousMonth = currentMonth;
            monthInfo = true;
          }
          return Column(
            children: [
              monthInfo
                  ? Text(
                      previousMonth,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    )
                  : Container(),
              TransactionWidget(
                transaction: appTransactionsList[index],
                assetsList: assetsList,
                notifyParent: refresh,
              ),
            ],
          );
        }));
    // return GetTransactions(
    //   documentId: "TestId",
    //   assetsList: assetsList,
    // );
  }
}
