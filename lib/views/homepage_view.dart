import 'package:finance_gestion_app/style/app_colors.dart';
import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:finance_gestion_app/widgets/expense_dialog_form.dart';
import 'package:finance_gestion_app/widgets/informations_widget.dart';
import 'package:finance_gestion_app/widgets/revenue_dialog_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key, required this.user});

  final User user;

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        // Center(
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(
        //         horizontal: 8,
        //         vertical: MediaQuery.of(context).size.width * 0.2),
        //     child: const GetBalance(documentId: "TestId"),
        //   ),
        // ),
        Container(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 1,
                child: InformationsWidget(child: Container()),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 3,
                mainAxisCellCount: 3,
                child: InformationsWidget(child: Container()),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: InformationsWidget(child: Container()),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: InformationsWidget(child: Container()),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: InformationsWidget(child: Container()),
              ),
              StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: InformationsWidget(
                    backgroundColor: AppColors.available,
                    child: InformationTextWidget(
                        number: GetBalance(
                            documentId: "TestId",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.33),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.1)),
                        subtext: "Disponible"),
                  )),
              StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: InformationsWidget(
                      backgroundColor: AppColors.economy,
                      child: InformationTextWidget(
                        number: Text(
                          "573 €",
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.33),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.1),
                        ),
                        subtext: "Économisés",
                      ))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(thickness: 3, color: Colors.black.withOpacity(0.3)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [RevenueDialogForm(), ExpenseDialogForm()],
        )
      ],
    );
  }
}
