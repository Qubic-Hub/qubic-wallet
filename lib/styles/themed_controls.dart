import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/styles/buttonStyles.dart';

import 'package:qubic_wallet/styles/textStyles.dart';

class ThemedControls {
  static Widget card({required Widget child}) {
    return Card(
        color: LightThemeColors.cardBackground,
        elevation: 0,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(
                  ThemePaddings.normalPadding,
                  ThemePaddings.normalPadding,
                  ThemePaddings.normalPadding,
                  ThemePaddings.normalPadding),
              child: child)
        ]));
  }

  static Widget cardWithBg({required Widget child, required Color bgColor}) {
    return Card(
        surfaceTintColor: bgColor,
        elevation: 0,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(
                  ThemePaddings.normalPadding,
                  ThemePaddings.normalPadding,
                  ThemePaddings.normalPadding,
                  ThemePaddings.normalPadding),
              child: child)
        ]));
  }

  /// A primary button with child widgets
  static Widget primaryButtonBigWithChild(
      {required void Function()? onPressed,
      required Widget child,
      bool? enabled}) {
    return FilledButton(
      style: ButtonStyles.primaryButtonBig,
      onPressed: onPressed,
      child: child,
    );
  }

  // A transparent button with child widgets
  static Widget transparentButtonBigWithChild(
      {required void Function()? onPressed, required Widget child}) {
    return TextButton(
      style: ButtonStyles.textButtonBig,
      onPressed: onPressed,
      child: child,
    );
  }

  /// Shows primary button
  static Widget transparentButtonBigText(
      {required void Function()? onPressed, required String text}) {
    return TextButton(
      style: ButtonStyles.textButtonBig,
      onPressed: onPressed,
      child: Text(text, style: TextStyles.transparentButtonText),
    );
  }

  // A container which inverts its children colors
  static Widget invertedColors({required Widget child}) {
    return ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          -1.0, 0.0, 0.0, 0.0, 255.0, //
          0.0, -1.0, 0.0, 0.0, 255.0, //
          0.0, 0.0, -1.0, 0.0, 255.0, //
          0.0, 0.0, 0.0, 1.0, 0.0, //
        ]),
        child: child);
  }

  static Widget spacerHorizontalNormal() {
    return const SizedBox(width: ThemePaddings.normalPadding);
  }

  static Widget spacerHorizontalBig() {
    return const SizedBox(width: ThemePaddings.bigPadding);
  }

  static Widget spacerHorizontalSmall() {
    return const SizedBox(width: ThemePaddings.smallPadding);
  }

  static Widget spacerHorizontalMini() {
    return const SizedBox(width: ThemePaddings.miniPadding);
  }

  static Widget spacerHorizontalHuge() {
    return const SizedBox(width: ThemePaddings.hugePadding);
  }

  static Widget spacerVerticalNormal() {
    return const SizedBox(height: ThemePaddings.normalPadding);
  }

  static Widget spacerVerticalBig() {
    return const SizedBox(height: ThemePaddings.bigPadding);
  }

  static Widget spacerVerticalHuge() {
    return const SizedBox(height: ThemePaddings.hugePadding);
  }

  static Widget spacerVerticalSmall() {
    return const SizedBox(height: ThemePaddings.smallPadding);
  }

  static Widget spacerVerticalMini() {
    return const SizedBox(height: ThemePaddings.miniPadding);
  }

  static Widget pageHeader({
    required String headerText,
    String? subheaderText,
    bool subheaderPill = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headerText, style: TextStyles.pageTitle),
        if (subheaderText != null) ThemedControls.spacerVerticalSmall(),
        if ((subheaderText != null) && (!subheaderPill))
          Text(subheaderText, style: TextStyles.pageSubtitle),
        if ((subheaderText != null) && (subheaderPill))
          Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment(-1.0, 0.0),
                    end: Alignment(1.0, 0.0),
                    transform: GradientRotation(2.19911),
                    stops: [
                      0.03,
                      1,
                    ],
                    colors: [
                      LightThemeColors.gradient1,
                      LightThemeColors.gradient2
                    ]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: ThemePaddings.normalPadding,
                      vertical: ThemePaddings.smallPadding),
                  child: Text(subheaderText,
                      style: TextStyles.textNormalOnPrimary))),
        ThemedControls.spacerVerticalNormal()
      ],
    );
  }

  static Widget themedButton(
      {required void Function()? onPressed,
      String? label,
      Widget? icon,
      required TextStyle textStyle,
      required ButtonStyle buttonStyle}) {
    assert(icon != null || label != null);
    return TextButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? Container(),
          icon != null && label != null
              ? const SizedBox(width: ThemePaddings.smallPadding)
              : Container(),
          label != null ? Text(label, style: textStyle) : Container(),
        ],
      ),
    );
  }

  static Widget transaparentButton(
      {required void Function()? onPressed,
      required String text,
      Widget? icon}) {
    return themedButton(
        onPressed: onPressed,
        label: text,
        icon: icon,
        textStyle: TextStyles.transparentButtonTextNormal,
        buttonStyle: ButtonStyles.textButtonBig);
  }

  static Widget transparentButtonSmall(
      {required void Function()? onPressed,
      required String text,
      Widget? icon}) {
    return themedButton(
        onPressed: onPressed,
        label: text,
        icon: icon,
        textStyle: TextStyles.transparentButtonTextSmall,
        buttonStyle: ButtonStyles.textButtonBig);
  }

  /// A primary button with bigger text
  static Widget primaryButtonBig(
      {required void Function()? onPressed,
      required String text,
      Widget? icon}) {
    return themedButton(
        onPressed: onPressed,
        label: text,
        icon: icon,
        textStyle: TextStyles.primaryButtonText,
        buttonStyle: ButtonStyles.primaryButtonBig);
  }

  static Widget primaryButtonSmall(
      {required void Function()? onPressed,
      required String text,
      Widget? icon}) {
    return themedButton(
        onPressed: onPressed,
        label: text,
        icon: icon,
        textStyle: TextStyles.primaryButtonTextSmall,
        buttonStyle: ButtonStyles.primaryButtonBig);
  }

  //A primary button with normal text
  static Widget primaryButtonNormal(
      {required void Function()? onPressed,
      required String text,
      Widget? icon}) {
    return themedButton(
        onPressed: onPressed,
        label: text,
        icon: icon,
        textStyle: TextStyles.primaryButtonTextNormal,
        buttonStyle: ButtonStyles.primaryButtonBig);
  }

  /// A primary button with bigger text
  static Widget transparentButtonBig(
      {required void Function()? onPressed,
      required String text,
      Widget? icon}) {
    return themedButton(
        onPressed: onPressed,
        label: text,
        icon: icon,
        textStyle: TextStyles.transparentButtonText,
        buttonStyle: ButtonStyles.textButtonBig);
  }

  //A primary button with normal text
  static Widget transparentButtonNormal(
      {required void Function()? onPressed,
      required String text,
      Widget? icon}) {
    return themedButton(
        onPressed: onPressed,
        label: text,
        icon: icon,
        textStyle: TextStyles.transparentButtonTextNormal,
        buttonStyle: ButtonStyles.textButtonBig);
  }

  /// Shows an error label
  static Widget errorLabel(String text) {
    return Text(text, style: TextStyles.labelTextError);
  }

  static Widget inputboxlikeLabel({required Widget child}) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
            ThemePaddings.normalPadding,
            ThemePaddings.smallPadding + 2,
            ThemePaddings.normalPadding,
            ThemePaddings.smallPadding + 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: LightThemeColors.cardBackground,
          border:
              Border.all(color: LightThemeColors.inputBorderColor, width: 0.8),
        ),
        child: child);
  }

  static Widget dropdown<ReturnType>(
      {required void Function(ReturnType? value) onChanged,
      required List<DropdownMenuItem<ReturnType>>? items,
      required dynamic value}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
              color: LightThemeColors.inputBorderColor,
              style: BorderStyle.solid,
              width: 0.8),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: DropdownButton<ReturnType>(
                underline: const SizedBox.shrink(),
                value: value,
                elevation: 0,
                dropdownColor: LightThemeColors.strongBackground,
                focusColor: LightThemeColors.strongBackground,
                padding: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding,
                    10, ThemePaddings.normalPadding, 12),
                isDense: true,
                style: TextStyles.inputBoxNormalStyle,
                borderRadius: BorderRadius.circular(8.0),
                isExpanded: true,
                onChanged: onChanged,
                items: items)));
  }
}
