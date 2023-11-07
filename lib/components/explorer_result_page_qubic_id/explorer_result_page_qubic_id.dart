import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/explorer_result_page_qubic_id/explorer_result_page_qubic_id_header.dart';
import 'package:qubic_wallet/components/explorer_results/explorer_result_page_transaction_item.dart';
import 'package:qubic_wallet/dtos/explorer_id_info_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

class ExplorerResultPageQubicId extends StatelessWidget {
  ExplorerResultPageQubicId({
    super.key,
    required this.idInfo,
  });
  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');
  final ExplorerIdInfoDto idInfo;

  Widget listTransactions() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var transaction in idInfo.latestTransfers!)
          Padding(
            padding: const EdgeInsets.only(top: ThemePaddings.normalPadding),
            child: ExplorerResultPageTransactionItem(
                transaction: transaction, isFocused: false, showTick: true),
          ),
        const SizedBox(height: ThemePaddings.normalPadding)
      ],
    );
  }

  Widget getTransactionsHeader(BuildContext context) {
    TextStyle panelTickHeader = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontFamily: ThemeFonts.secondary);

    if (idInfo.latestTransfers != null) {
      return Text(
          '${idInfo.latestTransfers!.length} transaction${idInfo.latestTransfers!.length != 1 ? 's' : ''} in this epoch',
          style: panelTickHeader);
    } else {
      return const Text(
        'No transactions for this ID in this epoch',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ExplorerResultPageQubicIdHeader(
          idInfo: idInfo,
        ),
        Container(
          margin: const EdgeInsets.only(top: 5.0),
        ),
        getTransactionsHeader(context),
        idInfo.latestTransfers != null && idInfo.latestTransfers!.isNotEmpty
            ? listTransactions()
            : Container()
      ],
    );
  }
}
