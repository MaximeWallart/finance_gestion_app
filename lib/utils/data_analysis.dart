import 'package:finance_gestion_app/models/app_transaction.dart';
import 'package:finance_gestion_app/models/global.dart' as global;
import 'package:finance_gestion_app/utils/data_changer.dart';
import 'package:finance_gestion_app/utils/data_getters.dart';
import 'package:finance_gestion_app/utils/firestore_getters.dart';

double averageMonthSpending = 0;
double thisMonthSpending = 0;

double amountSaved = 0;
DateTime lastSaving = DateTime.now();

int percentageOfMonthlyBudget = 0;

Future<void> calculatePercentageOfMonthlyBudget() async {
  List<AppTransaction> allTransactions = await getAppTransactions(global.docId);

  double totalSpending = sumUpListValues(allTransactions);

  String monthString = global.selectedMonth.split(" ")[0];
  int month = getMonthInt(monthString);
  var thisMonthTransactions =
      await getTransactionFromMonth(month, allTransactions);
  thisMonthSpending = sumUpListValues(thisMonthTransactions);

  averageMonthSpending = (thisMonthSpending /
              ((totalSpending - thisMonthSpending) /
                  getMonthsCalendarTransactions(allTransactions).length));
}

double sumUpListValues(List<AppTransaction> transactions) {
  double result = 0;
  for (var element in transactions) {
    result += element.isRevenue ? 0 : element.value;
  }
  return result;
}
