import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/copy_button.dart';
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
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
import 'transaction_direction_item.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';

enum CardItem { explorer, clipboardCopy }

class TransactionDetails extends StatelessWidget {
  final TransactionVm item;

  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');

  TransactionDetails({super.key, required this.item});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  Widget getButtonBar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(
            0, ThemePaddings.smallPadding, 0, ThemePaddings.smallPadding),
        child: Row(
          children: [
            Expanded(
                child: ThemedControls.transparentButtonBigWithChild(
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: item.toReadableString()));
                    },
                    child: Text('Copy to clipboard',
                        style: TextStyles.transparentButtonText))),
            ThemedControls.spacerHorizontalNormal(),
            Expanded(
              child: ThemedControls.primaryButtonBigWithChild(
                  onPressed: () {
                    // Perform some action

                    pushNewScreen(
                      context,
                      screen: ExplorerResultPage(
                          resultType: ExplorerResultType.tick,
                          tick: item.targetTick,
                          focusedTransactionHash: item.id),
                      //TransactionsForId(publicQubicId: item.publicId),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                  child: Text('View in explorer',
                      style: TextStyles.primaryButtonText)),
            ),
          ],
        ));
  }

  //Gets the from and To labels
  Widget getFromTo(BuildContext context, String prepend, String id) {
    return Flex(direction: Axis.horizontal, children: [
      Expanded(
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
                    style: TextStyles.lightGreyTextSmallBold));
          }
          return Container(
              width: double.infinity,
              child: Text("$prepend address: ",
                  textAlign: TextAlign.start, style: TextStyles.textNormal));
        }),
        Text(id,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: ThemeFonts.secondary)),
      ])),
      CopyButton(copiedText: id)
    ]);
  }

  Widget getCopyableDetails(BuildContext context, String text, String value) {
    return Flex(direction: Axis.horizontal, children: [
      Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
            width: double.infinity,
            child: Text("$text",
                textAlign: TextAlign.start,
                style: TextStyles.lightGreyTextSmallBold)),
        Container(
            width: double.infinity,
            child: Text(value,
                textAlign: TextAlign.start, style: TextStyles.textNormal))
      ])),
      CopyButton(copiedText: value)
    ]);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ThemedControls.pageHeader(
                            headerText: "Transfer details",
                          ),
                          ThemedControls.spacerVerticalNormal(),
                          TransactionStatusItem(item: item),
                          Container(
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
                                    "Tick ${item.targetTick.asThousands()}",
                                    textAlign: TextAlign.end,
                                    style: TextStyles.assetSecondaryTextLabel))
                          ]),
                      ThemedControls.spacerVerticalNormal(),
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(children: [
                        getCopyableDetails(context, "Transaction ID", item.id),
                        ThemedControls.spacerVerticalSmall(),
                        getFromTo(context, "From ", item.sourceId),
                        ThemedControls.spacerVerticalSmall(),
                        getFromTo(context, "To ", item.destId),
                        ThemedControls.spacerVerticalSmall(),
                        getCopyableDetails(context, "Lead to money flow",
                            item.moneyFlow ? "Yes" : "No"),
                        ThemedControls.spacerVerticalSmall(),
                        getCopyableDetails(
                            context,
                            "Created date",
                            item.broadcasted != null
                                ? formatter.format(item.created!.toLocal())
                                : "Unknown"),
                        ThemedControls.spacerVerticalSmall(),
                        getCopyableDetails(
                            context,
                            "Broadcasted date",
                            item.broadcasted != null
                                ? formatter.format(item.broadcasted!.toLocal())
                                : "Unknown"),
                        ThemedControls.spacerVerticalSmall(),
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
