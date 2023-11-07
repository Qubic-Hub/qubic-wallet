import 'package:flutter/material.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/reauthenticate.dart';

Future<bool> reAuthDialog(BuildContext context) async {
  bool? hasAuthenticated =
      await Navigator.of(context).push(MaterialPageRoute<bool>(
          builder: (BuildContext context) {
            return const Reauthenticate();
          },
          fullscreenDialog: true));

  if (hasAuthenticated != null && hasAuthenticated) {
    return true;
  }
  return false;
}

Future<bool> reAuthDialogPassOnly(BuildContext context) async {
  bool? hasAuthenticated =
      await Navigator.of(context).push(MaterialPageRoute<bool>(
          builder: (BuildContext context) {
            return const Reauthenticate(passwordOnly: true);
          },
          fullscreenDialog: true));

  if (hasAuthenticated != null && hasAuthenticated) {
    return true;
  }
  return false;
}
