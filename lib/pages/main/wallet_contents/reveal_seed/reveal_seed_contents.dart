import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qubic_wallet/components/toggleable_qr_code.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/copy_to_clipboard.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
import 'package:skeleton_text/skeleton_text.dart';

class RevealSeedContents extends StatefulWidget {
  final QubicListVm item;

  const RevealSeedContents({super.key, required this.item});

  @override
  _RevealSeedContentsState createState() => _RevealSeedContentsState();
}

class _RevealSeedContentsState extends State<RevealSeedContents> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();

  String? generatedPublicId;
  String? seedId;
  @override
  void initState() {
    super.initState();
    appStore.getSeedById(widget.item.publicId).then((value) {
      setState(() {
        seedId = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getScrollView() {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Row(children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ThemedControls.pageHeader(
                  headerText: "Private seed",
                  subheaderText: "of \"${widget.item.name}\""),
              ThemedControls.card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    Text("Private seed (keep secret)",
                        style: TextStyles.lightGreyTextSmall),
                    ThemedControls.spacerVerticalMini(),
                    Text(seedId!),
                    ThemedControls.spacerVerticalNormal(),
                    Row(children: [
                      ThemedControls.primaryButtonNormal(
                          onPressed: () {
                            copyToClipboard(seedId!);
                          },
                          text: "Copy private seed",
                          icon: ThemedControls.invertedColors(
                              child: LightThemeColors.shouldInvertIcon
                                  ? ThemedControls.invertedColors(
                                      child: Image.asset(
                                          "assets/images/Group 2400.png"))
                                  : Image.asset(
                                      "assets/images/Group 2400.png"))),
                    ])
                  ])),
              ThemedControls.spacerVerticalSmall(),
              ToggleableQRCode(qRCodeData: seedId!, expanded: false),
            ],
          ))
        ]));
  }

  List<Widget> getButtons() {
    return [
      FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "CLOSE",
          ))
    ];
  }

  TextEditingController privateSeed = TextEditingController();

  bool showAccountInfoTooltip = false;
  bool showSeedInfoTooltip = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: getScrollView()),
    ]);
  }
}
