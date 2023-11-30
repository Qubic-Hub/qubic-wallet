import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:skeleton_text/skeleton_text.dart';

class QubicAmount extends StatelessWidget {
  final int? amount;
  const QubicAmount({super.key, required this.amount});

  Widget getText(BuildContext context, String text, bool opaque) {
    return Text(text,
        style: opaque
            ? Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: ThemeFonts.primary)
            : Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: ThemeFonts.primary,
                color: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.color!
                    .withOpacity(0.1)));
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

    if (numberized == "0") {
      numberList.add(Text("000",
          style: isZeroWithValue
              ? Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontFamily: ThemeFonts.primary,
                  )
              : Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: ThemeFonts.primary,
                  color: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.color!
                      .withOpacity(0.1))));
    } else {
      var preNumber = 3 - numberized.length;
      for (int i = 0; i < preNumber; i++) {
        numberList.add(Text("0",
            style: isZeroWithValue
                ? Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: ThemeFonts.primary)
                : Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: ThemeFonts.primary,
                    color: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.color!
                        .withOpacity(0.1))));
      }
      numberList.add(Text(numberized,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontFamily: ThemeFonts.primary)));
    }
    if (hasComma) {
      numberList.add(Text(",",
          style: isZeroWithValue
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: ThemeFonts.primary,
                  color: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.color!
                      .withOpacity(0.5))
              : Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: ThemeFonts.primary,
                  color: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.color!
                      .withOpacity(0.1))));
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

      numbers.add(Text(amount.toString(),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: ThemeFonts.primary,
              )));
      numbers.add(Text(" \$QUBIC",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontFamily: ThemeFonts.primary)));
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

    List<Widget> numbers = [];
    numbers.addAll(
        getNumber(context, trillionsString, true, amount! > 1000000000000));
    numbers
        .addAll(getNumber(context, billionsString, true, amount! > 1000000000));
    numbers.addAll(getNumber(context, millionsString, true, amount! > 1000000));
    numbers.addAll(getNumber(context, thousandsString, true, amount! > 1000));
    if (amount! >= 1000) {
      numbers.addAll(getNumber(context, unitsString, false, amount! > 0));
    } else {
      numbers.addAll(getUptoThousands(context, units));
    }
    numbers.add(Text(" \$QUBIC",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontFamily: ThemeFonts.primary)));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: numbers);
  }
}
