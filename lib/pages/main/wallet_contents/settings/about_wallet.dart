import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qubic_wallet/components/available_update_card.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/update_details_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/globals.dart';
import 'package:qubic_wallet/helpers/re_auth_dialog.dart';
import 'package:qubic_wallet/helpers/show_alert_dialog.dart';
import 'package:qubic_wallet/helpers/show_snackbar.dart';
import 'package:qubic_wallet/models/version_number.dart';
import 'package:qubic_wallet/resources/secure_storage.dart';
import 'package:qubic_wallet/services/qubic_hub_service.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/qubic_hub_store.dart';
import 'package:qubic_wallet/stores/settings_store.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWallet extends StatefulWidget {
  const AboutWallet({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutWalletState createState() => _AboutWalletState();
}

class _AboutWalletState extends State<AboutWallet> {
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final SettingsStore settingsStore = getIt<SettingsStore>();
  final SecureStorage secureStorage = getIt<SecureStorage>();
  final QubicHubStore qubicHubStore = getIt<QubicHubStore>();
  final QubicHubService qubicService = getIt<QubicHubService>();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    qubicService.loadUpdateInfo().then((value) {
      setState(() {
        isLoading = false;
      });
    }, onError: (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString().replaceAll("Exception: ", ""));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getLoadingIndicator() {
    return isLoading
        ? const Padding(
            padding: EdgeInsets.only(top: ThemePaddings.normalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    child: CircularProgressIndicator(), width: 15, height: 15),
                Text("  Checking for updates...")
              ],
            ))
        : Container();
  }

  Widget getLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
            width: 150,
            //    MediaQuery.of(context).size.height *                                              0.15,
            child: Image(image: AssetImage('assets/images/logo_qh.png'))),
        Text("qubic wallet",
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.displayLarge?.copyWith(
                fontFamily: ThemeFonts.primary,
                color: Theme.of(context).textTheme.bodyMedium?.color)),
        Observer(builder: (BuildContext context) {
          if (qubicHubStore.versionInfo == null) {
            return Container();
          }
          return Text("Version ${qubicHubStore.versionInfo}",
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(
                  fontFamily: ThemeFonts.primary,
                  color: Theme.of(context).textTheme.bodyLarge?.color));
        }),
        Text("Copyright (C) 2023 - ${DateTime.now().year} Qubic-Hub",
            style: Theme.of(context).primaryTextTheme.bodyLarge?.copyWith(
                fontFamily: ThemeFonts.primary,
                color: Theme.of(context).textTheme.bodyLarge?.color)),
        Link(
            uri: Uri.parse("https://qubic-hub.com"),
            target: LinkTarget.blank,
            builder: (context, followLink) {
              return TextButton(
                  onPressed: followLink,
                  child: Text("https://qubic-hub.com",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .bodyLarge
                          ?.copyWith(
                              fontFamily: ThemeFonts.primary,
                              color: Theme.of(context).colorScheme.primary)));
            }),
      ],
    );
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
              Center(child: getLogo()),
              getLoadingIndicator(),
              Observer(builder: (context) {
                if (qubicHubStore.updateDetails != null) {
                  return AvailableUpdateCard(
                      updateDetails: qubicHubStore.updateDetails!);
                }
                return Container();
              })
            ],
          )))
        ]));
  }

  List<Widget> getButtons() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding, 0,
                ThemePaddings.normalPadding, ThemePaddings.miniPadding),
            child: Column(children: [
              Expanded(child: getScrollView()),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: getButtons())
            ])));
  }
}
