import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/copy_button.dart';
import 'package:qubic_wallet/components/copyable_text.dart';
import 'package:qubic_wallet/components/explorer_transaction_status_item.dart';
import 'package:qubic_wallet/components/gradient_foreground.dart';
import 'package:qubic_wallet/components/mid_text_with_ellipsis.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/explorer_transaction_info_dto.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

import '../../stores/application_store.dart';

class ExplorerResultPageTransactionItem extends StatelessWidget {
  final ExplorerTransactionInfoDto transaction;
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');

  final bool isFocused;
  final bool showTick;
  final bool? dataStatus;
  ExplorerResultPageTransactionItem(
      {super.key,
      required this.transaction,
      this.isFocused = false,
      this.showTick = false,
      this.dataStatus = false});

  TextStyle itemHeaderType(context) {
    return TextStyles.lightGreyTextSmallBold;
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

      Text(id, style: TextStyles.textSmall, textAlign: TextAlign.start),

      // FittedBox(
      //     child: Text(id,
      //         style: Theme.of(context)
      //             .textTheme
      //             .titleMedium!
      //             .copyWith(fontFamily: ThemeFonts.secondary))),
    ]);
  }

  Widget includedByQubicNetwork() {
    return Flex(direction: Axis.horizontal, children: [
      transaction.executed
          ? GradientForeground(
              child: Image.asset('assets/images/check-circle-color16.png'))
          : LightThemeColors.shouldInvertIcon
              ? ThemedControls.invertedColors(
                  child: Image.asset('assets/images/close-16.png'))
              : Image.asset('assets/images/close-16.png'),
      Expanded(
          child: Text(
              transaction.executed
                  ? "  Included by Qubic Network"
                  : "  Not included by Qubic Network",
              style: TextStyles.textTiny))
    ]);
  }

  Widget includedByTickLeader() {
    return Flex(direction: Axis.horizontal, children: [
      transaction.includedByTickLeader
          ? GradientForeground(
              child: Image.asset('assets/images/check-circle-color16.png'))
          : LightThemeColors.shouldInvertIcon
              ? ThemedControls.invertedColors(
                  child: Image.asset('assets/images/close-16.png'))
              : Image.asset('assets/images/close-16.png'),
      Expanded(
          child: Text(
              transaction.includedByTickLeader
                  ? "  Included by Tick Leader"
                  : "  Not included by Tick Leader",
              style: TextStyles.textTiny))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ThemedControls.card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ExplorerTransactionStatusItem(item: transaction),
        Container(
            width: double.infinity,
            child: FittedBox(
                fit: BoxFit.cover,
                child: QubicAmount(
                    amount: transaction.amount)) // transaction.amount)),
            ),
        Flex(direction: Axis.horizontal, children: [
          Expanded(
              flex: 1,
              child: Column(children: [
                includedByQubicNetwork(),
                ThemedControls.spacerVerticalMini(),
                includedByTickLeader(),
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
        ThemedControls.spacerVerticalSmall(),
        Flex(direction: Axis.horizontal, children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("Transaction Id", style: itemHeaderType(context)),
                Text(transaction.id),
              ])),
          CopyButton(copiedText: transaction.id),
        ]),
        ThemedControls.spacerVerticalSmall(),
        Flex(direction: Axis.horizontal, children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("Transaction digest", style: itemHeaderType(context)),
                Text(transaction.digest),
              ])),
          CopyButton(copiedText: transaction.digest),
        ]),
        ThemedControls.spacerVerticalSmall(),
        Flex(direction: Axis.horizontal, children: [
          Expanded(child: getFromTo(context, "From", transaction.sourceId)),
          CopyButton(copiedText: transaction.sourceId),
        ]),
        ThemedControls.spacerVerticalSmall(),
        Flex(direction: Axis.horizontal, children: [
          Expanded(child: getFromTo(context, "To", transaction.destId)),
          CopyButton(copiedText: transaction.destId),
        ]),
      ]),
    );
  }
}
