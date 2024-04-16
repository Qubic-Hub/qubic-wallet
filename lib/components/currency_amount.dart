import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class CurrencyAmount extends StatelessWidget {
  final double? amount;
  final TextStyle textStyle;
  late final TextStyle transparentTextStyle01;
  late final TextStyle transparentTextStyle05;
  CurrencyAmount({super.key, required this.amount, required this.textStyle}) {
    transparentTextStyle01 =
        textStyle.copyWith(color: textStyle.color!.withOpacity(0.1));
    transparentTextStyle05 =
        textStyle.copyWith(color: textStyle.color!.withOpacity(0.5));
  }

  Widget getText(BuildContext context, String text, bool opaque) {
    return Text(text, style: opaque ? textStyle : transparentTextStyle01);
  }

  List<Widget> getUptoThousands(BuildContext context, int units) {
    if (units >= 100) {
      return [getText(context, units.toString(), true)];
    }

    if (units >= 10) {
      return [
        getText(context, "0", false),
        getText(context, units.toString(), true)
      ];
    }
    return [
      getText(context, "00", false),
      getText(context, units.toString(), true)
    ];
  }

  List<Widget> getNumber(BuildContext context, String numberized, bool hasComma,
      bool isZeroWithValue) {
    List<Widget> numberList = [];

    if (numberized == "0" && isZeroWithValue) {
      numberList.add(Text("000",
          style: isZeroWithValue ? textStyle : transparentTextStyle01));
    } else {
      numberList.add(Text(numberized, style: textStyle));
    }
    if (hasComma) {
      numberList.add(Text(",", style: transparentTextStyle05));
    }
    return numberList;
  }

  @override
  Widget build(BuildContext context) {
    if (amount == null) {
      List<Widget> output = [];
      output.add(SkeletonAnimation(
          borderRadius: BorderRadius.circular(2.0),
          shimmerColor:
              Theme.of(context).textTheme.titleMedium!.color!.withOpacity(0.3),
          shimmerDuration: 3000,
          curve: Curves.easeInOutCirc,
          child: Container(
            height: 18,
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.color!
                    .withOpacity(0.1)),
          )));

      return Row(mainAxisAlignment: MainAxisAlignment.center, children: output);
    }

    //Leave styling for ultra big
    if (amount! > 1000000000000) {
      List<Widget> numbers = [];

      numbers.add(Text(amount.toString(), style: textStyle));
      numbers.add(Text(" \$USD", style: textStyle));
      return Row(
          mainAxisAlignment: MainAxisAlignment.center, children: numbers);
    }

    final int trillions = (amount! / 1000000000000).floor();
    final int billions =
        ((amount! - trillions * 1000000000000) / 1000000000).floor();
    final int millions =
        ((amount! - trillions * 1000000000000 - billions * 1000000000) /
                1000000)
            .floor();
    final int thousands = ((amount! -
                trillions * 1000000000000 -
                billions * 1000000000 -
                millions * 1000000) /
            1000)
        .floor();
    final int units = (amount! -
            trillions * 1000000000000 -
            billions * 1000000000 -
            millions * 1000000 -
            thousands * 1000)
        .floor();

    final trillionsString = trillions.toString();
    final billionsString = billions.toString();
    final millionsString = millions.toString();
    final thousandsString = thousands.toString();
    final unitsString = units.toString();

    final hasTrillions = amount! >= 1000000000000;
    final hasBillions = amount! >= 1000000000;
    final hasMillions = amount! >= 1000000;
    final hasThousands = amount! >= 1000;
    final hasunits = amount! >= 1;

    List<Widget> numbers = [];
    if (hasTrillions) {
      numbers.addAll(
          getNumber(context, trillionsString, true, amount! > 1000000000000));
    }
    if (hasBillions) {
      numbers.addAll(getNumber(context, billionsString, true, hasTrillions));
    }
    if (hasMillions) {
      numbers.addAll(getNumber(context, millionsString, true, hasBillions));
    }
    if (hasThousands) {
      numbers.addAll(getNumber(context, thousandsString, true, hasMillions));
    }
    if (amount! >= 1000) {
      numbers.addAll(getNumber(context, unitsString, false, hasThousands));
    } else {
      numbers.addAll(getUptoThousands(context, units));
    }
    numbers.add(Text(" USD", style: textStyle));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: numbers);
  }
}
