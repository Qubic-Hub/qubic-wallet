// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qubic_wallet/components/reauthenticate/authenticate_password.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/stores/application_store.dart';

class Reauthenticate extends StatefulWidget {
  final bool passwordOnly;
  const Reauthenticate({super.key, this.passwordOnly = false});

  @override
  // ignore: library_private_types_in_public_api
  _ReauthenticateState createState() => _ReauthenticateState();
}

class _ReauthenticateState extends State<Reauthenticate> {
  final ApplicationStore appStore = getIt<ApplicationStore>();

  bool hasAccepted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getHeader() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 100),
          Text("Please reauthenticate",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontFamily: ThemeFonts.primary)),
          //Text("Please authenticate again in order to proceed.")
        ]);
  }

  Widget getContents() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: getHeader()),
          AuthenticatePassword(
            onSuccess: () {
              Navigator.of(context).pop(true);
            },
            passOnly: widget.passwordOnly,
          ),
        ]);
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
            child: Center(child: getContents())));
  }
}
