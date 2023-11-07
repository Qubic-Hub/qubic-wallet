import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/copyable_text.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/explorer_transaction_info_dto.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import '../../stores/application_store.dart';

class ExplorerResultPageTransactionItem extends StatelessWidget {
  final ExplorerTransactionInfoDto transaction;
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');

  final bool isFocused;
  final bool showTick;
  ExplorerResultPageTransactionItem(
      {super.key,
      required this.transaction,
      this.isFocused = false,
      this.showTick = false});

  TextStyle itemHeaderType(context) {
    return Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontFamily: ThemeFonts.primary);
  }

  //Gets the labels for Source and Destination in transcations. Also copies to clipboard
  Widget getFromTo(BuildContext context, String prepend, String id) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Builder(builder: (context) {
        QubicListVm? source =
            appStore.currentQubicIDs.firstWhereOrNull((element) {
          return element.publicId == id;
        });
        if (source != null) {
          return Container(
              width: double.infinity,
              child: Text("$prepend wallet ID \"${source.name}\":",
                  textAlign: TextAlign.start, style: itemHeaderType(context)));
        }
        return Text("$prepend address: ", style: itemHeaderType(context));
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle transactionIdTheme = Theme.of(context)
        .textTheme
        .titleSmall!
        .copyWith(fontFamily: ThemeFonts.secondary);

    return Card(
        surfaceTintColor: transaction.executed ? Colors.green : Colors.red,
        elevation: 5,
        borderOnForeground: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              ThemePaddings.normalPadding,
              ThemePaddings.miniPadding,
              ThemePaddings.normalPadding,
              ThemePaddings.normalPadding), // add padding here
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Transaction ID",
                textAlign: TextAlign.center, style: itemHeaderType(context)),
            CopyableText(
                copiedText: transaction.id,
                child: Text(transaction.id,
                    textAlign: TextAlign.justify,
                    style: transactionIdTheme.copyWith(
                        fontWeight: FontWeight.w500))),
            const Divider(),
            Container(
              width: double.infinity,
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: QubicAmount(amount: transaction.amount)),
            ),
            Flex(direction: Axis.horizontal, children: [
              Expanded(
                  flex: 1,
                  child: Column(children: [
                    Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            transaction.executed
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : const Icon(Icons.close, color: Colors.red),
                            Text(transaction.executed
                                ? " Executed"
                                : " Not executed")
                          ],
                        )),
                    transaction.includedByTickLeader
                        ? Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                transaction.includedByTickLeader
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.close,
                                        color: Colors.red),
                                Text(transaction.includedByTickLeader
                                    ? "Included by Tick Leader"
                                    : "Not included by Tick Leader")
                              ],
                            ))
                        : Container(),
                  ])),
              showTick
                  ? Expanded(
                      flex: 1,
                      child: CopyableText(
                          copiedText: transaction.tick.toString(),
                          child: Text("Tick: ${transaction.tick.asThousands()}",
                              textAlign: TextAlign.right)))
                  : Container()
            ]),
            const Divider(),
            const SizedBox(height: ThemePaddings.miniPadding),
            Text("Transaction digest", style: itemHeaderType(context)),
            Text(transaction.digest),
            const SizedBox(height: ThemePaddings.miniPadding),
            getFromTo(context, "From ", transaction.sourceId),
            CopyableText(
                copiedText: transaction.sourceId,
                child: Text(transaction.sourceId)),
            const SizedBox(height: ThemePaddings.miniPadding),
            getFromTo(context, "To ", transaction.destId),
            CopyableText(
                copiedText: transaction.destId,
                child: Text(transaction.destId)),
            const SizedBox(height: ThemePaddings.normalPadding),
          ]),
        ));
  }
}
