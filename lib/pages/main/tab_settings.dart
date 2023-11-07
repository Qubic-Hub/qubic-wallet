import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/re_auth_dialog.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/settings/about_wallet.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/settings/change_password.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/settings/manage_biometics.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/resources/secure_storage.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/explorer_store.dart';
import 'package:qubic_wallet/stores/settings_store.dart';
import 'package:qubic_wallet/stores/qubic_hub_store.dart';
import 'package:qubic_wallet/timed_controller.dart';
import 'package:settings_ui/settings_ui.dart';

class TabSettings extends StatefulWidget {
  const TabSettings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabSettingsState createState() => _TabSettingsState();
}

class _TabSettingsState extends State<TabSettings> {
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final ExplorerStore explorerStore = getIt<ExplorerStore>();
  final SettingsStore settingsStore = getIt<SettingsStore>();
  final QubicHubStore qubicHubStore = getIt<QubicHubStore>();
  final SecureStorage secureStorage = getIt<SecureStorage>();
  final QubicLi li = getIt<QubicLi>();

  final TimedController timedController = getIt<TimedController>();

  //Pagination Related
  int numberOfPages = 0;
  int currentPage = 1;
  int itemsPerPage = 1000;

  PackageInfo? packageInfo; // = await PackageInfo.fromPlatform();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) => setState(() {
          packageInfo = value;
        }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> wipeWalletDataDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
          title: Text('Wipe wallet data?',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontFamily: ThemeFonts.primary)),
          content: SingleChildScrollView(
            child: Text(
                "- All wallet data will be lost. \n- No funds or assets will be lost.\n\nMAKE SURE THAT YOU HAVE BACKED UP YOUR PRIVATE SEEDS.",
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontFamily: ThemeFonts.secondary)),
          ),
          actions: isLoading
              ? <Widget>[const CircularProgressIndicator()]
              : <Widget>[
                  TextButton(
                    child: const Text('NO'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('YES'),
                    onPressed: () async {
                      var result = await reAuthDialog(context);
                      if (!result) {
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      await secureStorage.deleteWallet();
                      await settingsStore.loadSettings();
                      appStore.signOut();
                      timedController.stopFetchTimer();
                      context.go('/signIn');
                    },
                  ),
                ],
        );
      },
    );
  }

  Widget getHeader() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: double.infinity, height: 0),
      const SizedBox(height: ThemePaddings.hugePadding),
      const SizedBox(height: ThemePaddings.hugePadding),
      Text("Settings",
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontFamily: ThemeFonts.primary))
    ]);
  }

  Widget getSettings() {
    var theme = SettingsThemeData(
      settingsSectionBackground: Theme.of(context).cardTheme.color,
      settingsListBackground: Theme.of(context).cardTheme.color,
      dividerColor: Theme.of(context).colorScheme.outline,
      titleTextColor: Theme.of(context).colorScheme.onBackground,
    );

    Widget getTrailingArrow() {
      return Icon(Icons.arrow_forward_ios_outlined,
          color:
              Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.2));
    }

    return SettingsList(
      shrinkWrap: false,
      applicationType: ApplicationType.material,
      contentPadding: const EdgeInsets.all(0),
      darkTheme: theme,
      lightTheme: theme,
      sections: [
        SettingsSection(
          title: const Text('Security'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
                leading: Icon(Icons.password_outlined,
                    color: Theme.of(context).colorScheme.primary),
                trailing: getTrailingArrow(),
                title: const Text('Change password'),
                onPressed: (BuildContext? context) async {
                  PersistentNavBarNavigator.pushNewScreen(
                    context!,
                    screen: const ChangePassword(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                }),
            SettingsTile.navigation(
              leading: Icon(Icons.fingerprint,
                  color: Theme.of(context).colorScheme.primary),
              trailing: getTrailingArrow(),
              title: const Text('Biometric unlock'),
              value: Observer(builder: (context) {
                return settingsStore.settings.biometricEnabled
                    ? Text("Enabled",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: ThemeFonts.secondary))
                    : const Text("Disabled");
              }),
              onPressed: (BuildContext? context) {
                PersistentNavBarNavigator.pushNewScreen(
                  context!,
                  screen: const ManageBiometrics(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
          ],
        ),
        SettingsSection(
          title: const Text('Account & Data'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.error),
              title: const Text('Sign out'),
              onPressed: (BuildContext context) {
                appStore.signOut();
                timedController.stopFetchTimer();
                context.go('/signIn');
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.cleaning_services_outlined,
                  color: Theme.of(context).colorScheme.error),
              title: const Text('Wipe wallet data'),
              onPressed: (BuildContext context) async {
                //MODAL TO CHECK IF USER AGREES
                await wipeWalletDataDialog(context);
              },
            ),
          ],
        ),
        SettingsSection(title: const Text('Other'), tiles: <SettingsTile>[
          SettingsTile.navigation(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              trailing: Observer(builder: (BuildContext context) {
                if (qubicHubStore.updateAvailable) {
                  return Icon(Icons.info, color: Colors.red);
                }
                return getTrailingArrow();
              }),
              title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wallet info'),
                    Observer(builder: (BuildContext context) {
                      if (qubicHubStore.versionInfo == null) {
                        return const Text("Loading...");
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Version ${qubicHubStore.versionInfo!}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontFamily: ThemeFonts.secondary)),
                            qubicHubStore.updateAvailable
                                ? Text("Update available",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                            color: Colors.red,
                                            fontFamily: ThemeFonts.secondary))
                                : Container(),
                          ]);
                    })
                  ]),
              onPressed: (BuildContext? context) async {
                PersistentNavBarNavigator.pushNewScreen(
                  context!,
                  screen: const AboutWallet(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }),
        ])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      ThemePaddings.normalPadding,
                      0,
                      ThemePaddings.normalPadding,
                      0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "Qubic Wallet - (C) ${DateTime.now().year} Qubic-Hub",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontFamily: ThemeFonts.primary))
                    ],
                  )))
        ],
      ),
      body: getSettings(),
    );
  }
}
