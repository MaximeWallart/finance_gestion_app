import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/utils/firestore_setters.dart';
import 'package:flutter/material.dart';

class testDropDown extends StatefulWidget {
  const testDropDown({super.key});

  @override
  State<testDropDown> createState() => _testDropDownState();
}

class _testDropDownState extends State<testDropDown> {
  late SingleValueDropDownController _cnt;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
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
        dropDownList: const [
          DropDownValueModel(name: 'name1', value: "value1"),
          DropDownValueModel(
              name: 'name2',
              value: "value2",
              toolTipMsg:
                  "DropDownButton is a widget that we can use to select one unique value from a set of values"),
          DropDownValueModel(name: 'name3', value: "value3"),
          DropDownValueModel(
              name: 'name4',
              value: "value4",
              toolTipMsg:
                  "DropDownButton is a widget that we can use to select one unique value from a set of values"),
          DropDownValueModel(name: 'name5', value: "value5"),
          DropDownValueModel(name: 'name6', value: "value6"),
          DropDownValueModel(name: 'name7', value: "value7"),
          DropDownValueModel(name: 'name8', value: "value8"),
        ],
        onChanged: (val) {},
      ),
    );
  }
}

Future<void> inputFormDialog(BuildContext context, String formtitle,
    Color color, bool isRevenue, List<String> transactionTypes) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController =
      TextEditingController(text: DateTime.now().toString());
  TextEditingController valueController = TextEditingController();
  String transactionType = "test";

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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le titre doit être renseigné';
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
                            return 'La valeur doit être renseignée';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    // FAIRE UNE SUGGESTION SELON LE TITRE COMME POUR LES PHOTOS
                    const testDropDown(),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: DropdownSearch<String>(
                    //     asyncItems: (value) => getTransactionTypes("TestId"),
                    //     compareFn: (i, s) => i.compareTo(s) == 0,
                    //     onChanged: (value) => transactionType = value!,
                    //     validator: (value) {
                    //       if (value == null) {
                    //         return "Type requis";
                    //       } else {
                    //         return null;
                    //       }
                    //     },
                    //     dropdownDecoratorProps: DropDownDecoratorProps(
                    //         dropdownSearchDecoration: InputDecoration(
                    //             hintText: "Type",
                    //             border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(20)))),
                    //     popupProps: PopupProps.menu(
                    //       menuProps: MenuProps(
                    //           borderRadius: BorderRadius.circular(20)),
                    //       itemBuilder: (context, item, isSelected) {
                    //         return Center(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(12.0),
                    //             child: Text(
                    //               item,
                    //               style: const TextStyle(fontSize: 15),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //       emptyBuilder: (context, searchEntry) {
                    //         return const Padding(
                    //           padding: EdgeInsets.all(8.0),
                    //           child: Text("Pas de resultat"),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      AppTransaction transaction = AppTransaction(
                          date: DateTime.parse(dateController.text),
                          value: double.parse(valueController.text),
                          title: titleController.text,
                          type: transactionType,
                          isRevenue: isRevenue);
                      addTransaction(transaction);
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
