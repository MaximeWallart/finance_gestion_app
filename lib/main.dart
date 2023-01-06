import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/style/app_colors.dart';
import 'package:finance_gestion_app/utils/firestore_setters.dart';
import 'package:finance_gestion_app/views/expenses_view.dart';
import 'package:finance_gestion_app/views/homepage_view.dart';
import 'package:finance_gestion_app/views/signin_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInView(),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key, required this.user});

  final User user;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgoundColor,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            selectedIcon: Transform.rotate(
              angle: 90 * math.pi / 180,
              child: const Icon(Icons.play_arrow),
            ),
            icon: Transform.rotate(
              angle: 90 * math.pi / 180,
              child: const Icon(Icons.play_arrow_outlined),
            ),
            label: 'Dépenses',
          ),
          NavigationDestination(
            selectedIcon: Transform.rotate(
                angle: 270 * math.pi / 180,
                child: const Icon(Icons.play_arrow)),
            icon: Transform.rotate(
                angle: 270 * math.pi / 180,
                child: const Icon(Icons.play_arrow_outlined)),
            label: 'Revenus',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined),
            label: 'Je sais pas',
          ),
        ],
      ),
      body: <Widget>[
        HomepageView(user: widget.user),
        const ExpensesView(),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
        Container(
          color: Colors.purple,
          alignment: Alignment.center,
          child: const Text('Page 4'),
        ),
      ][currentPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTransaction(AppTransaction(
              date: DateTime.now(),
              value: 20,
              title: "title",
              type: "type",
              isRevenue: false));
        },
      ),
    );
  }
}
