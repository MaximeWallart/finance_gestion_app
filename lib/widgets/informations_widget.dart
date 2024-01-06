import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/style/app_colors.dart';
import 'package:finance_gestion_app/utils/data_getters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utils/data_changer.dart';

class InformationsWidget extends StatelessWidget {
  const InformationsWidget(
      {super.key,
      this.backgroundColor = AppColors.classicGrey,
      required this.child});

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: backgroundColor),
      child: Center(child: child),
    );
  }
}

class InformationTextWidget extends StatelessWidget {
  InformationTextWidget(
      {super.key,
      required this.number,
      this.numberFontSize = 41,
      required this.subtext});

  final String number;
  double numberFontSize;
  final String subtext;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        number,
        style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.33),
            fontSize: numberFontSize),
      ),
      Text(
        subtext,
        style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.33),
            fontSize: MediaQuery.of(context).size.width * 0.05),
      )
    ]);
  }
}

class TransactionPieChart extends StatefulWidget {
  const TransactionPieChart({super.key, required this.selectedMonth});

  final String selectedMonth;

  @override
  State<TransactionPieChart> createState() => TransactionPieChartState();
}

class TransactionPieChartState extends State<TransactionPieChart> {
  List<PieChartSectionData> pieChartSectionDataList = [
    PieChartSectionData(
        title: "test", value: 100, color: AppColors.listCharColors[0])
  ];
  List<AppTransaction> transactionsMonth = [];
  int touchedIndex = 0;

  Future<void> initTransaction() async {
    transactionsMonth =
        await getTransactionFromMonth(getMonthInt(widget.selectedMonth), isRevenue: false);
  }

  Future<void> setSelectedMonth(String selectedMonth) async {
    transactionsMonth =
        await getTransactionFromMonth(getMonthInt(selectedMonth), isRevenue: false);
    initPieChartDataList();
    selectedValue = pieChartSectionDataList[0].title;
    percentageSelected =
        "${pieChartSectionDataList[0].value.toStringAsFixed(1)}%";
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> initPieChartDataList() async {
    if (mounted) {
      setState(() {
        pieChartSectionDataList.clear();
      });
    }
    int i = 0;
    getPieChartData(transactionsMonth).forEach((key, value) {
      bool isTouched = i == touchedIndex;
      final radius = isTouched ? 40.0 : 30.0;
      if (mounted) {
        setState(() {
          pieChartSectionDataList.add(PieChartSectionData(
              title: key,
              value: value,
              radius: radius,
              showTitle: false,
              color: AppColors.listCharColors[i]));
          i++;
        });
      }
    });
  }

  @override
  void initState() {
    initTransaction().then((value) {
      initPieChartDataList();
      selectedValue = pieChartSectionDataList[0].title;
      percentageSelected =
          "${pieChartSectionDataList[0].value.toStringAsFixed(1)}%";
    });
    super.initState();
  }

  List<PieChartSectionData> showingSections() {
    setState(() {
      initPieChartDataList();
    });
    return pieChartSectionDataList;
  }

  String selectedValue = "";
  String percentageSelected = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(children: [
        Center(
            child: InformationTextWidget(
          number: percentageSelected,
          numberFontSize: MediaQuery.of(context).size.width * 0.13,
          subtext: selectedValue,
        )),
        PieChart(
          PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 100,
              sections: showingSections(), //pieChartSectionData,
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (pieTouchResponse != null &&
                        pieTouchResponse.touchedSection!.touchedSection !=
                            null) {
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                      selectedValue = pieTouchResponse
                          .touchedSection!.touchedSection!.title;
                      percentageSelected =
                          "${pieTouchResponse.touchedSection!.touchedSection!.value.toStringAsFixed(1)}%";
                    }
                  });
                },
              )),
          swapAnimationDuration: const Duration(milliseconds: 150),
          swapAnimationCurve: Curves.linear,
        ),
      ]),
    );
  }
}
