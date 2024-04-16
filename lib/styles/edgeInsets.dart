import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

abstract class ThemeEdgeInsets {
  static EdgeInsets pageInsets = const EdgeInsets.fromLTRB(
      ThemePaddings.normalPadding,
      ThemePaddings.normalPadding,
      ThemePaddings.normalPadding,
      ThemePaddings.bigPadding);
  static EdgeInsets bottomSheetInsets = const EdgeInsets.fromLTRB(
      ThemePaddings.bigPadding,
      ThemePaddings.normalPadding,
      ThemePaddings.bigPadding,
      ThemePaddings.normalPadding);
}
