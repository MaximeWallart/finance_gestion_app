import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/style/app_colors.dart';
import 'package:finance_gestion_app/utils/data_changer.dart';
import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:finance_gestion_app/widgets/expense_dialog_form.dart';
import 'package:finance_gestion_app/widgets/informations_widget.dart';
import 'package:finance_gestion_app/widgets/revenue_dialog_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../modified/awesome_dropdown.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key, required this.user});

  final User user;

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  List<String> monthsCalendarList = ["void"];
  String selectedMonth = "Novembre";

  Future<void> initMonthsCalendarList() async {
    List<AppTransaction> value = await getAppTransactions("TestId");
    setState(() {
      monthsCalendarList =
          getMonthsCalendarTransactions(value).reversed.toList();
      selectedMonth = monthsCalendarList.first;
    });
  }

  int balance = 0;

  Future<void> initBalance() async {
    balance = await getBalance("TestId");
    setState(() {});
  }

  @override
  void initState() {
    initMonthsCalendarList();
    initBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Center(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(
            //         horizontal: 8,
            //         vertical: MediaQuery.of(context).size.width * 0.2),
            //     child: Column(
            //       children: [
            //         CircleAvatar(
            //             backgroundImage: NetworkImage(widget.user.photoURL!)),
            //         Text("Bonjour ${widget.user.displayName!} !")
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 4,
                    mainAxisCellCount: 1,
                    child: InformationsWidget(
                        child: AwesomeDropDown(
                      selectedItem: selectedMonth,
                      dropDownList: monthsCalendarList,
                      dropDownBGColor: Colors.transparent,
                      elevation: 0,
                      dropDownListTextStyle: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.33),
                          fontSize: MediaQuery.of(context).size.width * 0.045),
                      selectedItemTextStyle: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.33),
                          fontSize: MediaQuery.of(context).size.width * 0.075),
                    )),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 3,
                    mainAxisCellCount: 3,
                    child: InformationsWidget(
                        child: TransactionPieChart(
                      selectedMonth: selectedMonth.split(" ")[0],
                    )),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: InformationsWidget(
                        child: LiquidLinearProgressIndicator(
                      value: 0.54,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.earning),
                      backgroundColor: AppColors
                          .classicGrey, // Defaults to the current Theme's backgroundColor.
                      borderColor: AppColors.classicGrey,
                      borderWidth: 1.0,
                      borderRadius: 24.0,
                      direction: Axis
                          .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                      center: Text("54%",
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.33),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.075)),
                    )),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: InformationsWidget(
                        child: Stack(children: [
                      ClipPath(
                          clipper: _LinearClipper(
                            radius: 24,
                          ),
                          child: Image.asset(
                            "assets/in_app/test-gif.GIF",
                          )),
                      Center(
                        child: Text("-24%",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.33),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.075)),
                      )
                    ])),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: InformationsWidget(
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.payment,
                                      Colors.white.withOpacity(0.2)
                                    ])),
                            child: InformationTextWidget(
                              number: "48",
                              subtext: "Jours",
                            ))),
                  ),
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: InformationsWidget(
                        backgroundColor: AppColors.available,
                        child: InformationTextWidget(
                            number: "$balance €", subtext: "Disponible"), 
                      )),
                  StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: InformationsWidget(
                          backgroundColor: AppColors.economy,
                          child: InformationTextWidget(
                            number: "573 €",
                            subtext: "Économisés",
                          ))),
                ],
              ),
            ),
            Divider(
              thickness: 3,
              color: Colors.black.withOpacity(0.25),
              endIndent: 8,
              indent: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [RevenueDialogForm(), ExpenseDialogForm()],
            )
          ],
        ),
      ),
    );
  }
}

class _LinearClipper extends CustomClipper<Path> {
  final double? radius;

  _LinearClipper({required this.radius});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius ?? 0),
        ),
      );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
