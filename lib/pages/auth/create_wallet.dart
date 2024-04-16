import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:qubic_wallet/components/w_behind_keyboard.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/styles/buttonStyles.dart';
import 'package:qubic_wallet/styles/inputDecorations.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

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
  bool obscuringText = true;

  Widget getLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
            width: 150,
            //    MediaQuery.of(context).size.height *                                              0.15,
            child: Image(image: AssetImage('assets/images/logo.png'))),
        ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 0.0,
              minWidth: 10.0,
              maxHeight: 45.0,
              maxWidth: 10.0,
            ),
            child: Container()),
        Text("Qubic Wallet",
            textAlign: TextAlign.center, style: TextStyles.pageTitle),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment(-1.0, 0.0),
            end: Alignment(1.0, 0.0),
            transform: GradientRotation(3.19911),
            stops: [
              0.03,
              1,
            ],
            colors: [
              // Color(0xFFBF0FFF),
              // Color(0xFF0F27FF),
              LightThemeColors.gradient1,
              LightThemeColors.gradient2,
            ],
          ))),
      Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [
              0.3,
              0.48,
              0.8,
            ],
            colors: [
              const Color(0x00FFFFFF),
              LightThemeColors.strongBackground.withOpacity(0.5),
              LightThemeColors.strongBackground
            ],
          ))),
      SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(ThemePaddings.bigPadding),
              child: Container(
                  constraints: const BoxConstraints.expand(),
                  child: FormBuilder(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WBehindKeyboard(
                                child:
                                    Expanded(child: Center(child: getLogo()))),
                            Container(
                                alignment: Alignment.center,
                                child: Builder(builder: (context) {
                                  if (signInError == null) {
                                    return const SizedBox(height: 25);
                                  } else {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: ThemePaddings.smallPadding),
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
                                      style: TextStyles.labelText),
                                ]),
                            const SizedBox(height: ThemePaddings.smallPadding),
                            FormBuilderTextField(
                              name: "password",
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              enabled: !isLoading,
                              decoration:
                                  ThemeInputDecorations.bigInputbox.copyWith(
                                hintText: "New wallet password",
                                suffixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        right: ThemePaddings.smallPadding),
                                    child: IconButton(
                                      icon: Icon(obscuringText
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() =>
                                            obscuringText = !obscuringText);
                                      },
                                    )),
                              ),
                              obscureText: obscuringText,
                              autocorrect: false,
                              autofillHints: null,
                            ),
                            const SizedBox(height: ThemePaddings.normalPadding),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info_outline,
                                      size: TextStyles.smallInfoText.fontSize! *
                                          1.5,
                                      color: LightThemeColors.gradient1),
                                  const SizedBox(
                                      width: ThemePaddings.smallPadding),
                                  Flexible(
                                      child: Text(
                                          "A password is asked to give you access to your wallet contents. It cannot be recovered if lost.",
                                          maxLines: 5,
                                          softWrap: true,
                                          style: TextStyles.smallInfoText))
                                ]),
                            const SizedBox(height: ThemePaddings.smallPadding),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.warning_amber_outlined,
                                      size: TextStyles.smallInfoText.fontSize! *
                                          1.5,
                                      color: LightThemeColors.gradient1),
                                  const SizedBox(
                                      width: ThemePaddings.smallPadding),
                                  Flexible(
                                      child: Text(
                                          "If a wallet already exists in this device, it will be overwritten. Nonetheless, your \$QUBIC and assets are tied to your private seeds will not be deleted and can be added to your new wallet.",
                                          maxLines: 5,
                                          softWrap: true,
                                          style: TextStyles.smallInfoText))
                                ]),
                            const SizedBox(height: ThemePaddings.normalPadding),
                            SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ThemedControls.primaryButtonBigWithChild(
                                    onPressed: () async {
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
                                    return Text("Create new wallet",
                                        style: TextStyles.primaryButtonText);
                                  }
                                }))),
                            const SizedBox(height: ThemePaddings.normalPadding),
                            SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ThemedControls.transparentButtonBigText(
                                    onPressed: () {
                                      context.goNamed("signIn");
                                    },
                                    text: "Back")),
                          ])))))
    ]));
  }
}
