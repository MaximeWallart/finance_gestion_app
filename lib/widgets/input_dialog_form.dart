import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:finance_gestion_app/utils/data_changer.dart';
import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/utils/firestore_setters.dart';
import 'package:flutter/material.dart';

import '../utils/firestore_getters.dart';

class testDropDown extends StatefulWidget {
  const testDropDown({super.key, required this.update, this.type});

  final Function(String) update;
  final String? type;

  @override
  State<testDropDown> createState() => _testDropDownState();
}

class _testDropDownState extends State<testDropDown> {
  late SingleValueDropDownController _cnt;

  List<DropDownValueModel> dropdownList = [];

  initList() async {
    List<String> transactionTypes = await getTransactionTypes("TestId");
    setState(() {
      dropdownList = List.generate(
          transactionTypes.length,
          (index) => DropDownValueModel(
              name: transactionTypes[index], value: transactionTypes[index]));
    });
  }

  @override
  void initState() {
    _cnt = SingleValueDropDownController(
        data: DropDownValueModel(name: widget.type ?? "", value: widget.type));
    super.initState();
    initList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropDownTextField(
        controller: _cnt,
        clearOption: false,
        enableSearch: true,
        textFieldDecoration: InputDecoration(
            hintText: "Type",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        validator: (value) {
          if (value == null) {
            return "Required field";
          } else {
            return null;
          }
        },
        dropDownItemCount: 6,
        dropDownList: dropdownList,
        onChanged: (val) {
          DropDownValueModel value = val as DropDownValueModel;
          widget.update(value.name);
        },
      ),
    );
  }
}

Future<void> inputFormDialog(
    BuildContext context, String formtitle, Color color, bool isRevenue,
    {AppTransaction? transaction, Function()? updateParents}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController =
      TextEditingController(text: DateTime.now().toString());
  TextEditingController valueController = TextEditingController();
  String transactionType = "test";

  if (transaction != null) {
    titleController.text = transaction.title;
    dateController.text = transaction.date.toString();
    valueController.text = transaction.value.removeExtraZeros();
    transactionType = transaction.type;
  }

  void updateTransactionType(String newType) {
    transactionType = newType;
  }

  showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Form(
                  key: formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          formtitle,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: "Titre",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        controller: titleController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le titre doit ??tre renseign??';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Valeur",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        controller: valueController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La valeur doit ??tre renseign??e';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    // FAIRE UNE SUGGESTION SELON LE TITRE COMME POUR LES PHOTOS
                    testDropDown(
                        update: updateTransactionType, type: transaction?.type),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        dateMask: 'd MMM, yyyy',
                        controller: dateController,
                        //initialValue: _initialValue,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: const Icon(Icons.event),
                        dateLabelText: 'Date',
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        //use24HourFormat: false,
                        //locale: Locale('pt', 'BR'),
                      ),
                    ),
                  ])),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      AppTransaction newTransaction = AppTransaction(
                          date: DateTime.parse(dateController.text),
                          value: double.parse(valueController.text),
                          title: titleController.text,
                          type: transactionType,
                          isRevenue: isRevenue);
                      if (transaction == null) {
                        addTransaction(newTransaction);
                      } else {
                        modifyTransaction(transaction, newTransaction);
                        updateParents!();
                      }
                      Navigator.pop(context);
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Enregistrer")),
            ],
          );
        });
      },
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (cxt, a1, a2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
              .animate(a1),
          child: child,
        );
      });
}
