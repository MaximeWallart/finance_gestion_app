import 'package:finance_gestion_app/style/app_colors.dart';
import 'package:flutter/material.dart';

class InformationsWidget extends StatelessWidget {
  const InformationsWidget(
      {super.key, this.backgroundColor = AppColors.classicGrey, required this.child});

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: backgroundColor),
      child: Center(child: child),
    );
  }
}

class InformationTextWidget extends StatelessWidget {
  const InformationTextWidget(
      {super.key, required this.number, required this.subtext});

  final Widget number;
  final String subtext;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      number,
      Text(
        subtext,
        style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.33),
            fontSize: MediaQuery.of(context).size.width * 0.05),
      )
    ]);
  }
}
