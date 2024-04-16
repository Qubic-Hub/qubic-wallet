import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:qubic_wallet/components/change_foreground.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

Widget getEmptyTransactions(
    {required BuildContext context,
    required bool hasFiltered,
    int? numberOfFilters,
    required void Function()? onTap}) {
  Color? transpColor =
      Theme.of(context).textTheme.titleMedium?.color!.withOpacity(0.3);
  return Column(children: [
    ThemedControls.spacerVerticalHuge(),
    ChangeForeground(
        color: LightThemeColors.gradient1,
        child: Image.asset('assets/images/transactions-color-146.png')),
    ThemedControls.spacerVerticalHuge(),
    Text(
      hasFiltered
          ? "No transactions in this epoch for your accounts match your filters"
          : "No transactions in this epoch for your accounts",
      textAlign: TextAlign.center,
      style: TextStyles.transparentButtonText,
    ),
    ThemedControls.spacerVerticalHuge(),
    if ((hasFiltered) && (numberOfFilters != null))
      ThemedControls.primaryButtonNormal(
          onPressed: onTap, text: "Clear active filters")
  ]);

  // Center(
  //     child: Image.asset('assets/images/transactions-color-146.png'),
  //     DottedBorder(
  //         color: transpColor!,
  //         strokeWidth: 3,
  //         borderType: BorderType.RRect,
  //         radius: const Radius.circular(20),
  //         dashPattern: const [10, 5],
  //         child: Padding(
  //           padding: const EdgeInsets.all(ThemePaddings.bigPadding),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.compare_arrows,
  //                   size: 100,
  //                   color: Theme.of(context)
  //                       .textTheme
  //                       .titleMedium
  //                       ?.color!
  //                       .withOpacity(0.3)),
  //               Text(
  //                 hasFiltered
  //                     ? "No transcations found matching your filters"
  //                     : "No transactions in this epoch \nfor your IDs",
  //                 textAlign: TextAlign.center,
  //               ),
  //               const SizedBox(height: ThemePaddings.normalPadding),
  //             ],
  //           ),
  //         )));
}

IconData getTransactionStatusIcon(ComputedTransactionStatus status) {
  switch (status) {
    case ComputedTransactionStatus.confirmed:
      return Icons.check_circle;
    case ComputedTransactionStatus.failure:
      return Icons.highlight_remove_outlined;
    case ComputedTransactionStatus.invalid:
      return Icons.remove_circle;
    case ComputedTransactionStatus.success:
      return Icons.check_circle;
    case ComputedTransactionStatus.pending:
      return Icons.access_time_filled;
  }
}

Color getTransactionStatusColor(ComputedTransactionStatus status) {
  switch (status) {
    case ComputedTransactionStatus.confirmed:
      return Colors.blue;
    case ComputedTransactionStatus.failure:
      return LightThemeColors.error;
    case ComputedTransactionStatus.invalid:
      return LightThemeColors.error;
    case ComputedTransactionStatus.success:
      return LightThemeColors.successIncoming;
    case ComputedTransactionStatus.pending:
      return LightThemeColors.pending;
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
