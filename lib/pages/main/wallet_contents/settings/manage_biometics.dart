import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/settings_store.dart';
import 'package:settings_ui/settings_ui.dart';

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
      settingsSectionBackground: Theme.of(context).colorScheme.background,
      settingsListBackground: Theme.of(context).colorScheme.background,
      dividerColor: Theme.of(context).colorScheme.outline,
      titleTextColor: Theme.of(context).colorScheme.onBackground,
    );

    return Column(children: [
      const SizedBox(height: ThemePaddings.hugePadding),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.fingerprint,
            size: 100,
            color: Theme.of(context)
                .textTheme
                .titleMedium
                ?.color!
                .withOpacity(0.3)),
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
                    if (value == true) {
                      final bool didAuthenticate = await auth.authenticate(
                          localizedReason: ' ',
                          options:
                              const AuthenticationOptions(biometricOnly: true));
                      if (!didAuthenticate) {
                        return false;
                      }
                    }
                    setState(() {
                      enabled = value;
                    });
                    await settingsStore.setBiometrics(value);
                  },
                  initialValue: enabled,
                  title: const Text('Enable biometric access'),
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
    return Column(children: [
      const SizedBox(height: ThemePaddings.hugePadding),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.error_outline,
            size: 100,
            color: Theme.of(context)
                .textTheme
                .titleMedium
                ?.color!
                .withOpacity(0.3)),
      ]),
      const SizedBox(height: ThemePaddings.smallPadding),
      Column(children: [
        Divider(),
        Text(errorText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontFamily: ThemeFonts.primary)),
        errorDescription != null
            ? Text(errorDescription,
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontFamily: ThemeFonts.secondary))
            : Container()
      ])
    ]);
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
              Text("Manage biometric unlock",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontFamily: ThemeFonts.primary)),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: ThemePaddings.normalPadding),
                  child: Text(
                      "You can enable strong authentication via biometrics. If enabled, you can sign in to your wallet and issue transfers without a password",
                      style: Theme.of(context).textTheme.bodyMedium)),
              canUseBiometrics == null
                  ? loadingIndicator()
                  : canUseBiometrics! == true
                      ? biometricsControls()
                      : showPossibleErrors(),
            ],
          )))
        ]));
  }

  List<Widget> getButtons() {
    return [
      !isLoading
          ? TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CANCEL",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      )))
          : Container(),
      FilledButton(onPressed: saveIdHandler, child: const Text("SAVE NEW ID"))
    ];
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
                minimum: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding,
                    0, ThemePaddings.normalPadding, ThemePaddings.miniPadding),
                child: Column(children: [
                  Expanded(child: getScrollView()),
                ]))));
  }
}
