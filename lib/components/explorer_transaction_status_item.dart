import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/explorer_transaction_info_dto.dart';
import 'package:qubic_wallet/helpers/transaction_UI_helpers.dart';

import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/textStyles.dart';

enum CardItem { delete, rename }

class ExplorerTransactionStatusItem extends StatelessWidget {
  final ExplorerTransactionInfoDto item;

  ExplorerTransactionStatusItem({super.key, required this.item});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Icon(getTransactionStatusIcon(item.getStatus()),
          color: getTransactionStatusColor(item.getStatus()), size: 18),
      Text(" ${getTransactionStatusText(item.getStatus())}",
          style: TextStyles.labelTextSmall)
    ]);
  }
}
