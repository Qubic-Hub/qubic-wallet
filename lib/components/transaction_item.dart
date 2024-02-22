import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/transaction_details.dart';
import 'package:qubic_wallet/components/transaction_resend.dart';
import 'package:qubic_wallet/components/transaction_status_item.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/re_auth_dialog.dart';
import 'package:qubic_wallet/helpers/sendTransaction.dart';
import 'package:qubic_wallet/helpers/show_snackbar.dart';
import 'package:qubic_wallet/helpers/transaction_UI_helpers.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';
import 'package:qubic_wallet/stores/application_store.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:qubic_wallet/timed_controller.dart';
import 'transaction_direction_item.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';

enum CardItem { explorer, clipboardCopy, resend }

class TransactionItem extends StatelessWidget {
  final TransactionVm item;

  TransactionItem({super.key, required this.item});
  final _timedController = getIt<TimedController>();

  final ApplicationStore appStore = getIt<ApplicationStore>();

  Future<void> showResendDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resend failed transaction?',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontFamily: ThemeFonts.primary)),
          content: SingleChildScrollView(
            child: TransactionResend(item: item),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('YES'),
              onPressed: () async {
                var result = await reAuthDialog(context);
                if (!result) {
                  return;
                }

                bool success = await sendTransactionDialog(
                    context,
                    item.sourceId,
                    item.destId,
                    item.amount,
                    appStore.currentTick + 20);
                if (success) {
                  showSnackBar("Submitted new transaction to Qubic network");
                }
                await _timedController.interruptFetchTimer();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Gets the dropdown menu
  Widget getCardMenu(BuildContext context) {
    return PopupMenuButton<CardItem>(
        icon: Icon(Icons.more_vert, color: Theme.of(context).primaryColor),
        // Callback that sets the selected popup menu item.
        onSelected: (CardItem menuItem) async {
          // setState(() {
          //   selectedMenu = item;
          // });
          if (menuItem == CardItem.explorer) {
            //showRenameDialog(context);
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: ExplorerResultPage(
                resultType: ExplorerResultType.transaction,
                tick: item.targetTick,
                focusedTransactionHash: item.id,
              ),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }

          if (menuItem == CardItem.clipboardCopy) {
            await Clipboard.setData(
                ClipboardData(text: item.toReadableString()));
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<CardItem>>[
              const PopupMenuItem<CardItem>(
                value: CardItem.explorer,
                child: Text('View in explorer'),
              ),
              const PopupMenuItem<CardItem>(
                value: CardItem.clipboardCopy,
                child: Text('Copy to clipboard'),
              ),
            ]);
  }

  //Gets the button bar (DETAILS and RESEND for failed transactions)
  Widget getButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      buttonPadding: const EdgeInsets.all(ThemePaddings.miniPadding),
      children: [
        TextButton(
          onPressed: () {
            // Perform some action
            showDetails(context);
          },
          child: Text('VIEW DETAILS',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )),
        ),
        Builder(builder: (context) {
          if ((item.getStatus() == ComputedTransactionStatus.failure) &&
              (appStore.currentQubicIDs.where((element) {
                return element.publicId == item.sourceId;
              }).isNotEmpty)) {
            return TextButton(
              onPressed: () {
                showResendDialog(context);
              },
              child: Text('RESEND',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
            );
          }
          return Container();
        })
      ],
    );
  }

  //Gets the labels for Source and Destination in transcations. Also copies to clipboard
  Widget getFromTo(BuildContext context, String prepend, String id) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Observer(builder: (context) {
        QubicListVm? source =
            appStore.currentQubicIDs.firstWhereOrNull((element) {
          return element.publicId == id;
        });
        if (source != null) {
          return Container(
              width: double.infinity,
              child: Text("$prepend wallet ID \"${source.name}\":",
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: ThemeFonts.primary)));
        }
        return Container(
            width: double.infinity,
            child: Text("$prepend address: ",
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: ThemeFonts.primary)));
      }),
      FittedBox(
          child: Text(id,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontFamily: ThemeFonts.secondary))),
    ]);
  }

  void showDetails(BuildContext context) {
    showModalBottomSheet<void>(
        useRootNavigator: true,
        showDragHandle: false,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return TransactionDetails(item: item);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Card(
            surfaceTintColor:
                item.getStatus() != ComputedTransactionStatus.pending
                    ? getTransactionStatusColor(item.getStatus())
                    : null,
            elevation: 5,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      ThemePaddings.normalPadding,
                      ThemePaddings.normalPadding,
                      ThemePaddings.normalPadding,
                      ThemePaddings.normalPadding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Container(
                                transform: Matrix4.translationValues(0, -20, 0),
                                child: Row(children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return ScaleTransition(
                                          scale: animation, child: child);
                                    },
                                    child: TransactionStatusItem(
                                      item: item,
                                      key: ValueKey<String>(
                                          "transactionStatus${item.id}${item.getStatus().toString()}"),
                                    ),
                                  ),
                                  //                      TransactionStatusItem(item: item)
                                ])),
                            Container(
                                transform: Matrix4.translationValues(0, 10, 0),
                                width: double.infinity,
                                child: FittedBox(
                                    child: QubicAmount(amount: item.amount))),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TransactionDirectionItem(item: item),
                              Text(
                                  "Target tick: ${item.targetTick.asThousands()}",
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontFamily: ThemeFonts.primary)),
                            ]),
                        const Divider(),
                        getFromTo(context, "From ", item.sourceId),
                        const SizedBox(height: ThemePaddings.smallPadding),
                        getFromTo(context, "To ", item.destId),
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
