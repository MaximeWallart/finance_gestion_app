import 'package:finance_gestion_app/utils/firestore_getters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TypeListView extends StatefulWidget {
  const TypeListView({super.key});

  @override
  State<TypeListView> createState() => _TypeListViewState();
}

class _TypeListViewState extends State<TypeListView> {
  List<String> typesList = [];

  Future<void> initList() async {
    typesList = await getTransactionTypes("TestId");
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<String>>(
      future: getTransactionTypes("TestId"),
      initialData: const ["Loading"],
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return Slidable(
              startActionPane:
                  ActionPane(motion: const ScrollMotion(), children: [
                SlidableAction(
                  onPressed: (context) async {
                    // deleteTransaction(widget.transaction);
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                tileColor: Colors.white,
                title: Text(
                  snapshot.data![index],
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.33),
                      fontSize: 15),
                ),
              ),
              // subtitle: Text(widget.transaction.type),
            );
          },
        );
      },
    ));
  }
}
