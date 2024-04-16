import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/styles/textStyles.dart';

abstract class ButtonStyles {
  static ButtonStyle primaryButtonBig = ButtonStyle(
      overlayColor: MaterialStatePropertyAll<Color>(
          LightThemeColors.extraStrongBackground.withOpacity(0.1)),
      backgroundColor: const MaterialStatePropertyAll<Color>(
          LightThemeColors.buttonBackground),
      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))));

  static ButtonStyle textButtonBig = ButtonStyle(
      overlayColor: MaterialStatePropertyAll<Color>(
          LightThemeColors.buttonBackground.withOpacity(0.1)),
      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))));
}
