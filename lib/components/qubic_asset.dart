import 'package:flutter/material.dart';
import 'package:qubic_wallet/dtos/qubic_asset_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/smart_contracts/sc_info.dart';
import 'package:skeleton_text/skeleton_text.dart';

class QubicAsset extends StatelessWidget {
  final QubicAssetDto? asset;

  final TextStyle? style;
  const QubicAsset({super.key, this.asset, this.style});

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

  Widget getDescriptor(BuildContext context) {
    if (asset == null) {
      return Container();
    }
    bool isToken = asset!.contractIndex == QubicSCID.qX.contractIndex &&
        asset!.contractName != "QX";
    String text = isToken ? " Token" : " Share";
    int num = asset!.ownedAmount ?? asset!.possessedAmount ?? 0;
    if (num != 1) {
      text += "s";
    }
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontFamily: ThemeFonts.primary));
  }

  @override
  Widget build(BuildContext context) {
    if (asset == null) {
      return Container();
    }
    if ((asset!.ownedAmount == null) && (asset!.possessedAmount == null)) {
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
    int numberOfShares = asset!.ownedAmount ?? asset!.possessedAmount ?? 0;
    String? zeros = numberOfShares > 100
        ? null
        : numberOfShares >= 10
            ? "0"
            : numberOfShares > 0
                ? "00"
                : "000";
    if (zeros != null) {
      numbers.add(getText(context, zeros, false));
    }
    numbers.add(getText(context, numberOfShares.toString(), true));
    numbers.add(
        Text(" ${asset!.assetName}", // Asset${numberOfShares! > 1 ? "S" : ""}",
            style: getStyle(context, true)));
    numbers.add(getDescriptor(context));
    return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.end,
        children: numbers);
  }
}
