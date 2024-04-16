import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/transaction_UI_helpers.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/extensions/darkmode.dart';
import 'package:qubic_wallet/styles/textStyles.dart';

enum CardItem { delete, rename }

class TransactionStatusItem extends StatelessWidget {
  final TransactionVm item;

  TransactionStatusItem({super.key, required this.item});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
      Icon(getTransactionStatusIcon(item.getStatus()),
          color: getTransactionStatusColor(item.getStatus())),
      Text(" ${getTransactionStatusText(item.getStatus())}",
          style: TextStyles.labelText)
    ]));
  }
}
