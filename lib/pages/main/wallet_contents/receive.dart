import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qubic_wallet/components/copyable_text.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/show_snackbar.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';

import 'package:qubic_wallet/stores/application_store.dart';
import 'package:share_plus/share_plus.dart';

class Receive extends StatefulWidget {
  final QubicListVm item;
  const Receive({super.key, required this.item});

  @override
  // ignore: library_private_types_in_public_api
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();

  String? generatedPublicId;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getQRCode() {
    return Container(
        color: Colors.white,
        child: QrImageView(
            data: widget.item.publicId,
            version: QrVersions.auto,
            backgroundColor: Colors.white,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            embeddedImage: const AssetImage('assets/images/logo.png'),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(80, 80),
            ),
            padding: const EdgeInsets.all(ThemePaddings.normalPadding)));
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
              Text("Receive  in \"${widget.item.name}\"",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontFamily: ThemeFonts.primary)),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: ThemePaddings.normalPadding),
                  child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          getQRCode(),
                          const SizedBox(height: ThemePaddings.bigPadding),
                          Text("Public ID ",
                              style: Theme.of(context).textTheme.bodyMedium!),
                          const SizedBox(height: ThemePaddings.normalPadding),
                          Builder(builder: (context) {
                            return Container(
                                width: double.infinity,
                                child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(
                                            ThemePaddings.smallPadding),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flex(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Flexible(
                                                        child: SelectableText(
                                                            widget
                                                                .item.publicId,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!)),
                                                    IconButton(
                                                        onPressed: () async {
                                                          await Clipboard.setData(
                                                              ClipboardData(
                                                                  text: widget
                                                                      .item
                                                                      .publicId));
                                                        },
                                                        icon: const Icon(
                                                            Icons.copy)),
                                                    IconButton(
                                                        onPressed: () async {
                                                          Share.share(
                                                              '${widget.item.publicId}}');
                                                        },
                                                        icon: const Icon(
                                                            Icons.share))
                                                  ])
                                            ]))));
                          }),
                          const SizedBox(height: ThemePaddings.miniPadding),
                          Text("can be used to receive \$QUBIC and assets",
                              style: Theme.of(context).textTheme.bodySmall!),
                        ],
                      )))
            ],
          )))
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

  void saveIdHandler() async {
    _formKey.currentState?.validate();
    if (!_formKey.currentState!.isValid) {
      return;
    }

    //Prevent duplicates

    if (appStore.currentQubicIDs
        .where(((element) =>
            element.publicId == generatedPublicId!.replaceAll(",", "_")))
        .isNotEmpty) {
      showSnackBar("This ID already exists in your wallet");

      return;
    }

    setState(() {
      isLoading = true;
    });
    appStore.addId(
      _formKey.currentState?.instantValue["accountName"] as String,
      generatedPublicId!,
      _formKey.currentState?.instantValue["privateSeed"] as String,
    );

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);
  }

  TextEditingController privateSeed = TextEditingController();

  bool showAccountInfoTooltip = false;
  bool showSeedInfoTooltip = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(!isLoading);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
                minimum: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding,
                    0, ThemePaddings.normalPadding, ThemePaddings.miniPadding),
                child: Column(children: [
                  Expanded(child: getScrollView()),
                ]))));
  }
}
