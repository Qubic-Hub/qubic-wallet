import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/settings_store.dart';

class AuthenticatePassword extends StatefulWidget {
  final Function onSuccess;
  final bool passOnly;
  const AuthenticatePassword(
      {super.key, required this.onSuccess, this.passOnly = false});

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticatePasswordState createState() => _AuthenticatePasswordState();
}

class _AuthenticatePasswordState extends State<AuthenticatePassword> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final SettingsStore settingsStore = getIt<SettingsStore>();
  final LocalAuthentication auth = LocalAuthentication();

  String? signInError;

  @override
  void initState() {
    super.initState;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getCTA() {
    List<Widget> children = [signInButton()];
    if (settingsStore.settings.biometricEnabled && !widget.passOnly) {
      children.add(const VerticalDivider());
      children.add(biometricsButton());
    }
    return Padding(
        padding: EdgeInsets.only(bottom: ThemePaddings.normalPadding),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: children));
  }

  Widget biometricsButton() {
    return TextButton(
        onPressed: () async {
          if (isLoading) {
            return;
          }
          setState(() {
            isLoading = true;
            signInError = null;
          });

          final bool didAuthenticate = await auth.authenticate(
              localizedReason: ' ',
              options: const AuthenticationOptions(biometricOnly: true));

          if (didAuthenticate) {
            widget.onSuccess();
          }
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
                ThemePaddings.normalPadding, 0, ThemePaddings.normalPadding, 0),
            child: SizedBox(
                height: 42,
                width: 42,
                child: Icon(Icons.fingerprint,
                    size: 42, color: Theme.of(context).colorScheme.primary))));
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
          setState(() {
            isLoading = false;
          });

          widget.onSuccess();
        } else {
          setState(() {
            isLoading = false;
            signInError = "You provided an invalid password";
          });
        }
      }
    }, child: Builder(builder: (context) {
      if (isLoading) {
        return Padding(
            padding: const EdgeInsets.all(
              ThemePaddings.normalPadding,
            ),
            child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.inversePrimary)));
      } else {
        return const Padding(
            padding: EdgeInsets.all(
              ThemePaddings.normalPadding,
            ),
            child: Text("Authenticate"));
      }
    }));
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    bool obscuringText = true;
    return FormBuilder(
        key: _formKey,
        child: Column(children: [
          Container(
              alignment: Alignment.center,
              child: Builder(builder: (context) {
                if (signInError == null) {
                  return Container(child: const SizedBox(height: 33));
                } else {
                  return Padding(
                      padding: const EdgeInsets.only(
                          bottom: ThemePaddings.normalPadding),
                      child: Text(signInError!,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.error)));
                }
              })),
          FormBuilderTextField(
            name: "password",
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            enabled: !isLoading,
            decoration: const InputDecoration(labelText: 'Wallet password'),
            obscureText: obscuringText,
            autocorrect: false,
            autofillHints: null,
          ),
          const SizedBox(height: ThemePaddings.normalPadding),
          Center(child: getCTA()),
        ]));
  }
}
