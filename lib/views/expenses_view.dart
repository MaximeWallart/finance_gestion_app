import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/style/app_colors.dart';
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
    appTransactionsList = await getAppTransactions("TestId").then((value) {
      value.sort(((a, b) => b.date.compareTo(a.date)));
      return value;
    });
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
                  ? Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Text(
                        previousMonth,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLightBlack),
                      ),
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
