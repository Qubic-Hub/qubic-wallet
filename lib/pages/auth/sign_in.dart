import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qubic_wallet/globals.dart';
import 'package:qubic_wallet/helpers/global_snack_bar.dart';
import 'package:qubic_wallet/resources/qubic_cmd_utils.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/services/qubic_hub_service.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/qubic_hub_store.dart';
import 'package:qubic_wallet/stores/settings_store.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormBuilderState>();
  final LocalAuthentication auth = LocalAuthentication();

  final ApplicationStore appStore = getIt<ApplicationStore>();
  final SettingsStore settingsStore = getIt<SettingsStore>();
  final QubicHubStore qubicHubStore = getIt<QubicHubStore>();
  final QubicHubService qubicHubService = getIt<QubicHubService>();

  final GlobalSnackBar _globalSnackbar = getIt<GlobalSnackBar>();
  String? signInError;

  //FJS

  @override
  void initState() {
    super.initState();
    qubicHubService.loadVersionInfo().then((value) {
      if (qubicHubStore.updateNeeded) {
        showAlertDialog(context, "Update required",
            "USE THIS VERSION AT YOUR OWN RISK\n\nYour current version is outdated and will possibly not work. Please update your wallet version to ${qubicHubStore.minVersion}.\n\nYou can still access your funds and back up your seeds, but other functionality may be broken.  ");
      }
    }, onError: (e) {
      _globalSnackbar.show(e.toString().replaceAll("Exception: ", ""));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget biometricsButton() {
    if (isLoading) {
      return Container();
    }
    return TextButton(onPressed: () async {
      if (isLoading) {
        return;
      }
      setState(() {
        isLoading = true;
      });
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: ' ',
          options: const AuthenticationOptions(biometricOnly: true));

      if (didAuthenticate) {
        await appStore.biometricSignIn();
        await authSuccess();
      }
      setState(() {
        isLoading = false;
      });
    }, child: Builder(builder: (context) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(
              ThemePaddings.normalPadding, 0, ThemePaddings.normalPadding, 0),
          child: SizedBox(
              height: 40,
              width: 42,
              child: Icon(Icons.fingerprint,
                  size: 42, color: Theme.of(context).colorScheme.primary)));
    }));
  }

  Future<void> authSuccess() async {
    try {
      await getIt<QubicLi>().authenticate();
      setState(() {
        isLoading = false;
      });
      context.goNamed("mainScreen");
    } catch (e) {
      showAlertDialog(context, "Error contacting Qubic Network", e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget signInButton() {
    return FilledButton(onPressed: () async {
      if (isLoading) {
        return;
      }
      setState(() {
        signInError = null;
      });
      _formKey.currentState?.validate();
      if (_formKey.currentState!.isValid) {
        setState(() {
          isLoading = true;
          signInError = null;
        });
        if (await appStore
            .signIn(_formKey.currentState!.instantValue["password"])) {
          authSuccess();
        } else {
          setState(() {
            isLoading = false;
          });
          setState(() {
            signInError = "You have provided an invalid password";
          });
        }
      }
    }, child: Builder(builder: (context) {
      if (isLoading) {
        return Padding(
            padding: const EdgeInsets.all(ThemePaddings.normalPadding),
            child: SizedBox(
                height: 22,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.inversePrimary)));
      } else {
        return const Padding(
            padding: EdgeInsets.all(ThemePaddings.normalPadding),
            child: Text("Sign in"));
      }
    }));
  }

  List<Widget> getCTA() {
    List<Widget> results = [signInButton()];
    if (settingsStore.settings.biometricEnabled) {
      results.add(const VerticalDivider());
      results.add(biometricsButton());
    }
    return results;
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    bool obscuringText = true;
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(ThemePaddings.bigPadding),
                child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: FormBuilder(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Center(
                                      child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                      width: 150,
                                      //    MediaQuery.of(context).size.height *                                              0.15,
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/logo_qh.png'))),
                                  Text("qubic wallet",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .displayLarge
                                          ?.copyWith(
                                              fontFamily: ThemeFonts.primary,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color)),
                                  Observer(builder: (BuildContext context) {
                                    if (qubicHubStore.versionInfo == null) {
                                      return Container();
                                    }
                                    return Text(
                                        "Version ${qubicHubStore.versionInfo}",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .bodySmall
                                            ?.copyWith(
                                                fontFamily: ThemeFonts.primary,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color));
                                  }),
                                  Text(
                                      "Copyright (C) 2023 - ${DateTime.now().year} Qubic-Hub",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodySmall
                                          ?.copyWith(
                                              fontFamily: ThemeFonts.primary,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color)),
                                ],
                              ))),
                              Container(
                                  alignment: Alignment.center,
                                  child: Builder(builder: (context) {
                                    if (signInError == null) {
                                      return Container(
                                          child: const SizedBox(height: 25));
                                    } else {
                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom:
                                                  ThemePaddings.smallPadding),
                                          child: Text(signInError!,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error)));
                                    }
                                  })),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Sign In",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleLarge
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color)),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: TextButton(
                                            child: Text(
                                              "Create new wallet",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                            ),
                                            onPressed: () {
                                              context.goNamed("createWallet");
                                            }))
                                  ]),
                              const SizedBox(
                                  height: ThemePaddings.smallPadding),
                              FormBuilderTextField(
                                name: "password",
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                enabled: !isLoading,
                                decoration: const InputDecoration(
                                    labelText: 'Wallet password'),
                                obscureText: obscuringText,
                                autocorrect: false,
                                autofillHints: null,
                              ),
                              const SizedBox(
                                  height: ThemePaddings.normalPadding),
                              Observer(builder: (context) {
                                return Center(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: getCTA()));
                              })
                            ]))))));
  }
}
