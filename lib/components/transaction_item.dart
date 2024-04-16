import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/copy_button.dart';
import 'package:qubic_wallet/components/mid_text_with_ellipsis.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/transaction_details.dart';
import 'package:qubic_wallet/components/transaction_resend.dart';
import 'package:qubic_wallet/components/transaction_status_item.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/copy_to_clipboard.dart';
import 'package:qubic_wallet/helpers/re_auth_dialog.dart';
import 'package:qubic_wallet/helpers/sendTransaction.dart';
import 'package:qubic_wallet/helpers/global_snack_bar.dart';
import 'package:qubic_wallet/helpers/transaction_UI_helpers.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';
import 'package:qubic_wallet/stores/application_store.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
import 'package:qubic_wallet/timed_controller.dart';
import 'transaction_direction_item.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';

enum CardItem {
  details,
  resend,
  explorer,
  clipboardCopy,
}

class TransactionItem extends StatelessWidget {
  final TransactionVm item;

  TransactionItem({super.key, required this.item});
  final _timedController = getIt<TimedController>();
  final _globalSnackBar = getIt<GlobalSnackBar>();

  final ApplicationStore appStore = getIt<ApplicationStore>();

  Future<void> showResendDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Resend failed transaction?', style: TextStyles.alertHeader),
          content: SingleChildScrollView(
            child: TransactionResend(item: item),
          ),
          actions: <Widget>[
            ThemedControls.transparentButtonBig(
              text: "No",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ThemedControls.primaryButtonBig(
              text: "Yes",
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
                    appStore.currentTick + 30);
                if (success) {
                  _globalSnackBar.show(
                      "Submitted new transaction to Qubic network", true);
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
        tooltip: "",
        icon: Icon(Icons.more_horiz,
            color: LightThemeColors.primary.withAlpha(140)),
        // Callback that sets the selected popup menu item.
        onSelected: (CardItem menuItem) async {
          // setState(() {
          //   selectedMenu = item;
          // });
          if (menuItem == CardItem.explorer) {
            //showRenameDialog(context);
            pushNewScreen(
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
            copyToClipboard(item.toReadableString());
          }

          if (menuItem == CardItem.resend) {
            showResendDialog(context);
          }

          if (menuItem == CardItem.details) {
            showDetails(context);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<CardItem>>[
              const PopupMenuItem<CardItem>(
                value: CardItem.details,
                child: Text('View details'),
              ),
              const PopupMenuItem<CardItem>(
                value: CardItem.explorer,
                child: Text('View in explorer'),
              ),
              const PopupMenuItem<CardItem>(
                value: CardItem.clipboardCopy,
                child: Text('Copy to clipboard'),
              ),
              if ((item.getStatus() == ComputedTransactionStatus.failure))
                const PopupMenuItem<CardItem>(
                  value: CardItem.resend,
                  child: Text('Resend'),
                )
            ]);
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
          return Row(children: [
            Expanded(
                child: Text("$prepend wallet account \"${source.name}\"",
                    textAlign: TextAlign.start,
                    style: TextStyles.lightGreyTextSmallBold)),
          ]);
        }
        return Row(children: [
          Text("$prepend address ",
              textAlign: TextAlign.start,
              style: TextStyles.lightGreyTextSmallBold)
        ]);
      }),

      TextWithMidEllipsis(id,
          style: TextStyles.textSmall, textAlign: TextAlign.start),

      // FittedBox(
      //     child: Text(id,
      //         style: Theme.of(context)
      //             .textTheme
      //             .titleMedium!
      //             .copyWith(fontFamily: ThemeFonts.secondary))),
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
    bool isScreenWide = MediaQuery.of(context).size.width >= 400;

    return Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: ThemedControls.card(
            child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: TransactionStatusItem(
                      item: item,
                      key: ValueKey<String>(
                          "transactionStatus${item.id}${item.getStatus().toString()}"),
                    ),
                  ),
                  //                      TransactionStatusItem(item: item)
                  getCardMenu(context)
                ])),
            Container(
                width: double.infinity,
                child: FittedBox(child: QubicAmount(amount: item.amount))),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TransactionDirectionItem(item: item),
                  Text("Tick: ${item.targetTick.asThousands()}",
                      textAlign: TextAlign.end,
                      style: TextStyles.assetSecondaryTextLabel),
                ]),
            ThemedControls.spacerVerticalNormal(),
//            isScreenWide
            // ? Flex(
            //     direction: Axis.horizontal,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //         Expanded(
            //             child: getFromTo(context, "From", item.sourceId)),
            //         Image.asset("assets/images/arrow-color-16.png"),
            //         Expanded(child: getFromTo(context, "To", item.destId))
            //       ])
            //:
            Column(children: [
              Flex(direction: Axis.horizontal, children: [
                Expanded(child: getFromTo(context, "From", item.sourceId)),
                CopyButton(copiedText: item.sourceId),
              ]),
              ThemedControls.spacerVerticalSmall(),
              Flex(direction: Axis.horizontal, children: [
                Expanded(child: getFromTo(context, "To", item.destId)),
                CopyButton(copiedText: item.destId),
              ]),
            ]),
          ]),
        ])));
  }
}
