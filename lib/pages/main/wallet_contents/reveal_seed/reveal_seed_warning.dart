import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';

class RevealSeedWarning extends StatefulWidget {
  final QubicListVm item;
  final Function() onAccept;
  const RevealSeedWarning(
      {super.key, required this.item, required this.onAccept});

  @override
  _RevealSeedWarningState createState() => _RevealSeedWarningState();
}

class _RevealSeedWarningState extends State<RevealSeedWarning> {
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
                  child: Column(children: [
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
                    Text("- This may result in loss of your funds and assets",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontFamily: ThemeFonts.primary))
                  ])),
              const SizedBox(height: ThemePaddings.normalPadding),
            ],
          )))
        ]));
  }

  List<Widget> getButtons() {
    return [
      FilledButton(
          onPressed: transferNowHandler,
          child: const SizedBox(
              width: 220,
              child: Padding(
                  padding: EdgeInsets.all(ThemePaddings.normalPadding),
                  child:
                      Text("SHOW PRIVATE SEED", textAlign: TextAlign.center))))
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
    return Column(children: [
      Expanded(child: getScrollView()),
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Row(children: [
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: getButtons())
          ])
    ]);
  }
}
