import 'package:finance_gestion_app/style/app_colors.dart';
import 'package:finance_gestion_app/utils/data_analysis.dart' as analysis;
import 'package:finance_gestion_app/views/expenses_view.dart';
import 'package:finance_gestion_app/views/homepage_view.dart';
import 'package:finance_gestion_app/views/parameters_view.dart';
import 'package:finance_gestion_app/views/signin_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.currency_exchange),
            label: 'Transactions',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Paramètres',
          ),
        ],
      ),
      body: <Widget>[
        HomepageView(user: widget.user),
        const ExpensesView(),
        ParametersView(user: widget.user),
      ][currentPageIndex],
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_card_outlined),
        onPressed: () async {
          await analysis.calculatePercentageOfMonthlyBudget();
          final snackBar =
              SnackBar(content: Text("${analysis.averageMonthSpending}"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          // addTransaction(AppTransaction(
          //     date: DateTime.now(),
          //     value: 20,
          //     title: "title",
          //     type: "type",
          //     isRevenue: false));$

          // addGenre(Genre(
          //     forRevenue: false, name: "Test", types: ["tech", "jspfrr"]));
          setState(() {});
        },
      ),
    );
  }
}
