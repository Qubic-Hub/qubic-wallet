import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qubic_wallet/di.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/globals.dart';
import 'package:qubic_wallet/platform_specific_initialization.dart';
import 'package:qubic_wallet/resources/qubic_cmd.dart';
import 'package:qubic_wallet/routes.dart';
import 'package:qubic_wallet/stores/qubic_hub_store.dart';
import 'package:qubic_wallet/stores/settings_store.dart';

Future<void> main() async {
  DArgon2Flutter.init(); //Initialize DArgon 2
  setupDI(); //Dependency injection

  WidgetsFlutterBinding.ensureInitialized();

  await PlatformSpecificInitilization().run();

  getIt.get<SettingsStore>().loadSettings();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  getIt.get<QubicHubStore>().setVersion(packageInfo.version);
  getIt.get<QubicHubStore>().setBuildNumer(packageInfo.buildNumber);

  getIt.get<QubicCmd>().initialize();

  runApp(const WalletApp());
}

class WalletApp extends StatelessWidget {
  const WalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Qubic Wallet',
      routerConfig: appRouter,
      scaffoldMessengerKey: snackbarKey,

      /// Theme config for FlexColorScheme version 7.3.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
      theme: FlexThemeData.dark(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          primary: LightThemeColors.primary,
          onPrimary: LightThemeColors.surface,
          secondary: LightThemeColors.primary,
          onSecondary: LightThemeColors.surface,
          error: LightThemeColors.error,
          onError: LightThemeColors.extraStrongBackground,
          background: LightThemeColors.backkground,
          onBackground: LightThemeColors.primary,
          surface: LightThemeColors.surface,
          onSurface: LightThemeColors.primary,
          seedColor: LightThemeColors.panelBackground,
          surfaceTint: LightThemeColors.backkground,
        ),

        useMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.poppins().fontFamily,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 2,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),
      // darkTheme: FlexThemeData.dark(
      //   colorScheme: ColorScheme.fromSeed(
      //     brightness: Brightness.light,
      //     primary: LightThemeColors.primary,
      //     onPrimary: LightThemeColors.surface,
      //     secondary: LightThemeColors.primary,
      //     onSecondary: LightThemeColors.surface,
      //     error: LightThemeColors.error,
      //     onError: LightThemeColors.extraStrongBackground,
      //     background: LightThemeColors.panelBackground,
      //     onBackground: LightThemeColors.primary,
      //     surface: LightThemeColors.surface,
      //     onSurface: LightThemeColors.primary,
      //     seedColor: LightThemeColors.panelBackground,
      //     surfaceTint: LightThemeColors.backkground,
      //   ),

      //   useMaterial3: true,
      //   // To use the Playground font, add GoogleFonts package and uncomment
      //   fontFamily: GoogleFonts.poppins().fontFamily,

      //   surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      //   blendLevel: 2,
      //   visualDensity: FlexColorScheme.comfortablePlatformDensity,

      //   // To use the Playground font, add GoogleFonts package and uncomment
      // ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
    );
  }
}
