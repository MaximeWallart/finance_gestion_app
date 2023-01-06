import 'package:flutter/material.dart';

class AppColors {
  static const backgoundColor = Color(0xFFDAE9F6);
  static const accentColor = Color(0xFFDAE9F6);
  static const accentColorDark = Color(0xFFFDFF9A);
  static const accentColorLight = Color(0xFF5B417B);

  static const earningLight = Color(0xFFb9f6ca);
  static const earningDark = Color(0xFF00c853);
  static const paymentLight = Color(0xFFffd180);
  static const paymentDark = Color(0xFFff6d00);

  static Color amountVariantColor(double value, bool isRevenue) {
    int max = 150;
    if (isRevenue == false) {
      int gVariable = (187 * (1 - (value / max).clamp(0, 1))).toInt();
      int bVariable = (63 * (1 - (value / max).clamp(0, 1))).toInt();
      return Color.fromARGB(255, 255, gVariable, bVariable);
    } else {
      int rVariable = (81 * (value / max).clamp(0, 1)).toInt();
      int gVariable = (157 - 60 * (value / max).clamp(0, 1)).toInt();
      int bVariable = (68 - 55 * (value / max).clamp(0, 1)).toInt();
      return Color.fromARGB(255, rVariable, gVariable, bVariable);
    }
  }

  static Color contrastTextColor(Color backgoundColor, Color textColor) {
    double colorDifference =
        backgoundColor.computeLuminance() - textColor.computeLuminance();
    if (colorDifference.abs() < 0.2) {
      textColor =
          textColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    }
    return textColor;
  }
}
