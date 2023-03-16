import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:finance_gestion_app/models/global.dart' as global;

import '../../models/transaction_type.dart';
import '../../style/app_colors.dart';
import '../../utils/data_getters.dart';
import '../../utils/data_setters.dart';
import '../../utils/firestore_setters.dart';

class TypeListView extends StatefulWidget {
  const TypeListView({super.key});

  @override
  State<TypeListView> createState() => _TypeListViewState();
}

class _TypeListViewState extends State<TypeListView> {
  List<String> typesList = [];

  Future<void> initList() async {
    typesList = await getTransactionTypes(global.docId);
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
            Container(
              color: AppColors.payment.withOpacity(0.2),
              child: FutureBuilder<List<String>>(
                future: getTransactionTypes(global.docId),
                initialData: const ["Loading"],
                builder: (context, snapshot) {
                  int itemCount = snapshot.data?.length ?? 0;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: itemCount + 1,
                    itemBuilder: (context, index) {
                      if (index == itemCount) {
                        return ListTile(
                            onTap: () {
                              formPopUp(context, refresh);
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
                          startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    bool verif =
                                        await anyTransactionsUseTransactionType(
                                            snapshot.data![index]);
                                    if (verif == false) {
                                      deleteTransactionType(
                                          snapshot.data![index]);
                                    } else {
                                      askReplacementPopUp(context, refresh,
                                          snapshot.data![index]);
                                    }
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Supprimer',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    formPopUp(context, refresh,
                                        oldName: snapshot.data![index]);
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
                                snapshot.data![index],
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
                  );
                },
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                color: AppColors.earning.withOpacity(0.5),
                width: double.infinity,
                child: const Center(
                  child: Text(
                    "Types Revenus",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}

Future<void> formPopUp(BuildContext context, Function() setState,
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
                      TransactionType transactionType =
                          TransactionType(name: nameController.text);
                      if (oldName == null) {
                        addTransactionType(transactionType);
                      } else {
                        updateTransactionsByTransactionType(
                            oldName, transactionType.name);
                        modifyTransactionType(oldName, transactionType);
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

Future<void> askReplacementPopUp(
    BuildContext context, Function() setState, String transactionType) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> transactionTypes =
      await getTransactionTypes(global.docId, transactionType);
  List<DropdownMenuItem> listDropdown = List.generate(
      transactionTypes.length,
      (index) => DropdownMenuItem(
          value: transactionTypes[index],
          child: Text(transactionTypes[index])));

  String selectedTransactionType = transactionTypes.first;

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
                              selectedTransactionType = value;
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
                      deleteTransactionType(transactionType);
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
