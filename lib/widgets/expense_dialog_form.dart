import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:finance_gestion_app/widgets/input_dialog_form.dart';
import 'package:flutter/material.dart';

import '../style/app_colors.dart';

class ExpenseDialogForm extends StatefulWidget {
  const ExpenseDialogForm({super.key});

  @override
  State<ExpenseDialogForm> createState() => _ExpenseDialogFormState();
}

class _ExpenseDialogFormState extends State<ExpenseDialogForm> {
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
            context, "Achat", AppColors.paymentLight, false, transactionTypes);
      },
      style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.45,
              MediaQuery.of(context).size.width * 0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
          ),
          backgroundColor: AppColors.paymentDark),
      child: Icon(Icons.payment,
          color: AppColors.paymentLight.withOpacity(0.7),
          size: MediaQuery.of(context).size.width * 0.13),
    );
  }
}
