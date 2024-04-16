import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

abstract class ThemePaddings {
  /// 4px
  static const miniPadding = 4.0;

  /// 8px
  static const smallPadding = 8.0;

  /// 16px
  static const normalPadding = 16.0;

  /// 24px
  static const bigPadding = 24.0;

  /// 32px
  static const hugePadding = 32.0;
}

class LightThemeColors {
  static const shouldInvertIcon = true;
  static const primary = Color(0xFFDDDDDD);
  static const surface = Color(0xFF222229);
  static const backkground = Color(0xFF101820);
  static const successIncoming = Color(0xFF179C6C);
  static const pending = Color(0xFFF3C05E);
  static const error = Color(0xFFE67070);

  static const menuBg = Color(0xFF192531);

  static const buttonPrimary = Color(0xFF1bdef5);

  static const color1 = Color(0xFF000000);
  static const color2 = Color(0xFF454545);
  static const color3 = Color(0xFF5E5E5E);
  static const color4 = Color(0xFF787878);
  static const color5 = Color(0xFF919191);
  static const color6 = Color(0xFFABABAB);
  static const color7 = Color(0xFFCCCCCC);
  static const color8 = Color(0xFFE6E6E6);
  static const color9 = Color(0xFFD1D1D1);

  static const disabledStateBg = color2;

  static const inputFieldBg = color3;

  static const secondaryTypography = color6;
  static const buttonTap = color8;

  static const extraStrongBackground = menuBg;
  static const strongBackground = Color(0xFF060606);

  static const inputBorderColor = color3;

//  static const gradient1 = Color(0xFF0F27FF);
  static const gradient1 = buttonPrimary;
  static const gradient2 = Color(0xFF045d68);
//  static const gradient2 = Color(0xFFBF0FFF);
  static const onGradient = Color(0xFFFFFFFF);
  static const pillColor = Color(0x40FFFFFF);

  static const textTitle = primary;
  static const textLabel = primary;
  static const textLightGrey = color6;
  static const textInputPlaceholder = Color.fromARGB(1, 116, 116, 116);
  static const borderInput = Color.fromARGB(1, 204, 204, 204);

  static const textError = error;

  static const buttonBackground = buttonPrimary;
  static const buttonBackgroundDisabled = Color(0x33DDDDDD);
  static const cardBackground = menuBg;
  static const navbarBackground = menuBg;
  static const panelBackground = Color.fromARGB(255, 23, 23, 23);

  static const menuActive = primary;
  static const menuInactive = Color(0x99131313);
}

class xLightThemeColors {
  static const shouldInvertIcon = false;

  static const primary = Color(0xFF131313);
  static const surface = Color(0xFFFFFFFF);
  static const backkground = Color(0xFFF1F3F4);
  static const successIncoming = Color(0xFF179C6C);
  static const pending = Color(0xFFEAB754);
  static const error = Color(0xFFFF007B);

  static const color1 = Color(0xFFF5F5F5);
  static const color2 = Color(0xFFE6E6E6);
  static const color3 = Color(0xFFCCCCCC);
  static const color4 = Color(0xFFABABAB);
  static const color5 = Color(0xFF919191);
  static const color6 = Color(0xFF747474);
  static const color7 = Color(0xFF5E5E5E);
  static const color8 = Color(0xFF454545);
  static const color9 = Color(0xFF2E2E2E);

  static const disabledStateBg = color2;

  static const inputFieldBg = color3;

  static const secondaryTypography = color6;
  static const buttonTap = color8;

  static const extraStrongBackground = surface;
  static const strongBackground = Color(0xFFF6F6F6);

  static const inputBorderColor = color3;

  static const gradient1 = Color(0xFF0F27FF);
  static const gradient2 = Color(0xFFBF0FFF);
  static const onGradient = Color(0xFFFFFFFF);
  static const pillColor = Color(0x40FFFFFF);

  static const textTitle = primary;
  static const textLabel = primary;
  static const textLightGrey = color6;
  static const textInputPlaceholder = Color.fromARGB(1, 116, 116, 116);
  static const borderInput = Color.fromARGB(1, 204, 204, 204);

  static const textError = error;

  static const buttonBackground = primary;
  static const buttonBackgroundDisabled = Color(0x33131313);
  static const cardBackground = extraStrongBackground;
  static const navbarBackground = extraStrongBackground;
  static const panelBackground = Color.fromARGB(255, 243, 243, 243);

  static const menuActive = primary;
  static const menuInactive = Color(0x99131313);
}

abstract class ThemeFontSizes {
  ///10
  static const tiny = 10.0;

  ///12
  static const small = 12.0;

  ///14
  static const normal = small + 2;

  ///16
  static const large = normal + 2;

  ///18
  static const extraLarge = large + 2;

  ///24
  static const huge = extraLarge + 8;

  ///36
  static const enormous = huge + 8;

  static const label = large;
  static const input = normal;
  static const sectionTitle = extraLarge;
  static const pageTitle = huge;
  static const pageSubtitle = large;
}

abstract class ThemeFonts {
  static final primary = GoogleFonts.spaceGrotesk().fontFamily;
  static final secondary = GoogleFonts.spaceGrotesk().fontFamily;
}
