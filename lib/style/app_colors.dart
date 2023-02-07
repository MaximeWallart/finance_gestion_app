import 'package:flutter/material.dart';

class AppColors {
  static const backgoundColor = Colors.white;
  static const accentColor = Color(0xFFDAE9F6);
  static const accentColorDark = Color(0xFFFDFF9A);
  static const accentColorLight = Color(0xFF5B417B);

  static const earning = Color(0xFF6FE16F);
  static const payment = Color(0xFFE8674F);

  static const economy = Color(0xFF80C3FF);
  static const available = Color(0xFFFFEC8A);
  static const classicGrey = Color(0xFFDCDCDC);

  static const List<Color> listCharColors = [
    Color(0xFF3366CC),
    Color(0xFFDC3912),
    Color(0xFFFF9900),
    Color(0xFF109618),
    Color(0xFF990099),
    Color(0xFF3B3EAC),
    Color(0xFF0099C6),
    Color(0xFFDD4477),
    Color(0xFF66AA00),
    Color(0xFFB82E2E),
    Color(0xFF316395),
    Color(0xFF994499),
    Color(0xFF22AA99),
    Color(0xFFAAAA11),
    Color(0xFF6633CC),
    Color(0xFFE67300),
    Color(0xFF8B0707),
    Color(0xFF329262),
    Color(0xFF5574A6),
    Color(0xFF3B3EAC)
  ];

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
