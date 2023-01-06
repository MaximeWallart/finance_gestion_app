import 'package:date_time_picker/date_time_picker.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:finance_gestion_app/utils/firestore_setters.dart';
import 'package:flutter/material.dart';

Future<void> inputFormDialog(BuildContext context, String formtitle,
    Color color, bool isRevenue, List<String> transactionTypes) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController =
      TextEditingController(text: DateTime.now().toString());
  TextEditingController valueController = TextEditingController();
  String transactionType = "test";

  List<SelectedListItem> selectedListItems = [];
  for (var element in transactionTypes) {
    selectedListItems.add(SelectedListItem(name: element));
  }

  void onTextFieldTap() {
    DropDownState(
      DropDown(
        // bottomSheetTitle: const Text(
        //   kCities,
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 20.0,
        //   ),
        // ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: selectedListItems,
        selectedItems: (List<dynamic> selectedList) {
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              list.add(item.name);
            }
          }
        },
        enableMultipleSelection: true,
      ),
    ).showModal(context);
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownSearch<String>(
                        asyncItems: (value) => getTransactionTypes("TestId"),
                        compareFn: (i, s) => i.compareTo(s) == 0,
                        onChanged: (value) => transactionType = value!,
                        validator: (value) {
                          if (value == null) {
                            return "Type requis";
                          } else {
                            return null;
                          }
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                hintText: "Type",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        popupProps: PopupProps.menu(
                          menuProps: MenuProps(
                              borderRadius: BorderRadius.circular(20)),
                          itemBuilder: (context, item, isSelected) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            );
                          },
                          emptyBuilder: (context, searchEntry) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Pas de resultat"),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.black12,
                            contentPadding: EdgeInsets.only(
                                left: 8, bottom: 0, top: 0, right: 15),
                            hintText: "hint",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            onTextFieldTap();
                          },
                        )),
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
