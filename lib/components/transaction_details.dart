import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/components/copyable_text.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/transaction_status_item.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';
import 'package:qubic_wallet/stores/application_store.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'transaction_direction_item.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';

enum CardItem { explorer, clipboardCopy }

class TransactionDetails extends StatelessWidget {
  final TransactionVm item;

  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');

  TransactionDetails({super.key, required this.item});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  Widget getButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      buttonPadding: const EdgeInsets.all(ThemePaddings.miniPadding),
      children: [
        TextButton(
          onPressed: () {
            // Perform some action

            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: ExplorerResultPage(
                  resultType: ExplorerResultType.tick,
                  tick: item.targetTick,
                  focusedTransactionHash: item.id),
              //TransactionsForId(publicQubicId: item.publicId),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Text('VIEW IN EXPLORER',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )),
        ),
        TextButton(
          onPressed: () async {
            await Clipboard.setData(
                ClipboardData(text: item.toReadableString()));
          },
          child: Text('COPY TO CLIPBOARD',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )),
        )
      ],
    );
  }

  //Gets the from and To labels
  Widget getFromTo(BuildContext context, String prepend, String id) {
    return CopyableText(
        copiedText: id,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
          Text(id,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontFamily: ThemeFonts.secondary)),
        ]));
  }

  Widget getCopyableDetails(BuildContext context, String text, String value) {
    return InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: value));
        },
        child: Ink(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
              width: double.infinity,
              child: Text("$text",
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: ThemeFonts.primary))),
          Container(
              width: double.infinity,
              child: Text(value,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontFamily: ThemeFonts.secondary)))
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    ThemePaddings.normalPadding,
                    ThemePaddings.normalPadding,
                    ThemePaddings.normalPadding,
                    0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          Container(
                              transform: Matrix4.translationValues(0, -20, 0),
                              child: Row(children: [
                                TransactionStatusItem(item: item)
                              ])),
                          Container(
                              transform: Matrix4.translationValues(0, 10, 0),
                              width: double.infinity,
                              child: FittedBox(
                                child: CopyableText(
                                  copiedText: item.amount.toString(),
                                  child: QubicAmount(amount: item.amount),
                                ),
                              )),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TransactionDirectionItem(item: item),
                            CopyableText(
                                copiedText: item.targetTick.toString(),
                                child: Text(
                                    "Target tick: ${item.targetTick.asThousands()}",
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontFamily: ThemeFonts.primary)))
                          ]),
                      const Divider(),
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(children: [
                        getCopyableDetails(context, "Transaction ID", item.id),
                        const SizedBox(height: ThemePaddings.smallPadding),
                        getFromTo(context, "From ", item.sourceId),
                        const SizedBox(height: ThemePaddings.smallPadding),
                        getFromTo(context, "To ", item.destId),
                        const SizedBox(height: ThemePaddings.smallPadding),
                        getCopyableDetails(context, "Lead to money flow",
                            item.moneyFlow ? "Yes" : "No"),
                        const SizedBox(height: ThemePaddings.smallPadding),
                        getCopyableDetails(
                            context,
                            "Created date",
                            item.broadcasted != null
                                ? formatter.format(item.created!.toLocal())
                                : "Unknown"),
                        const SizedBox(height: ThemePaddings.smallPadding),
                        getCopyableDetails(
                            context,
                            "Broadcasted date",
                            item.broadcasted != null
                                ? formatter.format(item.broadcasted!.toLocal())
                                : "Unknown"),
                        const SizedBox(height: ThemePaddings.smallPadding),
                        getCopyableDetails(
                            context,
                            "Confirmed date",
                            item.confirmed != null
                                ? formatter.format(item.confirmed!.toLocal())
                                : "N/A")
                      ]))),
                      getButtonBar(context),
                    ]))));
  }
}
