// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qubic_wallet/components/reauthenticate/authenticate_password.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/edgeInsets.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

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
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child:
              ThemedControls.pageHeader(headerText: "Authentication required"),
        ),
        Align(
          alignment: Alignment.center,
          child: Text("Please reauthenticate",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontFamily: ThemeFonts.primary)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text("Please authenticate again in order to proceed."),
        )
      ],
    );
    // return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Icon(Icons.lock, size: 100),
    //       Text("Please reauthenticate",
    //           style: Theme.of(context)
    //               .textTheme
    //               .displayMedium!
    //               .copyWith(fontFamily: ThemeFonts.primary)),
    //       //Text("Please authenticate again in order to proceed.")
    //     ]);
  }

  Widget getContents() {
    return Column(
      children: [
        Expanded(
            child: Align(
          alignment: Alignment.topLeft,
          child:
              ThemedControls.pageHeader(headerText: "Authentication required"),
        )),
        Expanded(
            child: Align(
          alignment: Alignment.center,
          child: AuthenticatePassword(
            onSuccess: () {
              Navigator.of(context).pop(true);
            },
            passOnly: widget.passwordOnly,
          ),
        )),
        Expanded(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(),
        ))
      ],
    );
    // return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Expanded(child: getHeader()),

    //     ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
            minimum: ThemeEdgeInsets.pageInsets,
            child: Center(child: getContents())));
  }
}
