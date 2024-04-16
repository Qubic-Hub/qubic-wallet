import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

import '../flutter_flow/theme_paddings.dart';

class ToggleableQRCode extends StatefulWidget {
  final String qRCodeData;
  final bool expanded;
  final bool hasQubicLogo;
  const ToggleableQRCode(
      {super.key,
      required this.qRCodeData,
      this.expanded = false,
      this.hasQubicLogo = false});

  @override
  // ignore: library_private_types_in_public_api
  _ToggleableQRCodeState createState() => _ToggleableQRCodeState();
}

class _ToggleableQRCodeState extends State<ToggleableQRCode> {
  late bool expanded = widget.expanded;

  Widget getButton() {
    return ThemedControls.primaryButtonNormal(
        onPressed: () {
          setState(() {
            expanded = !expanded;
          });
        },
        text: !expanded ? "Show QR Code" : "Hide QR Code",
        icon: !LightThemeColors.shouldInvertIcon
            ? ThemedControls.invertedColors(
                child: Image.asset("assets/images/Group 2294.png"))
            : Image.asset("assets/images/Group 2294.png"));
  }

  Widget getContents() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          axisAlignment: 1,
          sizeFactor: CurvedAnimation(
              parent: animation,
              curve: Curves.fastEaseInToSlowEaseOut), //animation,
          child: child,
        );
      },
      child: expanded
          ? Column(children: [
              ThemedControls.card(
                  child: Column(children: [
                QrImageView(
                  data: widget.qRCodeData,
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  embeddedImage: widget.hasQubicLogo
                      ? AssetImage('assets/images/logo.png')
                      : null,
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(80, 80),
                  ),
                )
              ])),
              ThemedControls.spacerVerticalSmall(),
            ])
          : null,
    );

    //return ThemedControls.card(child: Column(children: [Text("aaa")]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [getContents(), getButton()]);
  }
}
