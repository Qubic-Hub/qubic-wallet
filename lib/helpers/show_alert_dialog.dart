import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

getAlertDialog(String title, String message,
    {String primaryButtonLabel = "OK",
    Function? primaryButtonFunction,
    String? secondaryButtonLabel,
    Function? secondaryButtonFunction}) {
  List<Widget> actions = [];

  if (secondaryButtonLabel != null) {
    assert(secondaryButtonFunction != null);
    actions.add(ConstrainedBox(
        constraints: BoxConstraints(minWidth: 100),
        child: ThemedControls.transparentButtonBig(
          text: secondaryButtonLabel,
          onPressed: () async {
            if (secondaryButtonFunction != null) {
              secondaryButtonFunction();
            }
          },
        )));
  }
  actions.add(ConstrainedBox(
      constraints: BoxConstraints(minWidth: 100),
      child: ThemedControls.primaryButtonBig(
        text: primaryButtonLabel,
        onPressed: () async {
          if (primaryButtonFunction != null) {
            primaryButtonFunction();
          }
        },
      )));

  return AlertDialog(
      surfaceTintColor: LightThemeColors.strongBackground,
      title: Text(title, style: TextStyles.alertHeader),
      content: Text(message, style: TextStyles.alertText),
      actions: actions);
}

showAlertDialog(BuildContext context, String title, String message,
    {Function? onOk}) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () async {
      Navigator.of(context).pop();

      if (onOk != null) {
        onOk() {}
      }
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
