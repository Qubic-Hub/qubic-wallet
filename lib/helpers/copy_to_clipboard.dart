import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qubic_wallet/globals.dart';

/// Copies a string to clipboard ans shows a snackbar
copyToClipboard(String copiedText) async {
  await Clipboard.setData(ClipboardData(text: copiedText));

  snackbarKey.currentState?.showSnackBar(const SnackBar(
    elevation: 199,
    showCloseIcon: true,
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    content: Text('Copied to clipboard'),
  ));
}
