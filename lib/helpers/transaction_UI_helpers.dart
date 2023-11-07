import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';

Widget getEmptyTransactions(BuildContext context, bool hasFiltered) {
  Color? transpColor =
      Theme.of(context).textTheme.titleMedium?.color!.withOpacity(0.3);
  return Center(
      child: DottedBorder(
          color: transpColor!,
          strokeWidth: 3,
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          dashPattern: const [10, 5],
          child: Padding(
            padding: const EdgeInsets.all(ThemePaddings.bigPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.compare_arrows,
                    size: 100,
                    color: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.color!
                        .withOpacity(0.3)),
                Text(
                  hasFiltered
                      ? "No transcations found matching your filters"
                      : "No transactions in this epoch \nfor your IDs",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ThemePaddings.normalPadding),
              ],
            ),
          )));
}

IconData getTransactionStatusIcon(ComputedTransactionStatus status) {
  switch (status) {
    case ComputedTransactionStatus.confirmed:
      return Icons.playlist_add_check_circle_sharp;
    case ComputedTransactionStatus.failure:
      return Icons.highlight_remove_rounded;
    case ComputedTransactionStatus.invalid:
      return Icons.error_outline;
    case ComputedTransactionStatus.success:
      return Icons.check_circle_outline_outlined;
    case ComputedTransactionStatus.pending:
      return Icons.history_toggle_off_rounded;
  }
}

Color getTransactionStatusColor(ComputedTransactionStatus status) {
  switch (status) {
    case ComputedTransactionStatus.confirmed:
      return Colors.blue;
    case ComputedTransactionStatus.failure:
      return Colors.red;
    case ComputedTransactionStatus.invalid:
      return Colors.red;
    case ComputedTransactionStatus.success:
      return Colors.green;
    case ComputedTransactionStatus.pending:
      return Colors.grey;
  }
}

String getTransactionStatusText(ComputedTransactionStatus status) {
  switch (status) {
    case ComputedTransactionStatus.confirmed:
      return "Confirmed";
    case ComputedTransactionStatus.failure:
      return "Failed";
    case ComputedTransactionStatus.invalid:
      return "Failed - invalid";
    case ComputedTransactionStatus.success:
      return "Successful";
    case ComputedTransactionStatus.pending:
      return "Pending";
  }
}
