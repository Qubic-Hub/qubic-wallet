import 'package:flutter/material.dart';

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
