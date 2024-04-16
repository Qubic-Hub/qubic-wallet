import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/change_foreground.dart';
import 'package:qubic_wallet/components/gradient_container.dart';
import 'package:qubic_wallet/components/gradient_foreground.dart';
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
import 'package:qubic_wallet/styles/edgeInsets.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
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
          title: Text('Wipe wallet data?',
              textAlign: TextAlign.left, style: TextStyles.alertHeader),
          content: SingleChildScrollView(
            child: Column(children: [
              Container(
                  padding: EdgeInsets.all(ThemePaddings.smallPadding),
                  child: Row(children: [
                    GradientForeground(
                        child: Image.asset("assets/images/info-color-16.png")),
                    ThemedControls.spacerHorizontalSmall(),
                    Expanded(child: Text("All wallet data will be lost"))
                  ])),
              ThemedControls.spacerVerticalMini(),
              Container(
                  padding: EdgeInsets.all(ThemePaddings.smallPadding),
                  child: Row(children: [
                    GradientForeground(
                        child: Image.asset("assets/images/info-color-16.png")),
                    ThemedControls.spacerHorizontalSmall(),
                    Expanded(child: Text("No funds or assets will be lost"))
                  ])),
              ThemedControls.spacerVerticalMini(),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: LightThemeColors.primary.withOpacity(0.05)),
                  padding: EdgeInsets.all(ThemePaddings.smallPadding),
                  child: Row(children: [
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: GradientForeground(
                          child: Image.asset("assets/images/Group 2358.png")),
                    ),
                    ThemedControls.spacerHorizontalSmall(),
                    Expanded(
                        child: Text(
                            "MAKE SURE THAT YOU HAVE BACKED UP YOUR PRIVATE SEEDS"))
                  ]))
            ]),
          ),
          actions: isLoading
              ? <Widget>[const CircularProgressIndicator()]
              : <Widget>[
                  ThemedControls.transparentButtonBigText(
                    text: "Yes",
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
                  ThemedControls.primaryButtonBig(
                    text: "No",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
        );
      },
    );
  }

  Widget getHeader() {
    return Padding(
        padding: const EdgeInsets.only(
            left: ThemePaddings.normalPadding,
            right: ThemePaddings.normalPadding,
            top: ThemePaddings.hugePadding,
            bottom: ThemePaddings.smallPadding),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Settings", style: TextStyles.pageTitle)]));
  }

  Widget getBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          getHeader(),
          Padding(padding: ThemeEdgeInsets.pageInsets, child: getSettings())
        ]);
  }

  Widget getSettingsHeader(String text, bool isFirst) {
    return Padding(
        padding: isFirst
            ? const EdgeInsets.only(bottom: ThemePaddings.smallPadding)
            : const EdgeInsets.fromLTRB(
                0, ThemePaddings.bigPadding, 0, ThemePaddings.smallPadding),
        child: Transform.translate(
            offset: const Offset(-16, 0),
            child: Text('Security', style: TextStyles.textBold)));
  }

  Widget getSettings() {
    var theme = SettingsThemeData(
      settingsSectionBackground: LightThemeColors.cardBackground,
      //Theme.of(context).cardTheme.color,
      settingsListBackground: LightThemeColors.backkground,
      dividerColor: Colors.transparent,
      titleTextColor: Theme.of(context).colorScheme.onBackground,
    );

    Widget getTrailingArrow() {
      return Container();
//      return Icon(Icons.arrow_forward_ios_outlined,
      //        color:
      //          Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.2));
    }

    return SettingsList(
      shrinkWrap: true,
      applicationType: ApplicationType.material,
      contentPadding: const EdgeInsets.all(0),
      darkTheme: theme,
      lightTheme: theme,
      sections: [
        SettingsSection(
          title: getSettingsHeader("Security", true),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
                leading: ChangeForeground(
                    child: const Icon(Icons.lock),
                    color: LightThemeColors.gradient1),
                trailing: getTrailingArrow(),
                title: Text('Change password', style: TextStyles.textNormal),
                onPressed: (BuildContext? context) async {
                  pushNewScreen(
                    context!,
                    screen: const ChangePassword(),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                }),
            SettingsTile.navigation(
              leading: ChangeForeground(
                  child: const Icon(Icons.fingerprint),
                  color: LightThemeColors.gradient1),
              trailing: getTrailingArrow(),
              title: Text('Biometric unlock', style: TextStyles.textNormal),
              value: Observer(builder: (context) {
                return settingsStore.settings.biometricEnabled
                    ? Text("Enabled",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontFamily: ThemeFonts.secondary))
                    : const Text("Disabled");
              }),
              onPressed: (BuildContext? context) {
                pushNewScreen(
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
          title: getSettingsHeader("Accounts and data", true),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: ChangeForeground(
                  child: const Icon(Icons.logout),
                  color: LightThemeColors.gradient1),
              title: Text('Sign out', style: TextStyles.textNormal),
              trailing: Container(),
              onPressed: (BuildContext context) {
                appStore.signOut();
                timedController.stopFetchTimer();
                context.go('/signIn');
              },
            ),
            SettingsTile.navigation(
              leading: ChangeForeground(
                  child: const Icon(Icons.cleaning_services_outlined),
                  color: LightThemeColors.gradient1),
              title: Text('Wipe wallet data', style: TextStyles.textNormal),
              trailing: Container(),
              onPressed: (BuildContext context) async {
                //MODAL TO CHECK IF USER AGREES
                await wipeWalletDataDialog(context);
              },
            ),
          ],
        ),
        SettingsSection(
            title: getSettingsHeader("Other", true),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                  leading: ChangeForeground(
                      child: const Icon(Icons.account_balance_wallet_outlined),
                      color: LightThemeColors.gradient1),
                  trailing: Observer(builder: (BuildContext context) {
                    if (qubicHubStore.updateAvailable) {
                      return const Icon(Icons.info, color: Colors.red);
                    }
                    return getTrailingArrow();
                  }),
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Wallet info', style: TextStyles.textNormal),
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
                                                fontFamily:
                                                    ThemeFonts.secondary))
                                    : Container(),
                              ]);
                        })
                      ]),
                  onPressed: (BuildContext? context) async {
                    pushNewScreen(
                      context!,
                      screen: const AboutWallet(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  }),
            ])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: ThemeEdgeInsets.pageInsets
              .copyWith(left: 0, right: 0, top: 0, bottom: 0),
          child: Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: getBody()))
          ])),
    );
  }
}
