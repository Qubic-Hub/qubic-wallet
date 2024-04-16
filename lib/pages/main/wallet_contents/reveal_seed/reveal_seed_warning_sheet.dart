import 'package:flutter/material.dart';
import 'package:qubic_wallet/components/gradient_foreground.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/edgeInsets.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

class RevealSeedWarningSheet extends StatefulWidget {
  final Function() onAccept;
  final QubicListVm item;

  final Function() onReject;
  const RevealSeedWarningSheet(
      {super.key,
      required this.onAccept,
      required this.onReject,
      required this.item});

  @override
  _RevealSeedWarningSheetState createState() => _RevealSeedWarningSheetState();
}

class _RevealSeedWarningSheetState extends State<RevealSeedWarningSheet> {
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

  Widget getWarningText(String text) {
    return Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GradientForeground(
              child: Image.asset(
            "assets/images/attention-circle-color-16.png",
          )),
          ThemedControls.spacerHorizontalNormal(),
          Expanded(child: Text(text, style: TextStyles.textLarge))
        ]);
  }

  Widget getText() {
    return Row(children: [
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            ThemedControls.pageHeader(headerText: "Before you proceed"),
            ThemedControls.spacerVerticalNormal(),
            getWarningText("Keep a safe backup of your private seed"),
            ThemedControls.spacerVerticalNormal(),
            getWarningText("Never share your private seed with anyone"),
            ThemedControls.spacerVerticalNormal(),
            getWarningText(
                "Do not paste your private seed to unknown apps or websites"),
          ]))
    ]);
  }

  List<Widget> getButtons() {
    return [
      Expanded(
          child: ThemedControls.transparentButtonBig(
              onPressed: widget.onReject, text: "Take me back")),
      ThemedControls.spacerHorizontalSmall(),
      Expanded(
          child: ThemedControls.primaryButtonBig(
              onPressed: transferNowHandler, text: "Proceed")),
    ];
  }

  void transferNowHandler() async {
    if (!hasAccepted) {
      return;
    }
    widget.onAccept();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: ThemeEdgeInsets.bottomSheetInsets,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              getText(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ThemedControls.spacerVerticalNormal(),
                    const Divider(),
                    ThemedControls.spacerVerticalNormal(),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: hasAccepted,
                              onChanged: (value) {
                                setState(() {
                                  hasAccepted = value!;
                                });
                              }),
                          const Text("I understand the above")
                        ]),
                    const SizedBox(height: ThemePaddings.normalPadding),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: getButtons())
                  ])
            ])));
  }
}
