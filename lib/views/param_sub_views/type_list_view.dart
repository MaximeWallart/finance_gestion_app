import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../style/app_colors.dart';
import '../../utils/data_getters.dart' as data;
import '../../utils/data_getters.dart';
import '../../utils/data_setters.dart';

class TypeListView extends StatefulWidget {
  const TypeListView({super.key});

  @override
  State<TypeListView> createState() => _TypeListViewState();
}

class _TypeListViewState extends State<TypeListView> {
  List<String> typesList = [];

  Future<void> initList() async {
    typesList = data.getTransactionTypes(false);
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                color: AppColors.payment.withOpacity(0.5),
                width: double.infinity,
                child: const Center(
                  child: Text(
                    "Types Dépenses",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
            listOfTransactionTypes(false),
            Container(
                padding: const EdgeInsets.all(8),
                color: AppColors.earning.withOpacity(0.5),
                width: double.infinity,
                child: const Center(
                  child: Text(
                    "Types Revenus",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
            listOfTransactionTypes(true)
          ],
        ),
      ),
    ));
  }

  Container listOfTransactionTypes(bool forRevenue) {
    List<String> typesList = data.getTransactionTypes(forRevenue);
    return Container(
      color: forRevenue
          ? AppColors.earning.withOpacity(0.2)
          : AppColors.payment.withOpacity(0.2),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: typesList.length + 1,
        itemBuilder: (context, index) {
          if (index == typesList.length) {
            return ListTile(
                onTap: () async {
                  formPopUp(context, refresh, forRevenue);
                  setState(() {});
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                tileColor: Colors.white,
                title: Icon(
                  Icons.add,
                  color: Colors.black.withOpacity(0.5),
                  size: 20,
                ));
          } else {
            return Slidable(
              startActionPane:
                  ActionPane(motion: const ScrollMotion(), children: [
                SlidableAction(
                  onPressed: (context) async {
                    bool verif = await data.anyTransactionsUseTransactionType(
                        typesList[index], forRevenue);
                    if (verif == false) {
                      deleteTransactionTypeFromGenre(
                          forRevenue, typesList[index]);
                      setState(() {});
                    } else {
                      if (typesList.length > 1) {
                        askReplacementPopUp(
                            context, refresh, forRevenue, typesList[index]);
                      } else {
                        showGeneralDialog(
                            barrierLabel: "",
                            barrierDismissible: true,
                            context: context,
                            pageBuilder: (ctx, a1, a2) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  scrollable: true,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  content: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Text(
                                          "Vous ne pouvez pas supprimer ce type car des transactions l'utilise et qu'il n'y a pas d'autre type pour le remplacer")),
                                );
                              });
                            });
                      }
                    }
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Supprimer',
                ),
                SlidableAction(
                  onPressed: (context) {
                    formPopUp(context, refresh, forRevenue,
                        oldName: typesList[index]);
                    setState(() {});
                  },
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  icon: Icons.mode,
                  label: 'Modifier',
                ),
              ]),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                tileColor: Colors.white,
                title: Center(
                  child: Text(
                    typesList[index],
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 15),
                  ),
                ),
              ),
              // subtitle: Text(widget.transaction.type),
            );
          }
        },
      ),
    );
  }
}

Future<void> formPopUp(
    BuildContext context, Function() setState, bool forRevenue,
    {String? oldName}) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: oldName);

  showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Form(
                    key: formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            "Nom du type de Transaction",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: 1,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              hintText: "Nom",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le titre doit être renseigné';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      )
                    ]))),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (oldName == null) {
                        addTransactionTypeToGenre(
                            forRevenue, nameController.text);
                      } else {
                        updateTransactionsByTransactionType(
                            oldName, nameController.text);
                        updateTransactionTypeFromGenre(
                            forRevenue, oldName, nameController.text);
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
      }).then((value) => setState());
}

Future<void> askReplacementPopUp(BuildContext context, Function() setState,
    bool forRevenue, String transactionType) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> transactionTypes =
      getTransactionTypes(forRevenue, transactionType);
  List<DropdownMenuItem> listDropdown = List.generate(
      transactionTypes.length,
      (index) => DropdownMenuItem(
          value: transactionTypes[index],
          child: Text(transactionTypes[index])));

  showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: true,
      context: context,
      pageBuilder: (ctx, a1, a2) {
        String selectedTransactionType = transactionTypes.first;
        return StatefulBuilder(builder: (context, setPopUpState) {
          return AlertDialog(
            scrollable: true,
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Form(
                    key: formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            "Il existe des transactions qui utilisent ce type",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            "Veuillez choisir un remplacement",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                            items: listDropdown,
                            borderRadius: BorderRadius.circular(20),
                            value: selectedTransactionType,
                            onChanged: ((value) {
                              setPopUpState(
                                  () => selectedTransactionType = value);
                              print(selectedTransactionType);
                            })),
                      ),
                    ]))),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      updateTransactionsByTransactionType(
                          transactionType, selectedTransactionType);
                      deleteTransactionTypeFromGenre(
                          forRevenue, transactionType);
                      Navigator.pop(context);
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Enregistrer")),
            ],
          );
        });
      }).then((value) => setState());
}
