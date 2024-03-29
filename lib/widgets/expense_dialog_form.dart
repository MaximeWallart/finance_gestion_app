import 'package:finance_gestion_app/widgets/input_dialog_form.dart';
import 'package:flutter/material.dart';

import '../style/app_colors.dart';

class ExpenseDialogForm extends StatelessWidget {
  const ExpenseDialogForm(this.refresh, {super.key});

  final Function()? refresh;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await inputFormDialog(context, "Achat", AppColors.payment, false, updateParents: refresh);
      },
      style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.45,
              MediaQuery.of(context).size.width * 0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // <-- Radius
          ),
          backgroundColor: AppColors.payment),
      child: Icon(Icons.payments_rounded,
          color: Colors.black.withOpacity(0.3),
          size: MediaQuery.of(context).size.width * 0.2),
    );
  }
}
