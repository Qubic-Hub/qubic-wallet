import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:intl/intl.dart';

class CurrencyLabel extends StatelessWidget {
  final String currencyName;
  final bool isInHeader;
  late final TextStyle style;
  CurrencyLabel(
      {super.key,
      required this.currencyName,
      required this.isInHeader,
      style}) {
    this.style = style ?? TextStyles.sliverCurrencyLabel;
  }

  @override
  Widget build(BuildContext context) {
    if (isInHeader) {
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: LightThemeColors.pillColor),
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 2),
          child: Text(currencyName, style: style));
    } else {
      return Container(
          padding: EdgeInsets.only(left: 6, right: 6),
          child: Text(currencyName, style: style));
    }

    //return Text(numberFormat.format(amount!));
  }
}
