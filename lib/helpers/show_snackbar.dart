import 'package:flutter/material.dart';
import 'package:qubic_wallet/globals.dart';

void showSnackBar(String message) {
  snackbarKey.currentState?.showSnackBar(SnackBar(
    elevation: 199,
    showCloseIcon: true,
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    content: Text(message),
  ));
}
