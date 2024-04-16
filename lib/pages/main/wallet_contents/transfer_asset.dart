import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/id_list_item_select.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/qubic_asset_dto.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/id_validators.dart';
import 'package:qubic_wallet/helpers/platform_helpers.dart';
import 'package:qubic_wallet/helpers/re_auth_dialog.dart';
import 'package:qubic_wallet/helpers/sendTransaction.dart';
import 'package:qubic_wallet/helpers/global_snack_bar.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/styles/edgeInsets.dart';
import 'package:qubic_wallet/styles/inputDecorations.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
import 'package:qubic_wallet/timed_controller.dart';

enum TargetTickType {
  autoCurrentPlus20,
  autoCurrentPlus40,
  autoCurrentPlus60,
  manual
}

class TransferAsset extends StatefulWidget {
  final QubicListVm item;
  final QubicAssetDto asset;
  const TransferAsset({super.key, required this.item, required this.asset});

  @override
  // ignore: library_private_types_in_public_api
  _TransferAssetState createState() => _TransferAssetState();
}

class _TransferAssetState extends State<TransferAsset> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final TimedController _timedController = getIt<TimedController>();
  final GlobalKey<_TransferAssetState> widgetKey = GlobalKey();
  final GlobalSnackBar _globalSnackBar = getIt<GlobalSnackBar>();
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

  late final CurrencyInputFormatter inputFormatter;

  String? generatedPublicId;

  @override
  void initState() {
    transactionCostCtrl.text = "1,000,000 \$QUBIC";

    inputFormatter = CurrencyInputFormatter(
        trailingSymbol:
            "${widget.asset.assetName} ${QubicAssetDto.isSmartContractShare(widget.asset) ? "shares" : "tokens"}",
        useSymbolPadding: true,
        maxTextLength: 3,
        thousandSeparator: ThousandSeparator.Comma,
        mantissaLength: 0);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int getAssetAmount() {
    return int.parse(numberOfSharesCtrl.text
        .substring(0, numberOfSharesCtrl.text.indexOf(" "))
        .replaceAll(" ", "")
        .replaceAll(",", ""));
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
                bool foundSuccess = false;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    var value = destinationID.text;
                    value = barcode.rawValue!
                        .replaceAll("https://wallet.qubic.li/payment/", "");
                    var validator = CustomFormFieldValidators.isPublicID();
                    if (validator(value) == null) {
                      if (foundSuccess == true) {
                        break;
                      }
                      destinationID.text = value;
                      foundSuccess = true;
                    }
                  }
                }
                if (foundSuccess) {
                  Navigator.pop(context);
                  _globalSnackBar.show("Successfully scanned QR Code");
                }
              },
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: Colors.white60,
                    width: double.infinity,
                    child: Padding(
                        padding:
                            const EdgeInsets.all(ThemePaddings.normalPadding),
                        child: Text(
                            "Please point the camera to a \$Qubic QR Code \n(QR Codes generated by wallet.qubic.li are also compatible)",
                            style: TextStyles.assetSecondaryTextLabel,
                            textAlign: TextAlign.center))))
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
              padding: const EdgeInsets.all(0),
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(
                          ThemePaddings.bigPadding,
                          ThemePaddings.normalPadding,
                          ThemePaddings.bigPadding,
                          0),
                      child: ThemedControls.pageHeader(
                          headerText: "Select address",
                          subheaderText: "from your wallet accounts")),
                  Expanded(
                    child: ListView.builder(
                        itemCount: appStore.currentQubicIDs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return appStore.currentQubicIDs[index].publicId ==
                                  widget.item.publicId
                              ? Container()
                              : InkWell(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: ThemePaddings.bigPadding,
                                          vertical: ThemePaddings.smallPadding),
                                      child: IdListItemSelect(
                                          item:
                                              appStore.currentQubicIDs[index])),
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
        ThemedControls.spacerVerticalSmall(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Text("Tick", style: TextStyles.labelTextNormal)),
            ThemedControls.transparentButtonBigWithChild(
                child: Observer(builder: (context) {
              return Text("Current (${appStore.currentTick.asThousands()})",
                  style: TextStyles.transparentButtonTextSmall);
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
          decoration: ThemeInputDecorations.normalInputbox,
          name: "Tick",
          readOnly: isLoading,
          controller: tickController,
          enableSuggestions: false,
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
            ThemedControls.spacerVerticalNormal(),
            ThemedControls.spacerVerticalNormal(),
            Text("Target tick", style: TextStyles.labelTextNormal),
            ThemedControls.spacerVerticalMini(),
            ThemedControls.inputboxlikeLabel(
                child: Observer(builder: (context) {
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
                        style: TextStyles.inputBoxNormalStyle),
                    TextSpan(
                        text:
                            " (current tick: ${frozenCurrentTick?.asThousands() ?? appStore.currentTick.asThousands()})",
                        style: TextStyles.inputBoxSmallStyle)
                  ])));
            }))
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
          Text("Determine target tick", style: TextStyles.labelTextNormal),
          ThemedControls.spacerVerticalMini(),
          ThemedControls.dropdown<TargetTickType>(
              value: targetTickType,
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

  Widget getDestinationQubicId() {
    return FormBuilderTextField(
      name: "destinationID",
      readOnly: isLoading,
      controller: destinationID,
      enableSuggestions: false,
      keyboardType: TextInputType.visiblePassword,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        CustomFormFieldValidators.isPublicID(),
      ]),
      maxLines: 2,
      style: TextStyles.inputBoxSmallStyle,
      maxLength: 60,
      decoration: ThemeInputDecorations.normalMultiLineInputbox.copyWith(
          hintText: "",
          hintMaxLines: 3,
          // This line is the one that causes the error
          suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                appStore.currentQubicIDs.length > 1
                    ? IconButton(
                        onPressed: () async {
                          showPickerBottomSheet();
                        },
                        icon: Image.asset("assets/images/bookmark-24.png"))
                    //const Icon(Icons.book))
                    : Container(),
                ThemedControls.spacerHorizontalMini()
              ])),
      autocorrect: false,
      autofillHints: null,
    );
  }

  Widget getPredefinedAmountOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ThemedControls.transparentButtonSmall(
            text: "Max",
            onPressed: () {
              if (widget.asset.ownedAmount == null) {
                return;
              }
              if (widget.asset.ownedAmount! > 0) {
                numberOfSharesCtrl.value = inputFormatter.formatEditUpdate(
                    const TextEditingValue(text: ''),
                    TextEditingValue(
                        text: (widget.asset.ownedAmount).toString()));
              }
            }),
        (widget.asset.ownedAmount != null && widget.asset.ownedAmount! > 1)
            ? ThemedControls.transparentButtonSmall(
                text: "Max - 1",
                onPressed: () {
                  if (widget.asset.ownedAmount == null) {
                    return;
                  }
                  if (widget.asset.ownedAmount! > 1) {
                    numberOfSharesCtrl.value = inputFormatter.formatEditUpdate(
                        const TextEditingValue(text: ''),
                        TextEditingValue(
                            text: (widget.asset.ownedAmount! - 1).toString()));
                  }
                })
            : Container()
      ],
    );
  }

  Widget getAmountBox() {
    return FormBuilderTextField(
      decoration:
          ThemeInputDecorations.normalInputbox.copyWith(hintMaxLines: 1),
      name: "Amount",
      readOnly: isLoading,
      controller: numberOfSharesCtrl,
      enableSuggestions: false,
      textAlign: TextAlign.end,
      keyboardType: TextInputType.number,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        CustomFormFieldValidators.isLessThanParsedAsset(
          lessThan:
              widget.asset.ownedAmount != null ? widget.asset.ownedAmount! : 0,
        ),
      ]),
      inputFormatters: [inputFormatter],
      maxLines: 1,
      autocorrect: false,
      autofillHints: null,
    );
  }

  Widget getOwnershipInfo() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              "${widget.asset.assetName}${QubicAssetDto.isSmartContractShare(widget.asset) ? " shares" : " Tokens"} owned by ID: ${formatter.format(widget.asset.ownedAmount)}",
              style: Theme.of(context).textTheme.bodySmall!),
        ]);
  }

  Widget getTotalQubicInfo() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Balance in ID: ${formatter.format(widget.item.amount)} \$QUBIC",
              style: Theme.of(context).textTheme.bodySmall!)
        ]);
  }

  Widget getCostInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text("Transaction cost (fixed)", style: TextStyles.labelTextNormal),
      ThemedControls.spacerVerticalMini(),
      ThemedControls.inputboxlikeLabel(
          child: Text(transactionCostCtrl.text,
              textAlign: TextAlign.center,
              style: TextStyles.inputBoxNormalStyle
                  .copyWith(fontWeight: FontWeight.w500))),
      ThemedControls.spacerVerticalMini(),
      getTotalQubicInfo()
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
              ThemedControls.pageHeader(
                  headerText:
                      "Transfer ${widget.asset.assetName} ${QubicAssetDto.isSmartContractShare(widget.asset) ? "shares" : "tokens"}",
                  subheaderText: "from \"${widget.item.name}\""),
              ThemedControls.spacerVerticalSmall(),
              Text("Destination address", style: TextStyles.labelTextNormal),
              ThemedControls.spacerVerticalMini(),
              FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      getDestinationQubicId(),
                      if (isMobile)
                        Align(
                            alignment: Alignment.topLeft,
                            child: ThemedControls.primaryButtonNormal(
                                onPressed: () {
                                  showQRScanner();
                                },
                                text: "Use QR Code",
                                icon: ThemedControls.invertedColors(
                                    child: Image.asset(
                                        "assets/images/Group 2294.png")))),
                      ThemedControls.spacerVerticalMini(),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Expanded(
                            child: Text("Number of shares",
                                style: TextStyles.labelTextNormal)),
                        getPredefinedAmountOptions()
                      ]),
                      getAmountBox(),
                      ThemedControls.spacerVerticalMini(),
                      getOwnershipInfo(),
                      ThemedControls.spacerVerticalBig(),
                      getCostInfo(),
                      ThemedControls.spacerVerticalBig(),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Material(
                              elevation: 0,
                              borderOnForeground: false,
                              shadowColor: Colors.transparent,
                              child: ExpansionPanelList(
                                  elevation: 0,
                                  expansionCallback:
                                      (int index, bool isExpanded) {
                                    setState(() {
                                      expanded[index] = !isExpanded;
                                    });
                                  },
                                  children: [
                                    ExpansionPanel(
                                      canTapOnHeader: true,
                                      backgroundColor:
                                          LightThemeColors.cardBackground,
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
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
                                  ])))
                    ],
                  )),
              const SizedBox(height: ThemePaddings.normalPadding),
            ],
          )))
        ]));
  }

  List<Widget> getButtons() {
    return [
      !isLoading
          ? Expanded(
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CANCEL",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ))))
          : Container(),
      ThemedControls.spacerHorizontalNormal(),
      Expanded(
          child: FilledButton(
              onPressed: transferNowHandler,
              child: SizedBox(
                  width: 130,
                  child: !isLoading
                      ? const SizedBox(
                          width: double.infinity,
                          child:
                              Text("TRANSFER NOW", textAlign: TextAlign.center))
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(57, 0, 57, 0),
                          child: SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary))))))
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

    bool result = await sendAssetTransferTransactionDialog(
        context,
        widget.item.publicId,
        destinationID.text,
        widget.asset.assetName,
        widget.asset.issuerIdentity,
        getAssetAmount(),
        frozenTargetTick!);

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
      getIt.get<PersistentTabController>().jumpToTab(1);
    });

    Navigator.pop(context);
    //Timer(const Duration(seconds: 1), () => Navigator.pop(context));

    _globalSnackBar.show("Submitted transaction to Qubic network");

    setState(() {
      isLoading = false;
    });
  }

  TextEditingController destinationID = TextEditingController();
  TextEditingController numberOfSharesCtrl = TextEditingController();
  TextEditingController transactionCostCtrl = TextEditingController();
  TextEditingController tickController = TextEditingController();

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
                minimum: ThemeEdgeInsets.pageInsets
                    .copyWith(bottom: ThemePaddings.normalPadding),
                child: Column(children: [
                  Expanded(child: getScrollView()),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: getButtons())
                ]))));
  }
}
