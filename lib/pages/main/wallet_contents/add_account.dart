import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/copy_to_clipboard.dart';
import 'package:qubic_wallet/helpers/id_validators.dart';
import 'package:qubic_wallet/helpers/platform_helpers.dart';
import 'package:qubic_wallet/helpers/random.dart';
import 'package:qubic_wallet/helpers/show_alert_dialog.dart';
import 'package:qubic_wallet/helpers/global_snack_bar.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/add_account_warning.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/add_account_warning_sheet.dart';
import 'package:qubic_wallet/resources/qubic_cmd.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qubic_wallet/styles/edgeInsets.dart';
import 'package:qubic_wallet/styles/inputDecorations.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
import 'package:qubic_wallet/timed_controller.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddAccountState createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final QubicCmd qubicCmd = getIt<QubicCmd>();
  final GlobalSnackBar _globalSnackBar = getIt<GlobalSnackBar>();

  bool detected = false;
  bool generatingId = false;

  String? generatedPublicId;
  @override
  void initState() {
    super.initState();
    qubicCmd.initialize();
  }

  @override
  void dispose() {
    super.dispose();
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
                      _globalSnackBar.show(
                          "Successfully scanned QR Code", true);
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
                    child: Padding(
                        padding:
                            const EdgeInsets.all(ThemePaddings.normalPadding),
                        child: Text(
                            "Please point the camera to a QR Code containing the private seed",
                            style: TextStyles.assetSecondaryTextLabel,
                            textAlign: TextAlign.center))))
          ]);
        });
  }

  Widget getScrollView() {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Row(children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ThemedControls.pageHeader(headerText: "Add new account"),
              ThemedControls.spacerVerticalSmall(),
              Row(children: [
                Text("Account name", style: TextStyles.labelTextNormal),
                ThemedControls.spacerHorizontalSmall(),
                Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    message:
                        "An account name is a human-readable name that you can use to identify your Qubic ID in the wallet. It can be changed at any time.",
                    child: Image.asset("assets/images/question-active-16.png")),
              ]),
              ThemedControls.spacerVerticalMini(),
              FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: "accountName",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          CustomFormFieldValidators.isNameAvailable(
                              currentQubicIDs: appStore.currentQubicIDs)
                        ]),
                        readOnly: isLoading,
                        style: TextStyles.inputBoxSmallStyle,
                        decoration: ThemeInputDecorations.normalInputbox
                            .copyWith(hintText: "Choose a name"),
                        autocorrect: false,
                        autofillHints: null,
                      ),
                      ThemedControls.spacerVerticalNormal(),
                      Row(children: [
                        Text("Private seed", style: TextStyles.labelTextNormal),
                        ThemedControls.spacerHorizontalSmall(),
                        Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message:
                                "A seed is made by 55 lowercase letters and is used to generate your Qubic Address. It is recommended to make it as random as possible. Always keep it secret and never share with anyone",
                            child: Image.asset(
                                "assets/images/question-active-16.png")),
                        Expanded(child: Container()),
                        ThemedControls.transparentButtonSmall(
                            onPressed: () {
                              if (generatingId) {
                                return null;
                              }
                              FocusManager.instance.primaryFocus?.unfocus();

                              var seed = getRandomSeed();
                              privateSeed.text = seed;
                            },
                            text: "Create random",
                            icon: LightThemeColors.shouldInvertIcon
                                ? ThemedControls.invertedColors(
                                    child: Image.asset(
                                        "assets/images/private seed-16.png"))
                                : Image.asset(
                                    "assets/images/private seed-16.png"))
                      ]),
                      FormBuilderTextField(
                        name: "privateSeed",
                        readOnly: isLoading,
                        controller: privateSeed,
                        enableSuggestions: false,
                        keyboardType: TextInputType.visiblePassword,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          CustomFormFieldValidators.isSeed(),
                          CustomFormFieldValidators.isPublicIdAvailable(
                              currentQubicIDs: appStore.currentQubicIDs)
                        ]),
                        onChanged: (value) async {
                          var v = CustomFormFieldValidators.isSeed();
                          if (value != null &&
                              value.trim().isNotEmpty &&
                              v(value) == null) {
                            try {
                              setState(() {
                                generatingId = true;
                              });
                              var newId =
                                  await qubicCmd.getPublicIdFromSeed(value);
                              setState(() {
                                generatedPublicId = newId;
                                generatingId = false;
                              });
                            } catch (e) {
                              if (e
                                  .toString()
                                  .startsWith("Exception: CRITICAL:")) {
                                print("CRITICAL");

                                showAlertDialog(
                                    context,
                                    "TAMPERED WALLET DETECTED",
                                    "THE WALLET YOU ARE CURRENTLY USING IS TAMPERED.\n\nINSTALL AN OFFICIAL VERSION FROM QUBIC-HUB.COM OR RISK LOSS OF FUNDS");
                              }
                              setState(() {
                                privateSeed.value = TextEditingValue.empty;
                                generatedPublicId = null;
                              });
                            }
                            return;
                          }
                          setState(() {
                            generatedPublicId = null;
                          });
                        },
                        maxLines: 2,
                        style: TextStyles.inputBoxSmallStyle,
                        maxLength: 55,
                        enabled: !generatingId,
                        decoration: ThemeInputDecorations
                            .normalMultiLineInputbox
                            .copyWith(
                                hintText: "Keep the private seed secret",
                                suffixIcon: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right:
                                                  ThemePaddings.smallPadding),
                                          child: IconButton(
                                              onPressed: () async {
                                                if ((_formKey.currentState
                                                                ?.instantValue[
                                                            "privateSeed"]
                                                        as String)
                                                    .trim()
                                                    .isEmpty) {
                                                  return;
                                                }
                                                copyToClipboard(_formKey
                                                        .currentState
                                                        ?.instantValue[
                                                    "privateSeed"]);
                                              },
                                              icon: LightThemeColors
                                                      .shouldInvertIcon
                                                  ? ThemedControls.invertedColors(
                                                      child: Image.asset(
                                                          "assets/images/Group 2400.png"))
                                                  : Image.asset(
                                                      "assets/images/Group 2400.png")))
                                    ])),
                        autocorrect: false,
                        autofillHints: null,
                      ),
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
                      ThemedControls.spacerVerticalNormal(),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              "Please backup your seed in a safe safe place.\nKeep it a secret and do not share with anyone.",
                              style: TextStyles.assetSecondaryTextLabel)),
                      const SizedBox(height: ThemePaddings.normalPadding),
                      Builder(builder: (context) {
                        return ThemedControls.card(
                            child: Flex(direction: Axis.horizontal, children: [
                          Flexible(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text("Qubic Address (Public ID)",
                                    style: TextStyles.labelTextNormal.copyWith(
                                        color: LightThemeColors
                                            .secondaryTypography)),
                                ThemedControls.spacerVerticalMini(),
                                generatedPublicId == null
                                    ? Text(
                                        "Please provide a valid private seed",
                                        style: TextStyles.textNormal.copyWith(
                                            fontStyle: FontStyle.italic))
                                    : SelectableText(generatedPublicId!,
                                        style: TextStyles.textNormal)
                              ])),
                          generatedPublicId == null
                              ? Container()
                              : IconButton(
                                  onPressed: () async {
                                    if (generatedPublicId == null) {
                                      return;
                                    }
                                    copyToClipboard(generatedPublicId!);
                                  },
                                  icon: LightThemeColors.shouldInvertIcon
                                      ? ThemedControls.invertedColors(
                                          child: Image.asset(
                                              "assets/images/Group 2400.png"))
                                      : Image.asset(
                                          "assets/images/Group 2400.png"))
                        ]));
                      })
                    ],
                  ))
            ],
          ))
        ]));
  }

  List<Widget> getButtons() {
    return [
      Expanded(
          child: !isLoading
              ? ThemedControls.transparentButtonBigWithChild(
                  child: Padding(
                      padding: const EdgeInsets.all(ThemePaddings.smallPadding),
                      child: Text("Cancel",
                          style: TextStyles.transparentButtonText)),
                  onPressed: () {
                    Navigator.pop(context);
                  })
              : Container()),
      ThemedControls.spacerHorizontalNormal(),
      Expanded(
          child: ThemedControls.primaryButtonBigWithChild(
              onPressed: saveIdHandler,
              child: Padding(
                  padding: const EdgeInsets.all(ThemePaddings.smallPadding + 3),
                  child: Text("Save",
                      textAlign: TextAlign.center,
                      style: TextStyles.primaryButtonText))))
    ];
  }

  void saveIdHandler() async {
    _formKey.currentState?.validate();
    if (generatingId) {
      return;
    }
    if (!_formKey.currentState!.isValid) {
      return;
    }

    //Prevent duplicates
    if (appStore.currentQubicIDs
        .where(((element) =>
            element.publicId == generatedPublicId!.replaceAll(",", "_")))
        .isNotEmpty) {
      _globalSnackBar.show("This ID already exists in your wallet", true);

      return;
    }

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: LightThemeColors.backkground,
        builder: (BuildContext context) {
          return AddAccountWarningSheet(onAccept: () async {
            Navigator.pop(context);
            await _saveId();
            getIt<TimedController>().interruptFetchTimer();
          }, onReject: () async {
            Navigator.pop(context);
          });
        });

    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AddAccountWarning(onAccept: () async {
    //         Navigator.pop(context);
    //         await _saveId();
    //         getIt<TimedController>().interruptFetchTimer();
    //       }, onReject: () async {
    //         Navigator.pop(context);
    //       });
    //     });
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
