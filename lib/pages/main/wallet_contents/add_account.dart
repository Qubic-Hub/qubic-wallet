import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/id_validators.dart';
import 'package:qubic_wallet/helpers/random.dart';
import 'package:qubic_wallet/helpers/show_alert_dialog.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/add_account_warning.dart';
import 'package:qubic_wallet/resources/qubic_js.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddAccountState createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final QubicJs qubicJs = QubicJs();

  bool detected = false;

  String? generatedPublicId;
  @override
  void initState() {
    super.initState();
    qubicJs.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    qubicJs.disposeController();
  }

  void showQRScanner() {
    detected = false;
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          bool foundSuccess = false;
          return Stack(children: [
            MobileScanner(
              // fit: BoxFit.contain,
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.normal,
                facing: CameraFacing.back,
                torchEnabled: false,
              ),

              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;

                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    var validator = CustomFormFieldValidators.isSeed();
                    if (validator(barcode.rawValue) == null) {
                      privateSeed.text = barcode.rawValue!;
                      foundSuccess = true;
                    }
                  }

                  if (foundSuccess) {
                    if (!detected) {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        elevation: 99,
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        content: Text('Successfully scanned QR Code'),
                      ));
                    }
                    detected = true;
                  }
                }
              },
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: Colors.white60,
                    width: double.infinity,
                    child: const Padding(
                        padding: EdgeInsets.all(ThemePaddings.normalPadding),
                        child: Text(
                            "Please point the camera to a QR Code containing the private seed"))))
          ]);
        });
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
              Text("Add new Qubic ID",
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
                          Flex(direction: Axis.horizontal, children: [
                            Expanded(
                                flex: 10,
                                child: FormBuilderTextField(
                                  name: "accountName",
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    CustomFormFieldValidators.isNameAvailable(
                                        currentQubicIDs:
                                            appStore.currentQubicIDs)
                                  ]),
                                  readOnly: isLoading,
                                  decoration: const InputDecoration(
                                    labelText: 'Account name',
                                  ),
                                  autocorrect: false,
                                  autofillHints: null,
                                )),
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                onPressed: () => {
                                  setState(() {
                                    showAccountInfoTooltip =
                                        !showAccountInfoTooltip;
                                  })
                                },
                                tooltip: 'Tap for help',
                                color: showAccountInfoTooltip
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                icon: const Icon(Icons.help_outline),
                              ),
                            ),
                          ]),
                          Builder(builder: (context) {
                            if (showAccountInfoTooltip) {
                              return const Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                      "An account name is a human-readable name that you can use to identify your Qubic ID in the wallet. It can be changed at any time."));
                            } else {
                              return Container();
                            }
                          }),
                          const SizedBox(height: ThemePaddings.normalPadding),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(),
                                TextButton(
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      var seed = getRandomSeed();
                                      privateSeed.text = seed;
                                    },
                                    child: Text("Create random",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleSmall
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)))
                              ]),
                          Flex(direction: Axis.horizontal, children: [
                            Expanded(
                                flex: 10,
                                child: FormBuilderTextField(
                                  name: "privateSeed",
                                  readOnly: isLoading,
                                  controller: privateSeed,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    CustomFormFieldValidators.isSeed(),
                                    CustomFormFieldValidators
                                        .isPublicIdAvailable(
                                            currentQubicIDs:
                                                appStore.currentQubicIDs)
                                  ]),
                                  onChanged: (value) async {
                                    var v = CustomFormFieldValidators.isSeed();
                                    if (value != null &&
                                        value.trim().isNotEmpty &&
                                        v(value) == null) {
                                      try {
                                        var newId = await qubicJs
                                            .getPublicIdFromSeed(value);
                                        setState(() {
                                          generatedPublicId = newId;
                                        });
                                      } catch (e) {
                                        if (e.toString().startsWith(
                                            "Exception: CRITICAL:")) {
                                          print("CRITICAL");

                                          showAlertDialog(
                                              context,
                                              "TAMPERED WALLET DETECTED",
                                              "THE WALLET YOU ARE CURRENTLY USING IS TAMPERED.\n\nINSTALL AN OFFICIAL VERSION FROM QUBIC-HUB.COM OR RISK LOSS OF FUNDS");
                                        }
                                        setState(() {
                                          privateSeed.value =
                                              TextEditingValue.empty;
                                          generatedPublicId = null;
                                        });
                                      }
                                      return;
                                    }
                                    setState(() {
                                      generatedPublicId = null;
                                    });
                                  },
                                  maxLines: 3,
                                  maxLength: 55,
                                  decoration: InputDecoration(
                                      labelText: 'Private seed',
                                      suffixIcon: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  showQRScanner();
                                                },
                                                icon:
                                                    const Icon(Icons.qr_code)),
                                            IconButton(
                                                onPressed: () async {
                                                  if ((_formKey.currentState
                                                                  ?.instantValue[
                                                              "privateSeed"]
                                                          as String)
                                                      .trim()
                                                      .isEmpty) {
                                                    return;
                                                  }
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                          text: _formKey
                                                                  .currentState
                                                                  ?.instantValue[
                                                              "privateSeed"]));
                                                },
                                                icon: const Icon(Icons.copy))
                                          ])),
                                  autocorrect: false,
                                  autofillHints: null,
                                )),
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                onPressed: () => {
                                  setState(() {
                                    showSeedInfoTooltip = !showSeedInfoTooltip;
                                  })
                                },
                                tooltip: 'Tap for help',
                                color: showSeedInfoTooltip
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                icon: const Icon(Icons.help_outline),
                              ),
                            ),
                          ]),
                          Builder(builder: (context) {
                            if ((showSeedInfoTooltip)) {
                              return const Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Column(children: [
                                    Text(
                                        "A seed is made by 55 lowercase letters and is used to generate your Qubic ID. It is recommended to make it as random as possible. Always keep it secret as it is used to issue transactions. "),
                                  ]));
                            } else {
                              return Container();
                            }
                          }),
                          const SizedBox(height: ThemePaddings.miniPadding),
                          Text(
                              "Please backup your seed in a safe safe place.\nDO NOT SHARE YOUR SEED WITH ANYONE",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic)),
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
                                              Text("Generated Public ID",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.color!
                                                              .withAlpha(200))),
                                              Flex(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Flexible(
                                                        child: generatedPublicId ==
                                                                null
                                                            ? Text(
                                                                "Please provide a valid private seed",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic))
                                                            : SelectableText(
                                                                generatedPublicId!,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!)),
                                                    generatedPublicId == null
                                                        ? Container()
                                                        : IconButton(
                                                            onPressed:
                                                                () async {
                                                              if (generatedPublicId ==
                                                                  null) {
                                                                return;
                                                              }
                                                              await Clipboard.setData(
                                                                  ClipboardData(
                                                                      text: _formKey
                                                                          .currentState
                                                                          ?.instantValue["privateSeed"]));
                                                            },
                                                            icon: const Icon(
                                                                Icons.copy))
                                                  ])
                                            ]))));
                          })
                        ],
                      )))
            ],
          )))
        ]));
  }

  List<Widget> getButtons() {
    return [
      !isLoading
          ? TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CANCEL",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      )))
          : Container(),
      FilledButton(onPressed: saveIdHandler, child: const Text("SAVE NEW ID"))
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        elevation: 99,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        content: Text('This ID already exists in your wallet'),
      ));
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AddAccountWarning(onAccept: () async {
            Navigator.pop(context);
            await _saveId();
          });
        });
  }

  Future<void> _saveId() async {
    setState(() {
      isLoading = true;
    });
    await appStore.addId(
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: getButtons())
                ]))));
  }
}
