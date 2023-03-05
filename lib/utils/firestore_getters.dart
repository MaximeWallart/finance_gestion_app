import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';

Future<int> getBalance(String docId) async {
  int result = 0;
  var doc = FirebaseFirestore.instance.collection('Users').doc(docId);
  DocumentSnapshot documentSnapshot = await doc.get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> optionsDoc =
        documentSnapshot.data() as Map<String, dynamic>;
    result = int.parse(optionsDoc['Balance'].toString());
  }
  return result;
}

Future<List<String>> getTransactionTypes(String docId,
    [String withoutThisOne = ""]) async {
  List<String> types = [];
  var doc = FirebaseFirestore.instance.collection('Users').doc(docId);
  DocumentSnapshot documentSnapshot = await doc.get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> optionsDoc =
        documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> counterList = optionsDoc['Types'];
    types = counterList.map((type) => type.toString()).toList();
  }
  if (withoutThisOne != "") {
    types.remove(withoutThisOne);
  }
  return types;
}

Future<List<AppTransaction>> getAppTransactions(String docId,
    [String transactionType = ""]) async {
  List<AppTransaction> transactions = [];
  var doc = FirebaseFirestore.instance.collection('Users').doc(docId);
  DocumentSnapshot documentSnapshot = await doc.get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> optionsDoc =
        documentSnapshot.data() as Map<String, dynamic>;
    List experiences = optionsDoc['Transactions'];
    for (var element in experiences) {
      AppTransaction transaction = AppTransaction.fromJson(element);
      if (transactionType != "") {
        if (transaction.type == transactionType) {
          transactions.add(transaction);
        }
      } else {
        transactions.add(transaction);
      }
    }
  }
  return transactions;
}

class GetTransactions extends StatefulWidget {
  const GetTransactions(
      {super.key, required this.documentId, required this.assetsList});

  final String documentId;
  final List<String> assetsList;

  @override
  State<GetTransactions> createState() => _GetTransactionsState();
}

class _GetTransactionsState extends State<GetTransactions> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List experiences = List.from(snapshot.data!.get('Transactions'))
              .reversed
              .toList(); // This line should be inside if block
          return ListView.builder(
              itemCount: experiences.length,
              itemBuilder: ((context, index) {
                return TransactionWidget(
                  transaction: AppTransaction.fromJson(experiences[index]),
                  assetsList: widget.assetsList,
                );
              })); // You forgot to add 'return' here
        }

        return const Center(child: Text("loading"));
      },
    );
  }
}
