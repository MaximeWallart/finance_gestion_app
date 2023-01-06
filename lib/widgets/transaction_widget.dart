import 'package:finance_gestion_app/style/app_colors.dart';
import 'package:finance_gestion_app/utils/data_changer.dart';
import 'package:finance_gestion_app/utils/firestore_setters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/app_transaction.dart';

class TransactionWidget extends StatefulWidget {
  const TransactionWidget(
      {super.key, required this.transaction, required this.assetsList});

  final AppTransaction transaction;
  final List<String> assetsList;

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  String res = "assets/receipt_long_default.png";

  @override
  void initState() {
    super.initState();
    validateToAnImage();
  }

  void validateToAnImage() {
    for (String image in widget.assetsList) {
      String imageCopy = image;
      imageCopy = imageCopy
          .split("/")
          .last
          .split(".")
          .first
          .toLowerCase()
          .replaceAll(" ", "");
      List<String> imageCopyList = imageCopy.split("!");
      for (var element in imageCopyList) {
        if (widget.transaction.title
            .toLowerCase()
            .replaceAll(" ", "")
            .contains(element)) {
          res = image;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Slidable(
          startActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              onPressed: (context) async {
                deleteTransaction(widget.transaction);
                setState(() {});
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Supprimer',
            ),
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.mode,
              label: 'Modifier',
            ),
          ]),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: Colors.white,
            leading: CircleAvatar(
              backgroundImage: AssetImage(res),
              // backgroundImage: NetworkImage(
              //     "https://pbs.twimg.com/profile_images/1411931118102794243/b_VOvfDz_400x400.jpg"),
            ),
            title: Text(widget.transaction.title),
            subtitle: Text(widget.transaction.type),
            trailing: FittedBox(
              fit: BoxFit.fill,
              child: Row(
                children: <Widget>[
                  Text(widget.transaction.date.toStringWithWords()),
                  const VerticalDivider(),
                  Text(
                      "${widget.transaction.isRevenue ? "+" : "-"} ${widget.transaction.value.toStringWithMaxPrecision()}€",
                      textHeightBehavior: const TextHeightBehavior(),
                      style: TextStyle(
                          fontSize: 15,
                          color: AppColors.amountVariantColor(
                              widget.transaction.value,
                              widget.transaction.isRevenue))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
