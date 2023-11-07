import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qubic_wallet/globals.dart';

class CopyableText extends StatelessWidget {
  final Widget child;
  final String copiedText;

  const CopyableText(
      {super.key, required this.child, required this.copiedText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: copiedText));

          snackbarKey.currentState?.showSnackBar(const SnackBar(
            elevation: 199,
            showCloseIcon: true,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            content: Text('Copied to clipboard'),
          ));
        },
        child: Ink(child: child));
  }
}
