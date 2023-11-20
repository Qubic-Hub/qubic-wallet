import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';
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
          Container(
              child: Expanded(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Private seed of  \"${widget.item.name}\"",
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
                          const SizedBox(height: ThemePaddings.miniPadding),
                          Center(
                              child: Text(
                                  "DO NOT SHARE WITH OTHERS OR PASTE IN UNKNOWN APPS OR WEBSITES",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error))),
                          const SizedBox(height: ThemePaddings.miniPadding),
                          Builder(builder: (context) {
                            return Container(
                                width: double.infinity,
                                child: seedId == null
                                    ? SkeletonAnimation(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        shimmerColor: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .color!
                                            .withOpacity(0.3),
                                        shimmerDuration: 3000,
                                        curve: Curves.easeInOutCirc,
                                        child: Container(
                                          height: 18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.0),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.color!
                                                  .withOpacity(0.1)),
                                        ))
                                    : Card(
                                        child: Padding(
                                            padding: const EdgeInsets.all(
                                                ThemePaddings.smallPadding),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flex(
                                                      direction:
                                                          Axis.horizontal,
                                                      children: [
                                                        Flexible(
                                                            child: SelectableText(
                                                                seedId!,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!)),
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                              await Clipboard.setData(
                                                                  ClipboardData(
                                                                      text:
                                                                          seedId!));
                                                            },
                                                            icon: const Icon(
                                                                Icons.copy)),
                                                      ])
                                                ]))));
                          }),
                          const SizedBox(height: ThemePaddings.smallPadding),
                          const SizedBox(height: ThemePaddings.normalPadding),
                          Container(
                              color: Colors.white,
                              child: seedId != null
                                  ? QrImageView(
                                      data: seedId!,
                                      version: QrVersions.auto,
                                      backgroundColor: Colors.white,
                                      eyeStyle: QrEyeStyle(
                                          eyeShape: QrEyeShape.square,
                                          color: Colors.red.shade900),
                                      dataModuleStyle: QrDataModuleStyle(
                                          dataModuleShape:
                                              QrDataModuleShape.square,
                                          color: Colors.red.shade900),
                                      errorCorrectionLevel:
                                          QrErrorCorrectLevel.H,
                                      embeddedImage: const AssetImage(
                                          'assets/images/logo.png'),
                                      embeddedImageStyle:
                                          const QrEmbeddedImageStyle(
                                        size: Size(80, 80),
                                      ),
                                      padding: const EdgeInsets.all(
                                          ThemePaddings.normalPadding))
                                  : SkeletonAnimation(
                                      borderRadius: BorderRadius.circular(2.0),
                                      shimmerColor: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .color!
                                          .withOpacity(0.3),
                                      shimmerDuration: 3000,
                                      curve: Curves.easeInOutCirc,
                                      child: Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.color!
                                                .withOpacity(0.1)),
                                      ))),
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
