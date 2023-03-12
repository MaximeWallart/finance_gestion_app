import '../models/app_transaction.dart';

extension ToString on double {
  String toStringWithMaxPrecision({int? maxDigits}) {
    if (round() == this) {
      return round().toString();
    } else {
      if (maxDigits == null) {
        return toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "");
      } else {
        return toStringAsFixed(maxDigits)
            .replaceAll(RegExp(r'([.]*0)(?!.*\d)'), "");
      }
    }
  }
}

String formatNumber(int number) {
  if (number == null) {
    return '...';
  } //for those like me who don't use null-safety

  String result = '';
  int digit = 1; //to know when to add a space or not
  while (number > 0) {
    if (digit > 1 && digit % 3 == 1) {
      result = '${number % 10} $result';
    } else {
      result = (number % 10).toString() + result;
    }

    digit++;
    number = number ~/
        10; //divides by 10, in other words, shifts 1 digit to the right
  }
  return result;
}

extension CleanString on double {
  String removeExtraZeros() {
    if (toInt() == this) {
      return "${toInt()}";
    } else {
      return toString();
    }
  }
}

extension ChangeString on DateTime {
  String toStringWithWords() {
    if (DateTime.now()
            .difference(subtract(
                Duration(hours: hour, minutes: minute, seconds: second)))
            .inDays ==
        0) {
      return "Aujourd'hui";
    } else if (DateTime.now()
            .difference(subtract(
                Duration(hours: hour, minutes: minute, seconds: second)))
            .inDays ==
        1) {
      return "Hier";
    } else if (DateTime.now()
            .difference(subtract(
                Duration(hours: hour, minutes: minute, seconds: second)))
            .inDays ==
        2) {
      return "Avant-hier";
    } else if (DateTime.now()
            .difference(subtract(
                Duration(hours: hour, minutes: minute, seconds: second)))
            .inDays ==
        3) {
      return "Il y a 3 jours";
    } else if (DateTime.now()
            .difference(subtract(
                Duration(hours: hour, minutes: minute, seconds: second)))
            .inDays ==
        4) {
      return "Il y a 4 jours";
    } else if (DateTime.now()
            .difference(subtract(
                Duration(hours: hour, minutes: minute, seconds: second)))
            .inDays ==
        5) {
      return "Il y a 5 jours";
    } else if (DateTime.now()
            .difference(subtract(
                Duration(hours: hour, minutes: minute, seconds: second)))
            .inDays ==
        6) {
      return "Il y a 6 jours";
    } else {
      return "$day/$month";
    }
  }

  String getMonthString() {
    switch (month) {
      case 1:
        return "Janvier";
      case 2:
        return "Février";
      case 3:
        return "Mars";
      case 4:
        return "Avril";
      case 5:
        return "Mai";
      case 6:
        return "Juin";
      case 7:
        return "Juillet";
      case 8:
        return "Août";
      case 9:
        return "Septembre";
      case 10:
        return "Octobre";
      case 11:
        return "Novembre";
      case 12:
        return "Décembre";
      default:
        return "";
    }
  }
}

int getMonthInt(String month) {
  switch (month) {
    case "Janvier":
      return 1;
    case "Février":
      return 2;
    case "Mars":
      return 3;
    case "Avril":
      return 4;
    case "Mai":
      return 5;
    case "Juin":
      return 6;
    case "Juillet":
      return 7;
    case "Août":
      return 8;
    case "Septembre":
      return 9;
    case "Octobre":
      return 10;
    case "Novembre":
      return 11;
    case "Décembre":
      return 12;
    default:
      return 0;
  }
}

Map<String, double> getPieChartData(List<AppTransaction> transactions) {
  Map<String, double> result = {};
  int total = 0;
  for (var element in transactions) {
    if (result.containsKey(element.type)) {
      result[element.type] = result[element.type]! + 1;
    }
    result.putIfAbsent(element.type, () => 1);
    total++;
  }
  result.forEach((key, value) {
    result.update(key, (value) => (value / total) * 100);
  });
  return result;
}

List<String> getMonthsCalendarTransactions(List<AppTransaction> transaction) {
  List<String> result = [];
  for (var element in transaction) {
    String tmp = "${element.date.getMonthString()} ${element.date.year}";
    if (!result.contains(tmp)) {
      result.add(tmp);
    }
  }
  return result;
}
