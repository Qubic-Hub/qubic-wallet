import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/stores/application_store.dart';

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

  Widget getScrollView() {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Row(children: [
          Container(
              child: Expanded(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Warning!",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontFamily: ThemeFonts.primary,
                      color: Theme.of(context).colorScheme.error)),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: ThemePaddings.normalPadding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("- Keep a safe backup of your private seed",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontFamily: ThemeFonts.primary)),
                        const SizedBox(height: ThemePaddings.normalPadding),
                        Text("- Never share your private seed with anyone",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontFamily: ThemeFonts.primary)),
                        const SizedBox(height: ThemePaddings.normalPadding),
                        Text("- DO NOT paste it to unknown apps or websites",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontFamily: ThemeFonts.primary)),
                        const SizedBox(height: ThemePaddings.normalPadding),
                      ])),
              const SizedBox(height: ThemePaddings.normalPadding),
            ],
          )))
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
              const Text("I have read and understood the warning")
            ]),
            const SizedBox(height: ThemePaddings.normalPadding),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: getButtons())
          ])
    ]));
  }
}
