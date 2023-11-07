import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qubic_wallet/components/id_list_item_select.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/globals.dart';
import 'package:qubic_wallet/helpers/id_validators.dart';
import 'package:qubic_wallet/helpers/re_auth_dialog.dart';
import 'package:qubic_wallet/helpers/sendTransaction.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/timed_controller.dart';

enum TargetTickType {
  autoCurrentPlus20,
  autoCurrentPlus40,
  autoCurrentPlus60,
  manual
}

class Send extends StatefulWidget {
  final QubicListVm item;
  const Send({super.key, required this.item});

  @override
  // ignore: library_private_types_in_public_api
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final TimedController _timedController = getIt<TimedController>();

  int targetTick = 0;
  int? frozenTargetTick;
  int? frozenCurrentTick;
  String? transferError;
  TargetTickType targetTickType = TargetTickType.autoCurrentPlus20;

  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 0,
  );

  List<bool> expanded = [false];
  List<DropdownMenuItem<TargetTickType>> tickList = [
    const DropdownMenuItem(
        value: TargetTickType.autoCurrentPlus20,
        child: Text("Automatically: Current + 20")),
    const DropdownMenuItem(
        value: TargetTickType.autoCurrentPlus40,
        child: Text("Automatically: Current + 40")),
    const DropdownMenuItem(
        value: TargetTickType.autoCurrentPlus60,
        child: Text("Automatically: Current + 60")),
    const DropdownMenuItem(
        value: TargetTickType.manual, child: Text("Manual override"))
  ];

  final CurrencyInputFormatter inputFormatter = CurrencyInputFormatter(
      trailingSymbol: "\$QUBIC",
      useSymbolPadding: true,
      thousandSeparator: ThousandSeparator.Comma,
      mantissaLength: 0);

  String? generatedPublicId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int getQubicAmount() {
    return int.parse(amount.text
        .replaceAll(",", "")
        .replaceAll(" ", "")
        .replaceAll("\$QUBIC", ""));
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showQRScanner() {
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
                    var value = destinationID.text;
                    value = barcode.rawValue!
                        .replaceAll("https://wallet.qubic.li/payment/", "");
                    var validator = CustomFormFieldValidators.isPublicID();
                    if (validator(value) == null) {
                      destinationID.text = value;
                      foundSuccess = true;
                    }
                  }

                  if (foundSuccess) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      elevation: 99,
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                          '${destinationID.text}: Successfully scanned QR Code'),
                    ));
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
                            "Please point the camera to a \$Qubic QR Code (QR Codes generated by wallet.qubic.li are also compatible)"))))
          ]);
        });
  }

  //Shows the bottom sheet allowing to select a Public ID from the wallet
  void showPickerBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(ThemePaddings.bigPadding),
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text('Select a destination from your wallet',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: ThemePaddings.bigPadding),
                  Expanded(
                    child: ListView.builder(
                        itemCount: appStore.currentQubicIDs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return appStore.currentQubicIDs[index].publicId ==
                                  widget.item.publicId
                              ? Container()
                              : InkWell(
                                  child: IdListItemSelect(
                                      item: appStore.currentQubicIDs[index]),
                                  onTap: () {
                                    destinationID.text = appStore
                                        .currentQubicIDs[index].publicId;

                                    Navigator.pop(context);
                                  },
                                );
                        }),
                  )
                ],
              ),
            )),
          );
        });
  }

  Widget getAdvancedRadio(TargetTickType type, String label) {
    return InkWell(
        onTap: () {
          setState(() {
            targetTickType = type;
          });
        },
        child: Ink(
            child: ListTile(
                dense: true,
                minVerticalPadding: ThemePaddings.miniPadding,
                subtitle: Row(children: [
                  Radio<TargetTickType>(
                      value: type,
                      groupValue: targetTickType,
                      onChanged: (TargetTickType? value) {
                        setState(() {
                          targetTickType = value ?? type;
                        });
                      }),
                  Text(label)
                ]))));
  }

  List<Widget> getOverrideTick() {
    if ((targetTickType == TargetTickType.manual) && (expanded[0] == true)) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(child: Observer(builder: (context) {
              return Text("Current (${appStore.currentTick.asThousands()})",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .titleSmall
                      ?.copyWith(
                          color: Theme.of(context).colorScheme.secondary));
            }), onPressed: () {
              if (widget.item.amount == null) {
                return;
              }
              if (widget.item.amount! > 0) {
                tickController.text = appStore.currentTick.toString();
              }
            }),
          ],
        ),
        FormBuilderTextField(
          decoration: const InputDecoration(labelText: 'Tick'),
          name: "Tick",
          readOnly: isLoading,
          controller: tickController,
          enableSuggestions: false,
          keyboardType: TextInputType.number,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ]),
          maxLines: 1,
          autocorrect: false,
          autofillHints: null,
        )
      ];
    }
    return [Container()];
  }

  Widget getAutoTick() {
    if (targetTickType != TargetTickType.manual) {
      return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: ThemePaddings.normalPadding),
            Text("Target tick",
                style: Theme.of(context).textTheme.labelMedium!),
            Observer(builder: (context) {
              int tick = 0;
              if (frozenTargetTick != null) {
                tick = frozenTargetTick!;
              } else {
                if (targetTickType == TargetTickType.autoCurrentPlus20) {
                  tick = appStore.currentTick + 20;
                }
                if (targetTickType == TargetTickType.autoCurrentPlus40) {
                  tick = appStore.currentTick + 40;
                }
                if (targetTickType == TargetTickType.autoCurrentPlus60) {
                  tick = appStore.currentTick + 60;
                }
              }
              return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: tick.asThousands(),
                        style: Theme.of(context).textTheme.titleLarge!),
                    TextSpan(
                        text:
                            " (current tick: ${frozenCurrentTick?.asThousands() ?? appStore.currentTick.asThousands()})",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontStyle: FontStyle.italic))
                  ])));
            })
          ]);
    }
    return Container();
  }

  Widget getAdvancedOptions() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Determine target tick",
              style: Theme.of(context).textTheme.labelMedium!),
          DropdownButton<TargetTickType>(
              value: targetTickType,
              elevation: 16,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              isDense: false,
              isExpanded: true,
              onChanged: (TargetTickType? value) {
                // This is called when the user selects an item.
                setState(() {
                  targetTickType = value!;
                });
              },
              items: tickList),
          Column(children: getOverrideTick()),
          getAutoTick(),
        ]);
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
              Text("Send funds from \"${widget.item.name}\"",
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
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(),
                              ]),
                          Flex(direction: Axis.horizontal, children: [
                            Expanded(
                                flex: 10,
                                child: FormBuilderTextField(
                                  name: "destinationID",
                                  readOnly: isLoading,
                                  controller: destinationID,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    CustomFormFieldValidators.isPublicID(),
                                  ]),
                                  maxLines: 3,
                                  maxLength: 60,
                                  decoration: InputDecoration(
                                      labelText: 'Destination Qubic ID',
                                      suffixIcon: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            appStore.currentQubicIDs.length > 1
                                                ? IconButton(
                                                    onPressed: () async {
                                                      showPickerBottomSheet();
                                                    },
                                                    icon:
                                                        const Icon(Icons.book))
                                                : Container(),
                                            IconButton(
                                                onPressed: () async {
                                                  showQRScanner();
                                                },
                                                icon: const Icon(Icons.qr_code))
                                          ])),
                                  autocorrect: false,
                                  autofillHints: null,
                                )),
                          ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  child: Text("All",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleSmall
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary)),
                                  onPressed: () {
                                    if (widget.item.amount == null) {
                                      return;
                                    }
                                    if (widget.item.amount! > 0) {
                                      amount.value =
                                          inputFormatter.formatEditUpdate(
                                              const TextEditingValue(text: ''),
                                              TextEditingValue(
                                                  text: (widget.item.amount)
                                                      .toString()));
                                    }
                                  }),
                              (widget.item.amount != null &&
                                      widget.item.amount! > 1)
                                  ? TextButton(
                                      child: Text("All except 1",
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary)),
                                      onPressed: () {
                                        if (widget.item.amount == null) {
                                          return;
                                        }
                                        if (widget.item.amount! > 1) {
                                          amount.value =
                                              inputFormatter.formatEditUpdate(
                                                  const TextEditingValue(
                                                      text: ''),
                                                  TextEditingValue(
                                                      text:
                                                          (widget.item.amount! -
                                                                  1)
                                                              .toString()));
                                        }
                                      })
                                  : Container()
                            ],
                          ),
                          FormBuilderTextField(
                            decoration:
                                const InputDecoration(labelText: 'Amount'),
                            name: "Amount",
                            readOnly: isLoading,
                            controller: amount,
                            enableSuggestions: false,
                            textAlign: TextAlign.end,
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              CustomFormFieldValidators.isLessThanParsed(
                                  lessThan: widget.item.amount!),
                            ]),
                            inputFormatters: [inputFormatter],
                            maxLines: 1,
                            autocorrect: false,
                            autofillHints: null,
                          ),
                          const SizedBox(height: ThemePaddings.miniPadding),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Balance in ID: ${formatter.format(widget.item.amount)} \$QUBIC",
                                    style:
                                        Theme.of(context).textTheme.bodySmall!),
                              ]),
                          const SizedBox(height: ThemePaddings.bigPadding),
                          ExpansionPanelList(
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  expanded[index] = !isExpanded;
                                });
                              },
                              children: [
                                ExpansionPanel(
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return const ListTile(
                                      title: Text('Advanced options'),
                                    );
                                  },
                                  body: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        ThemePaddings.normalPadding,
                                        0,
                                        ThemePaddings.normalPadding,
                                        ThemePaddings.normalPadding,
                                      ),
                                      child: getAdvancedOptions()),
                                  isExpanded: expanded[0],
                                )
                              ])
                        ],
                      ))),
              const SizedBox(height: ThemePaddings.normalPadding),
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
      FilledButton(
          onPressed: transferNowHandler,
          child: SizedBox(
              width: 120,
              child: !isLoading
                  ? const Text("TRANSFER NOW")
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(52, 0, 52, 0),
                      child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary)))))
    ];
  }

  void transferNowHandler() async {
    _formKey.currentState?.validate();
    if (!_formKey.currentState!.isValid) {
      return;
    }

    bool authenticated = await reAuthDialog(context);
    if (!authenticated) {
      return;
    }

    //Make sure that current tick is not in the past

    setState(() {
      isLoading = true;

      frozenCurrentTick = appStore.currentTick;
      if (targetTickType == TargetTickType.manual) {
        frozenTargetTick = int.tryParse(tickController.text);
      } else if (targetTickType == TargetTickType.autoCurrentPlus20) {
        frozenTargetTick = frozenCurrentTick! + 20;
      } else if (targetTickType == TargetTickType.autoCurrentPlus40) {
        frozenTargetTick = frozenCurrentTick! + 40;
      } else if (targetTickType == TargetTickType.autoCurrentPlus60) {
        frozenTargetTick = frozenCurrentTick! + 60;
      }
    });

    bool result = await sendTransactionDialog(context, widget.item.publicId,
        destinationID.text, getQubicAmount(), frozenTargetTick!);
    if (!result) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    await _timedController.interruptFetchTimer();

    //Clear the state
    setState(() {
      isLoading = false;
      frozenCurrentTick = null;
      frozenTargetTick = null;
    });

    Navigator.pop(context);
    //Timer(const Duration(seconds: 1), () => Navigator.pop(context));

    snackbarKey.currentState?.showSnackBar(const SnackBar(
      elevation: 99,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      content: Text("Submitted new transaction to Qubic network"),
    ));

    setState(() {
      isLoading = false;
    });
  }

  TextEditingController destinationID = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController tickController = TextEditingController();

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
