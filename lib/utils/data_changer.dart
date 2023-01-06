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

extension changeString on DateTime {
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
}
