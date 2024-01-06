import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:finance_gestion_app/style/app_colors.dart';
import 'package:finance_gestion_app/utils/data_changer.dart';
import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/utils/data_getters.dart';
import 'package:finance_gestion_app/utils/firestore_setters.dart';
import 'package:flutter/material.dart';

class testDropDown extends StatefulWidget {
  const testDropDown(
      {super.key,
      required this.update,
      required this.isRevenue,
      required this.color,
      this.type});

  final Function(String) update;
  final String? type;
  final bool isRevenue;
  final Color color;

  @override
  State<testDropDown> createState() => _testDropDownState();
}

class _testDropDownState extends State<testDropDown> {
  late SingleValueDropDownController _cnt;

  List<DropDownValueModel> dropdownList = [];

  initList() async {
    List<String> transactionTypes = getTransactionTypes(widget.isRevenue);
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
    FocusNode typeFocusNode = FocusNode();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropDownTextField(
        controller: _cnt,
        clearOption: false,
        enableSearch: true,
        textFieldFocusNode: typeFocusNode,
        searchFocusNode: typeFocusNode,
        textFieldDecoration: InputDecoration(
            icon: Icon(
              Icons.abc,
              color: typeFocusNode.hasFocus ? widget.color : Colors.black,
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.color, width: 1)),
            hintText: "Type"),
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

  FocusNode titleFocusNode = FocusNode();
  FocusNode valueFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();

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
            backgroundColor: AppColors.backgoundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Form(
                  key: formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        formtitle,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        focusNode: titleFocusNode,
                        autofocus: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.label_outline_rounded,
                              color: titleFocusNode.hasFocus
                                  ? color
                                  : Colors.black,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: color, width: 1)),
                            hintText: "Titre"),
                        controller: titleController,
                        textCapitalization: TextCapitalization.words,
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
                        focusNode: valueFocusNode,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.attach_money_rounded,
                              color: valueFocusNode.hasFocus
                                  ? color
                                  : Colors.black,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: color, width: 1)),
                            hintText: "Valeur"),
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
                    testDropDown(
                        update: updateTransactionType,
                        isRevenue: isRevenue,
                        color: color,
                        type: transaction?.type),
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
                        focusNode: dateFocusNode,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.date_range_outlined,
                              color:
                                  dateFocusNode.hasFocus ? color : Colors.black,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: color, width: 1))),
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
                          value: double.parse(
                              valueController.text.replaceAll(",", ".")),
                          title: titleController.text,
                          type: transactionType,
                          isRevenue: isRevenue);
                      if (transaction == null) {
                        addTransaction(newTransaction);
                        updateParents!();
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
