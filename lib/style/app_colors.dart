import 'package:flutter/material.dart';

class AppColors {
  static const backgoundColor = Color(0xFFEEE8F4);
  static const accentColor = Color(0xFFDAE9F6);
  static const accentColorDark = Color(0xFFFDFF9A);
  static const accentColorLight = Color(0xFF5B417B);

  static const earningLight = Color(0xFFE8F4E8);
  static const earning = Color(0xFF9FD19F);
  static const paymentLight = Color(0xFFF4EAE8);
  static const payment = Color(0xFFCA9A91);

  static const economy = Color(0xFFC6E4FF);
  static const available = Color(0xFFFFF4BB);
  static const classicGrey = Color(0xFFDCDCDC);

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
