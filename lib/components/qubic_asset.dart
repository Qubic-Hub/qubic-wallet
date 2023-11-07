import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:skeleton_text/skeleton_text.dart';

class QubicAsset extends StatelessWidget {
  final int? numberOfShares;
  final String? assetName;
  final TextStyle? style;
  const QubicAsset(
      {super.key,
      required this.numberOfShares,
      required this.assetName,
      this.style});

  TextStyle getStyle(BuildContext context, bool opaque) {
    TextStyle opaqueStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontFamily: ThemeFonts.primary);
    TextStyle transparentStyle = opaqueStyle.copyWith(
        color:
            Theme.of(context).textTheme.titleMedium?.color!.withOpacity(0.1));
    TextStyle defaultStyle = opaque ? opaqueStyle : transparentStyle;

    TextStyle? transparentOverridenStyle = style == null
        ? null
        : style!.copyWith(
            color: style!.color!.withOpacity(0.1),
          );

    TextStyle? overridenStyle = style == null
        ? null
        : opaque
            ? style
            : transparentOverridenStyle!;

    return overridenStyle ?? defaultStyle;
  }

  Widget getText(BuildContext context, String text, bool opaque) {
    return Text(text, style: getStyle(context, opaque));
  }

  @override
  Widget build(BuildContext context) {
    if (numberOfShares == null) {
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
    List<Widget> numbers = [];
    String? zeros = numberOfShares! > 100
        ? null
        : numberOfShares! > 10
            ? "0"
            : numberOfShares! > 0
                ? "00"
                : "000";
    if (zeros != null) {
      numbers.add(getText(context, zeros, false));
    }
    numbers.add(getText(context, numberOfShares.toString(), true));
    numbers.add(Text(" $assetName SHARE${numberOfShares! > 1 ? "S" : ""}",
        style: getStyle(context, true)));
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: numbers);
  }
}
