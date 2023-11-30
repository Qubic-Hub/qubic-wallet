import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/explorer_result_page_tick/explorer_result_page_tick_header.dart';
import 'package:qubic_wallet/components/explorer_results/explorer_result_page_transaction_item.dart';
import 'package:qubic_wallet/dtos/explorer_tick_info_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

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
        for (var transaction in tickInfo.transactions!)
          focusedTransactionId == null ||
                  focusedTransactionId! == transaction.id
              ? Padding(
                  padding:
                      const EdgeInsets.only(top: ThemePaddings.normalPadding),
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
    TextStyle panelTickHeader = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontFamily: ThemeFonts.secondary);

    if (tickInfo.transactions != null) {
      if (focusedTransactionId == null) {
        return Text(
            '${tickInfo.transactions!.length} transaction${tickInfo.transactions!.length != 1 ? 's' : ''} in tick',
            style: panelTickHeader);
      } else {
        return Column(children: [
          Text(
            'Showing 1 of \n ${tickInfo.transactions!.length} transaction${tickInfo.transactions!.length != 1 ? 's' : ''} in tick',
            style: panelTickHeader,
            textAlign: TextAlign.center,
          ),
          tickInfo.transactions!.length > 1
              ? TextButton(
                  child: Text("show all",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleSmall
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary)),
                  onPressed: () {
                    onRequestViewChange!(
                        RequestViewChangeType.tick, tickInfo.tick, null);
                  })
              : Container()
        ]);
      }
    } else {
      return const Text(
        'No transactions in this tick',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ExplorerResultPageTickHeader(
            tickInfo: tickInfo,
            onTickChange: onRequestViewChange != null
                ? (tick) => {
                      onRequestViewChange!(
                          RequestViewChangeType.tick, tick, null)
                    }
                : null),
        Container(
          margin: const EdgeInsets.only(top: 5.0),
        ),
        getTransactionsHeader(context),
        tickInfo.transactions != null && tickInfo.transactions!.isNotEmpty
            ? listTransactions()
            : Container()
      ],
    );
  }
}
