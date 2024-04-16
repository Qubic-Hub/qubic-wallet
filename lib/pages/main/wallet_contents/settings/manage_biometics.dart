import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qubic_wallet/components/gradient_foreground.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/re_auth_dialog.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/settings_store.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:qubic_wallet/styles/edgeInsets.dart';
import 'package:qubic_wallet/styles/inputDecorations.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
import 'package:qubic_wallet/timed_controller.dart';

class ManageBiometrics extends StatefulWidget {
  const ManageBiometrics({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageBiometricsState createState() => _ManageBiometricsState();
}

class _ManageBiometricsState extends State<ManageBiometrics> {
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final LocalAuthentication auth = LocalAuthentication();
  final SettingsStore settingsStore = getIt<SettingsStore>();

  bool? canCheckBiometrics; //If true, the device has biometrics
  List<BiometricType>? availableBiometrics; //Is empty, no biometric is enrolled
  bool? canUseBiometrics = false;

  bool enabled = false;
  @override
  void initState() {
    super.initState();
    auth.canCheckBiometrics.then((value) {
      setState(() {
        canCheckBiometrics = value;
      });
      if (!value) {
        setState(() {
          canUseBiometrics = false;
        });
        return;
      }
      auth.getAvailableBiometrics().then((value) {
        setState(() {
          availableBiometrics = value;
          canUseBiometrics = value.isNotEmpty;
          enabled = settingsStore.settings.biometricEnabled;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget loadingIndicator() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          const SizedBox(height: ThemePaddings.hugePadding),
          const CircularProgressIndicator(),
          const SizedBox(height: ThemePaddings.normalPadding),
          Text("Loading...",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontFamily: ThemeFonts.primary))
        ]));
  }

  Widget biometricsControls() {
    var theme = SettingsThemeData(
      settingsSectionBackground: LightThemeColors.cardBackground,
      //Theme.of(context).cardTheme.color,
      settingsListBackground: LightThemeColors.backkground,
      dividerColor: Colors.transparent,
      titleTextColor: Theme.of(context).colorScheme.onBackground,
    );
    return Column(children: [
      const SizedBox(height: ThemePaddings.hugePadding),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GradientForeground(
            child: Icon(Icons.fingerprint,
                size: 100, color: Theme.of(context).colorScheme.primary)),
      ]),
      const SizedBox(height: ThemePaddings.hugePadding),
      SettingsList(
          shrinkWrap: true,
          applicationType: ApplicationType.material,
          contentPadding: const EdgeInsets.all(0),
          darkTheme: theme,
          lightTheme: theme,
          sections: [
            SettingsSection(
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  onToggle: (value) async {
                    //When enabling, then reauthenticate and then localise Authenticate
                    if (value == true) {
                      final bool reAuthValue = await reAuthDialog(context);
                      if (!reAuthValue) {
                        return false;
                      }
                      final bool didAuthenticate = await auth.authenticate(
                          localizedReason: ' ',
                          options:
                              const AuthenticationOptions(biometricOnly: true));
                      if (!didAuthenticate) {
                        return false;
                      }
                    } else {
                      final bool reAuthValue = await reAuthDialog(context);
                      if (!reAuthValue) {
                        return false;
                      }
                    }
                    setState(() {
                      enabled = value;
                    });
                    await settingsStore.setBiometrics(value);
                  },
                  initialValue: enabled,
                  title:
                      Text('Use biometric access', style: TextStyles.labelText),
                ),
              ],
            ),
          ])
    ]);
  }

  Widget showPossibleErrors() {
    String? errorText;
    String? errorDescription;
    if (canCheckBiometrics == false) {
      errorText = "Biometric authentication not available";
      errorDescription =
          "Your device does not support biometric authentication";
    }
    if (availableBiometrics == null) {
      errorText = "Biometric authentication not available";
      errorDescription =
          "Your device does not support biometric authentication";
    }
    if (availableBiometrics != null && availableBiometrics!.isEmpty) {
      errorText = "No biometric data has been registered in the device.";
      errorDescription =
          "Your device supports biometric authentication but you have not registered your biometric data yet. Please navigate to your device control panel, register your biometric data and try again";
    }
    if (errorText == null) {
      return Container();
    }
    return Padding(
        padding: EdgeInsets.only(top: ThemePaddings.bigPadding),
        child: ThemedControls.card(
            child: Column(children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GradientForeground(
                      child: Image.asset("assets/images/Group 2358.png")),
                  ThemedControls.spacerHorizontalNormal(),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(errorText, style: TextStyles.labelText),
                        ThemedControls.spacerVerticalNormal(),
                        Text(errorDescription ?? "",
                            style: TextStyles.textNormal)
                      ]))
                ]),
          ]),
        ])));
  }

  Widget getScrollView() {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Row(children: [
          Container(
              child: Expanded(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ThemedControls.pageHeader(headerText: "Manage biometric unlock"),
              Text(
                  "You can enable strong authentication via biometrics. If enabled, you can sign in to your wallet and issue transfers without a password",
                  style: Theme.of(context).textTheme.bodyMedium),
              canUseBiometrics == null
                  ? loadingIndicator()
                  : canUseBiometrics! == true
                      ? biometricsControls()
                      : showPossibleErrors(),
            ],
          )))
        ]));
  }

  Widget getButtons() {
    return !isLoading
        ? Expanded(
            child: ThemedControls.primaryButtonBigWithChild(
                child: Padding(
                    padding: const EdgeInsets.all(ThemePaddings.normalPadding),
                    child:
                        Text("Go back", style: TextStyles.primaryButtonText)),
                onPressed: () {
                  Navigator.pop(context);
                }))
        : Container();
  }

  void saveIdHandler() async {
    Navigator.pop(context);
  }

  TextEditingController privateSeed = TextEditingController();

  bool showAccountInfoTooltip = false;
  bool showSeedInfoTooltip = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(!isLoading);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
                minimum: ThemeEdgeInsets.pageInsets
                    .copyWith(bottom: ThemePaddings.normalPadding),
                child: Column(children: [
                  Expanded(child: getScrollView()),
                  Row(children: [getButtons()]),
                ]))));
  }
}
