import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/explorer_transaction_info_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/transaction_UI_helpers.dart';

import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/extensions/darkmode.dart';

enum CardItem { delete, rename }

class ExplorerTransactionStatusItem extends StatelessWidget {
  final ExplorerTransactionInfoDto item;

  ExplorerTransactionStatusItem({super.key, required this.item});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Icon(getTransactionStatusIcon(item.getStatus()),
          color: getTransactionStatusColor(item.getStatus())),
      Text(" ${getTransactionStatusText(item.getStatus())}",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600,
                //color: getTransactionStatusColor(item.getStatus())
              ))
    ]);
  }
}
