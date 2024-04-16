import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

class AddAccountWarning extends StatefulWidget {
  final Function() onAccept;
  final Function() onReject;
  const AddAccountWarning(
      {super.key, required this.onAccept, required this.onReject});

  @override
  _AddAccountWarningState createState() => _AddAccountWarningState();
}

class _AddAccountWarningState extends State<AddAccountWarning> {
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
          Image.asset(
            "assets/images/attention-circle-color-16.png",
          ),
          ThemedControls.spacerHorizontalNormal(),
          Expanded(child: Text(text, style: TextStyles.textLarge))
        ]);
  }

  Widget getScrollView() {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Row(children: [
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
        ]));
  }

  List<Widget> getButtons() {
    return [
      Padding(
          padding: EdgeInsets.only(bottom: ThemePaddings.normalPadding),
          child: TextButton(
              onPressed: widget.onReject,
              child: const SizedBox(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          ThemePaddings.normalPadding,
                          ThemePaddings.smallPadding,
                          ThemePaddings.normalPadding,
                          ThemePaddings.smallPadding),
                      child:
                          Text("Take me back", textAlign: TextAlign.center))))),
      Padding(
          padding: EdgeInsets.only(bottom: ThemePaddings.normalPadding),
          child: FilledButton(
              onPressed: transferNowHandler,
              child: const SizedBox(
                  child: Padding(
                      padding: EdgeInsets.all(ThemePaddings.normalPadding),
                      child: Text("Proceed", textAlign: TextAlign.center))))),
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
    return Scaffold(
        body: Column(children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.all(ThemePaddings.normalPadding),
              child: getScrollView())),
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Checkbox(
                  value: hasAccepted,
                  onChanged: (value) {
                    setState(() {
                      hasAccepted = value!;
                    });
                  }),
              const Text("I have read and understood the above")
            ]),
            ThemedControls.spacerVerticalNormal(),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: getButtons())
          ])
    ]));
  }
}
