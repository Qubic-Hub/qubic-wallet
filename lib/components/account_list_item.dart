import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/amount_formatted.dart';
import 'package:qubic_wallet/components/copyable_text.dart';
import 'package:qubic_wallet/components/currency_amount.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/qubic_asset.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/id_validators.dart';
import 'package:qubic_wallet/helpers/re_auth_dialog.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/assets.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/receive.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/reveal_seed/reveal_seed.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/reveal_seed/reveal_seed_warning_sheet.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/send.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/transfers/transactions_for_id.dart';
import 'package:qubic_wallet/smart_contracts/sc_info.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/inputDecorations.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

enum CardItem { delete, rename, reveal, viewTransactions, viewInExplorer }

class AccountListItem extends StatelessWidget {
  final QubicListVm item;
  final _formKey = GlobalKey<FormBuilderState>();

  AccountListItem({super.key, required this.item});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  showRenameDialog(BuildContext context) {
    late BuildContext dialogContext;

    // set up the buttons
    Widget cancelButton = ThemedControls.transparentButtonNormal(
        onPressed: () {
          Navigator.pop(dialogContext);
        },
        text: "Cancel");

    Widget continueButton = ThemedControls.primaryButtonNormal(
      text: "Rename",
      onPressed: () {
        if (_formKey.currentState?.instantValue["accountName"] == item.name) {
          Navigator.pop(dialogContext);
          return;
        }

        _formKey.currentState?.validate();
        if (!_formKey.currentState!.isValid) {
          return;
        }

        appStore.setName(
            item.publicId, _formKey.currentState?.instantValue["accountName"]);

        //appStore.removeID(item.publicId);
        Navigator.pop(dialogContext);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Rename Qubic ID", style: TextStyles.alertHeader),
      content: FormBuilder(
          key: _formKey,
          child: SizedBox(
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormBuilderTextField(
                    name: 'accountName',
                    initialValue: item.name,
                    decoration: ThemeInputDecorations.normalInputbox.copyWith(
                      hintText: "New name",
                    ),
                    style: TextStyles.inputBoxNormalStyle,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      CustomFormFieldValidators.isNameAvailable(
                          currentQubicIDs: appStore.currentQubicIDs,
                          ignorePublicId: item.name)
                    ]),
                  ),
                ],
              ))),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return alert;
      },
    );
  }

  showRemoveDialog(BuildContext context) {
    late BuildContext dialogContext;

    // set up the buttons
    Widget cancelButton = ThemedControls.transparentButtonNormal(
        onPressed: () {
          Navigator.pop(dialogContext);
        },
        text: "Cancel");

    Widget continueButton = ThemedControls.primaryButtonNormal(
      text: "Yes",
      onPressed: () async {
        await appStore.removeID(item.publicId);
        Navigator.pop(dialogContext);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove Qubic ID", style: TextStyles.alertHeader),
      content: Text(
          "Are you sure you want to remove this Qubic ID from your wallet? (Any funds associated with this ID will not be removed)\n\nMAKE SURE YOU HAVE A BACKUP OF YOUR PRIVATE SEED BEFORE REMOVING THIS ID!",
          style: TextStyles.alertText),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return alert;
      },
    );
  }

  Widget getCardMenu(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            menuTheme: MenuThemeData(
                style: MenuStyle(
          surfaceTintColor:
              MaterialStateProperty.all(LightThemeColors.cardBackground),
          elevation: MaterialStateProperty.all(50),
          backgroundColor:
              MaterialStateProperty.all(LightThemeColors.cardBackground),
        ))),
        child: PopupMenuButton<CardItem>(
            tooltip: "",
            icon: Icon(Icons.more_horiz,
                color: LightThemeColors.primary.withAlpha(140)),
            // Callback that sets the selected popup menu item.
            onSelected: (CardItem menuItem) async {
              // setState(() {
              //   selectedMenu = item;
              // });
              if (menuItem == CardItem.rename) {
                showRenameDialog(context);
              }

              if (menuItem == CardItem.delete) {
                showRemoveDialog(context);
              }

              if (menuItem == CardItem.viewInExplorer) {
                pushNewScreen(
                  context,
                  screen: ExplorerResultPage(
                    resultType: ExplorerResultType.publicId,
                    qubicId: item.publicId,
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }

              if (menuItem == CardItem.viewTransactions) {
                pushNewScreen(
                  context,
                  screen: TransactionsForId(publicQubicId: item.publicId),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }

              if (menuItem == CardItem.reveal) {
                showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    backgroundColor: LightThemeColors.backkground,
                    builder: (BuildContext context) {
                      return RevealSeedWarningSheet(
                          item: item,
                          onAccept: () async {
                            if (await reAuthDialog(context) == false) {
                              Navigator.pop(context);
                              return;
                            }
                            Navigator.pop(context);
                            pushNewScreen(
                              context,
                              screen: RevealSeed(item: item),
                              withNavBar:
                                  false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          onReject: () async {
                            Navigator.pop(context);
                          });
                    });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<CardItem>>[
                  const PopupMenuItem<CardItem>(
                    value: CardItem.viewTransactions,
                    child: Text('View transfers'),
                  ),
                  PopupMenuItem<CardItem>(
                    value: CardItem.viewInExplorer,
                    child: Text('View in explorer'),
                    enabled: item.amount != null && item.amount! > 0,
                  ),
                  const PopupMenuItem<CardItem>(
                    value: CardItem.reveal,
                    child: Text('Reveal private seed'),
                  ),
                  const PopupMenuItem<CardItem>(
                    value: CardItem.rename,
                    child: Text('Rename'),
                  ),
                  const PopupMenuItem<CardItem>(
                    value: CardItem.delete,
                    child: Text('Delete'),
                  ),
                ]));
  }

  Widget getButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      buttonPadding: const EdgeInsets.fromLTRB(ThemeFontSizes.large,
          ThemeFontSizes.large, ThemeFontSizes.large, ThemeFontSizes.large),
      children: [
        item.amount != null
            ? ThemedControls.primaryButtonBig(
                onPressed: () {
                  // Perform some action
                  pushNewScreen(
                    context,
                    screen: Send(item: item),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                text: "Send",
                icon: LightThemeColors.shouldInvertIcon
                    ? ThemedControls.invertedColors(
                        child: Image.asset("assets/images/send.png"))
                    : Image.asset("assets/images/send.png"))
            : Container(),
        ThemedControls.transparentButtonBig(
          onPressed: () {
            pushNewScreen(
              context,
              screen: Receive(item: item),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          icon: LightThemeColors.shouldInvertIcon
              ? ThemedControls.invertedColors(
                  child: Image.asset("assets/images/receive.png"))
              : Image.asset("assets/images/receive.png"),
          text: "Receive",
        ),
        item.assets.keys.isNotEmpty
            ? ThemedControls.transparentButtonBig(
                text: "Assets",
                onPressed: () {
                  pushNewScreen(
                    context,
                    screen: Assets(PublicId: item.publicId),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                })
            : Container()
      ],
    );
  }

  List<Widget> getAssets(BuildContext context) {
    List<Widget> shares = [];

    for (var key in item.assets.keys) {
      var asset = item.assets[key];
      bool isToken = asset!.contractIndex == QubicSCID.qX.contractIndex &&
          asset!.contractName != "QX";
      String text = isToken ? " Token" : " Share";
      int num = asset.ownedAmount ?? asset.possessedAmount ?? 0;
      if (num != 1) {
        text += "s";
      }
      shares.add(AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            //return FadeTransition(opacity: animation, child: child);
            return SizeTransition(sizeFactor: animation, child: child);
            //return ScaleTransition(scale: animation, child: child);
          },
          child: item.assets[key] != null
              ? AmountFormatted(
                  key: ValueKey<String>(
                      "qubicAsset${item.publicId}-${key}-${item.assets[key]}"),
                  amount: item.assets[key]!.ownedAmount,
                  isInHeader: false,
                  labelOffset: -0,
                  textStyle: TextStyles.accountAmount,
                  labelStyle: TextStyles.accountAmountLabel,
                  currencyName: item.assets[key]!.assetName + text,
                )
              : Container()));
    }
    return shares;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Card(
            color: LightThemeColors.cardBackground,
            elevation: 0,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      ThemePaddings.normalPadding,
                      ThemePaddings.normalPadding,
                      ThemePaddings.normalPadding,
                      0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(item.name,
                                  style: TextStyles.accountName)),
                          getCardMenu(context)
                        ]),
                        SizedBox(height: ThemePaddings.smallPadding),
                        AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              //return FadeTransition(opacity: animation, child: child);
                              return SizeTransition(
                                  sizeFactor: animation, child: child);
                              //return ScaleTransition(scale: animation, child: child);
                            },
                            child: AmountFormatted(
                              key: ValueKey<String>(
                                  "qubicAmount${item.publicId}-${item.amount}"),
                              amount: item.amount,
                              isInHeader: false,
                              labelOffset: -0,
                              textStyle: TextStyles.accountAmount,
                              labelStyle: TextStyles.accountAmountLabel,
                              currencyName: '\$QUBIC',
                            )),
                        Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: getAssets(context))),
                        SizedBox(height: ThemePaddings.smallPadding),
                        CopyableText(
                            copiedText: item.publicId,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: LightThemeColors.color1,
                                    borderRadius: BorderRadius.circular(4)),
                                child: FittedBox(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 12),
                                        child: Text(item.publicId,
                                            style:
                                                TextStyles.accountPublicId))))),
                      ])),
              getButtonBar(context),
            ])));
  }
}
