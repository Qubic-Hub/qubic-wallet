import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

abstract class ThemeInputDecorations {
  static InputDecoration dropdownBox = InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 20),
    hoverColor: LightThemeColors.primary.withOpacity(0.01),
    errorStyle: const TextStyle(
        color: LightThemeColors.error,
        fontSize: ThemeFontSizes.small,
        fontWeight: FontWeight.normal),
    enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.error.withOpacity(0.5))),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.error.withOpacity(0.5))),
    disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    filled: true,
    hintStyle: TextStyle(
        color: LightThemeColors.primary.withOpacity(0.4),
        fontSize: ThemeFontSizes.label),
    fillColor: Colors.transparent,
  );

  static InputDecoration bigInputbox = InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 20),
    hoverColor: LightThemeColors.primary.withOpacity(0.01),
    errorStyle: const TextStyle(
        color: LightThemeColors.error,
        fontSize: ThemeFontSizes.small,
        fontWeight: FontWeight.normal),
    enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.error.withOpacity(0.5))),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.error.withOpacity(0.5))),
    disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    filled: true,
    hintStyle: TextStyle(
        color: LightThemeColors.primary.withOpacity(0.4),
        fontSize: ThemeFontSizes.label),
    fillColor: LightThemeColors.extraStrongBackground,
  );

  static InputDecoration normalInputbox = InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
    hoverColor: LightThemeColors.primary.withOpacity(0.01),
    errorStyle: const TextStyle(
        color: LightThemeColors.error,
        fontSize: ThemeFontSizes.small,
        fontWeight: FontWeight.normal),
    enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(26)),
        borderSide: BorderSide(color: LightThemeColors.error.withOpacity(0.5))),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(26)),
        borderSide: BorderSide(color: LightThemeColors.error.withOpacity(0.5))),
    disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    filled: true,
    hintStyle: TextStyle(
        color: LightThemeColors.primary.withOpacity(0.4),
        fontSize: ThemeFontSizes.label),
    fillColor: LightThemeColors.extraStrongBackground,
  );

  static InputDecoration normalMultiLineInputbox = InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
    hoverColor: LightThemeColors.primary.withOpacity(0.01),
    errorStyle: const TextStyle(
        color: LightThemeColors.error,
        fontSize: ThemeFontSizes.small,
        fontWeight: FontWeight.normal),
    enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: LightThemeColors.error.withOpacity(0.5))),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: LightThemeColors.error.withOpacity(0.5))),
    disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: LightThemeColors.inputBorderColor)),
    filled: true,
    hintStyle: TextStyle(
        color: LightThemeColors.primary.withOpacity(0.4),
        fontSize: ThemeFontSizes.label),
    fillColor: LightThemeColors.extraStrongBackground,
  );
}
