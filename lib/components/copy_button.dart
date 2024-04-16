import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/globals.dart';
import 'package:qubic_wallet/helpers/copy_to_clipboard.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

class CopyButton extends StatelessWidget {
  final String copiedText;

  const CopyButton({super.key, required this.copiedText});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await copyToClipboard(copiedText);
        },
        icon: LightThemeColors.shouldInvertIcon
            ? ThemedControls.invertedColors(
                child: Image.asset("assets/images/Group 2400.png"))
            : Image.asset("assets/images/Group 2400.png"));
  }
}
