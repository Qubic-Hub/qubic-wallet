import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/qubic_asset.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/id_validators.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/assets.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/receive.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/reveal_seed/reveal_seed.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/send.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/transfers/transactions_for_id.dart';
import 'package:qubic_wallet/stores/application_store.dart';

enum CardItem { delete, rename, reveal, viewTransactions, viewInExplorer }

class IdListItem extends StatelessWidget {
  final QubicListVm item;
  final _formKey = GlobalKey<FormBuilderState>();

  IdListItem({super.key, required this.item});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  showRenameDialog(BuildContext context) {
    late BuildContext dialogContext;

    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.pop(dialogContext);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("SAVE"),
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
      title: const Text("Rename Qubic ID"),
      content: FormBuilder(
          key: _formKey,
          child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormBuilderTextField(
                    name: 'accountName',
                    initialValue: item.name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
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
    Widget cancelButton = TextButton(
      child: const Text("NO"),
      onPressed: () {
        Navigator.pop(dialogContext);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("YES"),
      onPressed: () async {
        await appStore.removeID(item.publicId);
        Navigator.pop(dialogContext);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Remove Qubic ID"),
      content: const Text(
          "Are you sure you want to remove this Qubic ID from your wallet? (Any funds associated with this ID will not be removed)\n\nMAKE SURE YOU HAVE A BACKUP OF YOUR PRIVATE SEED BEFORE REMOVING THIS ID!"),
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
    return PopupMenuButton<CardItem>(
        icon: Icon(Icons.more_vert, color: Theme.of(context).primaryColor),
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
            PersistentNavBarNavigator.pushNewScreen(
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
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: TransactionsForId(publicQubicId: item.publicId),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }

          if (menuItem == CardItem.reveal) {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: RevealSeed(item: item),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<CardItem>>[
              const PopupMenuItem<CardItem>(
                value: CardItem.viewTransactions,
                child: Text('View transactions'),
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
            ]);
  }

  Widget getButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      buttonPadding: const EdgeInsets.all(ThemePaddings.miniPadding),
      children: [
        item.amount != null
            ? TextButton(
                onPressed: () {
                  // Perform some action
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: Send(item: item),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Text('SEND',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        )),
              )
            : Container(),
        TextButton(
          onPressed: () {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: Receive(item: item),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Text('RECEIVE',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )),
        ),
        item.assets.keys.isNotEmpty
            ? TextButton(
                child: Text('ASSETS',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        )),
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(
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
      shares.add(AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                //return FadeTransition(opacity: animation, child: child);
                return SizeTransition(sizeFactor: animation, child: child);
                //return ScaleTransition(scale: animation, child: child);
              },
              child: item.assets[key] != null
                  ? QubicAsset(
                      key: ValueKey<String>(
                          "qubicAsset${item.publicId}-${key}-${item.assets[key]}"),
                      asset: item.assets[key]!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontFamily: ThemeFonts.primary))
                  : Container())

          // QubicAsset(
          //   assetName: key,
          //   numberOfShares: item.shares[key],
          //   style: Theme.of(context).textTheme.displaySmall!.copyWith(
          //       fontWeight: FontWeight.normal, fontFamily: ThemeFonts.primary))
          );
    }
    return shares;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Card(
            elevation: 5,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      ThemePaddings.normalPadding,
                      ThemePaddings.normalPadding,
                      ThemePaddings.normalPadding,
                      ThemePaddings.smallPadding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(item.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontFamily: ThemeFonts.secondary)),
                        FittedBox(
                            child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  //return FadeTransition(opacity: animation, child: child);
                                  return SizeTransition(
                                      sizeFactor: animation, child: child);
                                  //return ScaleTransition(scale: animation, child: child);
                                },
                                child: QubicAmount(
                                    amount: item.amount,
                                    key: ValueKey<String>(
                                        "qubicAmount${item.publicId}-${item.amount}")))),
                        Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: getAssets(context))),
                        FittedBox(
                            child: Text(
                                item
                                    .publicId, // "MYSSHMYSSHMYSSHMYSSH.MYSSHMYSSH....",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontFamily: ThemeFonts.secondary))),
                      ])),
              Container(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          ThemePaddings.miniPadding,
                          ThemePaddings.miniPadding,
                          ThemePaddings.miniPadding,
                          ThemePaddings.miniPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [getButtonBar(context), getCardMenu(context)],
                      )))
            ])));
  }
}
