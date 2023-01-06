import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:finance_gestion_app/widgets/expense_dialog_form.dart';
import 'package:finance_gestion_app/widgets/revenue_dialog_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: MediaQuery.of(context).size.width * 0.2),
            child: const GetBalance(documentId: "TestId"),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [ExpenseDialogForm(), RevenueDialogForm()],
        )
      ],
    );
  }
}
