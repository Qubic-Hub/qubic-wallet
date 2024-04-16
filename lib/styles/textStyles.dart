import 'package:flutter/material.dart';

import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

class TextStyles {
  static TextStyle pageTitle = const TextStyle(
    fontSize: ThemeFontSizes.pageTitle,
    fontWeight: FontWeight.bold,
    color: LightThemeColors.textTitle,
  );

  static TextStyle pageSubtitle = const TextStyle(
    fontSize: ThemeFontSizes.pageSubtitle,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.textTitle,
  );

  static TextStyle menuActive = const TextStyle(
    fontSize: ThemeFontSizes.tiny,
    fontWeight: FontWeight.w500,
  );

  static TextStyle menuInactive = const TextStyle(
    fontSize: ThemeFontSizes.tiny,
    fontWeight: FontWeight.w400,
  );

  static TextStyle transparentButtonText = const TextStyle(
    fontSize: ThemeFontSizes.large,
    fontWeight: FontWeight.w500,
    color: LightThemeColors.primary,
  );

  static TextStyle transparentButtonTextNormal = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.w500,
    color: LightThemeColors.primary,
  );

  static TextStyle transparentButtonTextSmall = const TextStyle(
    fontSize: ThemeFontSizes.small,
    fontWeight: FontWeight.w500,
    color: LightThemeColors.primary,
  );

  static TextStyle smallInfoText = const TextStyle(
    fontSize: ThemeFontSizes.small,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.textLightGrey,
  );

  static TextStyle primaryButtonText = const TextStyle(
    fontSize: ThemeFontSizes.large,
    fontWeight: FontWeight.w500,
    color: LightThemeColors.extraStrongBackground,
  );

  static TextStyle primaryButtonTextSmall = const TextStyle(
    fontSize: ThemeFontSizes.small,
    fontWeight: FontWeight.w500,
    color: LightThemeColors.extraStrongBackground,
  );

  static TextStyle primaryButtonTextNormal = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.w500,
    color: LightThemeColors.extraStrongBackground,
  );

  static TextStyle lightGreyText = const TextStyle(
      fontSize: ThemeFontSizes.normal,
      fontWeight: FontWeight.w400,
      color: LightThemeColors.textLightGrey);

  static TextStyle lightGreyTextSmall = const TextStyle(
      fontSize: ThemeFontSizes.small,
      fontWeight: FontWeight.w400,
      color: LightThemeColors.textLightGrey);

  static TextStyle lightGreyTextSmallBold = const TextStyle(
      fontSize: ThemeFontSizes.small,
      fontWeight: FontWeight.bold,
      color: LightThemeColors.textLightGrey);

  static TextStyle labelText = const TextStyle(
      fontSize: ThemeFontSizes.label,
      fontWeight: FontWeight.bold,
      color: LightThemeColors.textLabel);

  static TextStyle labelTextNormal = const TextStyle(
      fontSize: ThemeFontSizes.normal,
      fontWeight: FontWeight.bold,
      color: LightThemeColors.textLabel);

  static TextStyle labelTextSmall = const TextStyle(
      fontSize: ThemeFontSizes.small,
      fontWeight: FontWeight.bold,
      color: LightThemeColors.textLabel);

  static TextStyle labelTextError = const TextStyle(
      fontSize: ThemeFontSizes.label,
      fontWeight: FontWeight.normal,
      color: LightThemeColors.error);

  static TextStyle labelTextNormalError = const TextStyle(
      fontSize: ThemeFontSizes.normal,
      fontWeight: FontWeight.normal,
      color: LightThemeColors.error);

  static TextStyle whiteTickText = const TextStyle(
      fontSize: ThemeFontSizes.large,
      fontWeight: FontWeight.normal,
      color: LightThemeColors.onGradient);

  static TextStyle blackTickText = const TextStyle(
      fontSize: ThemeFontSizes.large,
      fontWeight: FontWeight.normal,
      color: LightThemeColors.primary);

  //Slivers
  static TextStyle sliverHeader = const TextStyle(
      fontSize: ThemeFontSizes.large,
      fontWeight: FontWeight.w500,
      color: LightThemeColors.onGradient);

  static TextStyle sliverBig = const TextStyle(
      fontSize: ThemeFontSizes.enormous,
      fontWeight: FontWeight.w500,
      color: LightThemeColors.onGradient);

  static TextStyle sliverCardPreLabel = const TextStyle(
      fontSize: ThemeFontSizes.extraLarge,
      fontWeight: FontWeight.bold,
      color: LightThemeColors.primary);

  static TextStyle sliverSmall = const TextStyle(
      fontSize: ThemeFontSizes.normal,
      fontWeight: FontWeight.w500,
      color: LightThemeColors.onGradient);

  static TextStyle sliverCurrencyLabel = const TextStyle(
      fontSize: ThemeFontSizes.tiny,
      fontWeight: FontWeight.w400,
      color: LightThemeColors.onGradient);
  static TextStyle sliverCurrencyLabelSmall = const TextStyle(
      fontSize: ThemeFontSizes.tiny,
      fontWeight: FontWeight.w400,
      color: LightThemeColors.onGradient);

  //Alerts
  static TextStyle alertHeader = const TextStyle(
    fontSize: ThemeFontSizes.extraLarge,
    fontWeight: FontWeight.bold,
    color: LightThemeColors.primary,
  );

  static TextStyle alertText = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.textLightGrey,
  );

  //Account cards
  static TextStyle accountName = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.bold,
    color: LightThemeColors.primary,
  );
  static TextStyle accountAmount = const TextStyle(
    fontSize: ThemeFontSizes.huge,
    fontWeight: FontWeight.bold,
    color: LightThemeColors.primary,
  );
  static TextStyle accountAmountLabel = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );
  static TextStyle accountPublicId = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.secondaryTypography,
  );

  //Asset cards
  static TextStyle assetSecondaryTextLabel = const TextStyle(
      fontSize: ThemeFontSizes.small,
      fontWeight: FontWeight.w400,
      color: LightThemeColors.secondaryTypography);
  static TextStyle assetSecondaryTextLabelValue = const TextStyle(
      fontSize: ThemeFontSizes.normal,
      fontWeight: FontWeight.w400,
      color: LightThemeColors.primary);

  //Input boxes
  static TextStyle inputBoxNormalStyle = const TextStyle(
    fontSize: ThemeFontSizes.large,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );

  static TextStyle inputBoxSmallStyle = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );

  static TextStyle textBold = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.bold,
    color: LightThemeColors.primary,
  );

  static TextStyle textNormal = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );

  static TextStyle textNormalOnPrimary = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.backkground,
  );

  static TextStyle textLarge = const TextStyle(
    fontSize: ThemeFontSizes.large,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );

  static TextStyle textExplorerTick = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );

  static TextStyle textTiny = const TextStyle(
    fontSize: ThemeFontSizes.tiny,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );

  static TextStyle textExtraLarge = const TextStyle(
    fontSize: ThemeFontSizes.extraLarge,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );

  static TextStyle textHugeBold = const TextStyle(
    fontSize: ThemeFontSizes.huge,
    fontWeight: FontWeight.bold,
    color: LightThemeColors.primary,
  );

  static TextStyle textEnormous = const TextStyle(
    fontSize: ThemeFontSizes.enormous,
    fontWeight: FontWeight.bold,
    color: LightThemeColors.primary,
  );

  static TextStyle textExtraLargeBold = const TextStyle(
    fontSize: ThemeFontSizes.extraLarge,
    fontWeight: FontWeight.bold,
    color: LightThemeColors.primary,
  );

  static TextStyle textSmall = const TextStyle(
    fontSize: ThemeFontSizes.small,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );

  static TextStyle secondaryTextNormal = const TextStyle(
    fontSize: ThemeFontSizes.normal,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.secondaryTypography,
  );

  static TextStyle secondaryTextLarge = const TextStyle(
    fontSize: ThemeFontSizes.large,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.secondaryTypography,
  );

  static TextStyle secondaryTextSmall = const TextStyle(
    fontSize: ThemeFontSizes.small,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.secondaryTypography,
  );

  static TextStyle qubicAmount = const TextStyle(
    fontSize: ThemeFontSizes.huge,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );
  static TextStyle qubicAmountLabel = const TextStyle(
    fontSize: ThemeFontSizes.small,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary,
  );

  static TextStyle qubicAmountLight = TextStyle(
    fontSize: ThemeFontSizes.huge,
    fontWeight: FontWeight.w400,
    color: LightThemeColors.primary.withOpacity(0.1),
  );
}
