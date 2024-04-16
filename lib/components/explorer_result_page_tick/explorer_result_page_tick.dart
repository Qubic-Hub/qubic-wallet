import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/explorer_result_page_tick/explorer_result_page_tick_header.dart';
import 'package:qubic_wallet/components/explorer_results/explorer_result_page_transaction_item.dart';
import 'package:qubic_wallet/dtos/explorer_tick_info_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/styles/edgeInsets.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

enum RequestViewChangeType { tick, publicId }

class ExplorerResultPageTick extends StatelessWidget {
  ExplorerResultPageTick(
      {super.key,
      required this.tickInfo,
      this.onRequestViewChange,
      this.focusedTransactionId});
  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');
  final ExplorerTickInfoDto tickInfo;
  final String? focusedTransactionId;

  final Function(RequestViewChangeType type, int? tick, String? publicId)?
      onRequestViewChange;

  Widget listTransactions() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThemedControls.spacerVerticalNormal(),
        for (var transaction in tickInfo.transactions!)
          focusedTransactionId == null ||
                  focusedTransactionId! == transaction.id
              ? Padding(
                  padding: const EdgeInsets.only(
                      bottom: ThemePaddings.normalPadding),
                  child: ExplorerResultPageTransactionItem(
                    transaction: transaction,
                    isFocused: focusedTransactionId == null
                        ? false
                        : focusedTransactionId! == transaction.id,
                    dataStatus: tickInfo.completed,
                  ),
                )
              : Container()
      ],
    );
  }

  Widget getTransactionsHeader(BuildContext context) {
    TextStyle panelTickHeader = TextStyles.textExtraLargeBold;

    if (tickInfo.transactions != null) {
      if (focusedTransactionId == null) {
        return Text(
            '${tickInfo.transactions!.length} transaction${tickInfo.transactions!.length != 1 ? 's' : ''} in tick',
            style: panelTickHeader);
      } else {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Showing 1 of ${tickInfo.transactions!.length} transaction${tickInfo.transactions!.length != 1 ? 's' : ''} in tick',
            style: panelTickHeader,
            textAlign: TextAlign.center,
          ),
          Padding(
              padding: const EdgeInsets.only(top: ThemePaddings.smallPadding),
              child: tickInfo.transactions!.length > 1
                  ? ThemedControls.primaryButtonSmall(
                      text: "Show all",
                      onPressed: () {
                        onRequestViewChange!(
                            RequestViewChangeType.tick, tickInfo.tick, null);
                      })
                  : Container())
        ]);
      }
    } else {
      return Text('No transactions in this tick', style: panelTickHeader);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExplorerResultPageTickHeader(
            tickInfo: tickInfo,
            onTickChange: onRequestViewChange != null
                ? (tick) => {
                      onRequestViewChange!(
                          RequestViewChangeType.tick, tick, null)
                    }
                : null),
        Padding(
            padding: EdgeInsets.only(
                left: ThemeEdgeInsets.pageInsets.left,
                right: ThemeEdgeInsets.pageInsets.right),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              getTransactionsHeader(context),
              tickInfo.transactions != null && tickInfo.transactions!.isNotEmpty
                  ? listTransactions()
                  : Container()
            ])),
      ],
    );
  }
}
