import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/transaction_details.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';

enum CardItem { explorer, clipboardCopy }

class TransactionResend extends StatelessWidget {
  final TransactionVm item;

  TransactionResend({super.key, required this.item});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  //Gets the dropdown menu
  Widget getCardMenu(BuildContext context) {
    return PopupMenuButton<CardItem>(
        // Callback that sets the selected popup menu item.
        onSelected: (CardItem menuItem) async {
          // setState(() {
          //   selectedMenu = item;
          // });
          if (menuItem == CardItem.explorer) {
            //showRenameDialog(context);
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
          child: Text('DETAILS',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )),
        ),
        Builder(builder: (context) {
          if (item.getStatus() == ComputedTransactionStatus.failure) {
            return TextButton(
              onPressed: () {},
              child: Text('RESEND',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
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
                      .titleLarge!
                      .copyWith(fontFamily: ThemeFonts.primary)));
        }
        return Text("$prepend address: ");
      }),
      Text(id,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontFamily: ThemeFonts.secondary)),
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
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FittedBox(child: QubicAmount(amount: item.amount)),
          getFromTo(context, "From ", item.sourceId),
          const SizedBox(height: ThemePaddings.smallPadding),
          getFromTo(context, "To ", item.destId),
          const SizedBox(height: ThemePaddings.smallPadding),
          Container(
              width: double.infinity,
              child: Text("Target tick:",
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontFamily: ThemeFonts.primary))),
          Observer(builder: (context) {
            return Text(
                "${(appStore.currentTick + 20).asThousands()} (current ${appStore.currentTick.asThousands()})",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontFamily: ThemeFonts.secondary));
          })
        ]));
  }
}
