import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateWalletState createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();

  String? signInError;

  bool isLoading = false;

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
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: const Image(
                                          image: AssetImage(
                                              'assets/images/logo_qh.png'))),
                                  const SizedBox(
                                      height: ThemePaddings.normalPadding),
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
                                                  ?.color))
                                ],
                              ))),
                              Container(
                                  alignment: Alignment.center,
                                  child: Builder(builder: (context) {
                                    if (signInError == null) {
                                      return const SizedBox(height: 25);
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
                                    Text("Create wallet",
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
                                              "Sign in",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                            ),
                                            onPressed: () {
                                              context.goNamed("signIn");
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
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color),
                                    const SizedBox(
                                        width: ThemePaddings.smallPadding),
                                    Flexible(
                                        child: Text(
                                            "A password is asked to give you access to your wallet contents. It cannot be recovered if lost.",
                                            maxLines: 5,
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color)))
                                  ]),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.warning_amber_outlined,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color),
                                    const SizedBox(
                                        width: ThemePaddings.smallPadding),
                                    Flexible(
                                        child: Text(
                                            "If a wallet already exists in this device, it will be overwritten. Nonetheless, your \$QUBIC and assets are tied to your private seeds will not be deleted and can be added to your new wallet.",
                                            maxLines: 5,
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color)))
                                  ]),
                              const SizedBox(
                                  height: ThemePaddings.smallPadding),
                              Center(
                                  child: FilledButton(onPressed: () async {
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
                                  if (await appStore.signUp(_formKey
                                      .currentState!
                                      .instantValue["password"])) {
                                    try {
                                      await getIt<QubicLi>().authenticate();
                                      setState(() {
                                        isLoading = false;
                                      });
                                      context.goNamed("mainScreen");
                                    } catch (e) {
                                      showAlertDialog(
                                          context,
                                          "Error contacting Qubic Network",
                                          e.toString());
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    setState(() {
                                      signInError =
                                          "You have provided an invalid password";
                                    });
                                  }
                                }
                              }, child: Builder(builder: (context) {
                                if (isLoading) {
                                  return SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary));
                                } else {
                                  return const Text("Create wallet");
                                }
                              }))),
                            ]))))));
  }
}
