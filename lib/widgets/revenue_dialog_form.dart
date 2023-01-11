import 'package:finance_gestion_app/widgets/input_dialog_form.dart';
import 'package:flutter/material.dart';

import '../style/app_colors.dart';
import '../utils/firestore_getters.dart';

class RevenueDialogForm extends StatefulWidget {
  const RevenueDialogForm({super.key});

  @override
  State<RevenueDialogForm> createState() => _RevenueDialogFormState();
}

class _RevenueDialogFormState extends State<RevenueDialogForm> {
  List<String> transactionTypes = [];

  void initTransactionTypes() async {
    transactionTypes = await getTransactionTypes("TestId");
  }

  @override
  void initState() {
    initTransactionTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await inputFormDialog(
            context, "Revenu", AppColors.earning, true, transactionTypes);
      },
      style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.45,
              MediaQuery.of(context).size.width * 0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // <-- Radius
          ),
          backgroundColor: AppColors.earning),
      child: Icon(Icons.savings_rounded,
          color: Colors.black.withOpacity(0.3),
          size: MediaQuery.of(context).size.width * 0.20),
    );
  }
}
