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

abstract class ThemeFonts {
  static final primary = GoogleFonts.smoochSans().fontFamily;
  static final secondary = GoogleFonts.poppins().fontFamily;
}
