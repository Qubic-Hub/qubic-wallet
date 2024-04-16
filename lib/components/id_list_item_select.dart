import 'package:flutter/material.dart';
import 'package:qubic_wallet/components/amount_formatted.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/textStyles.dart';

enum CardItem { delete, rename }

class IdListItemSelect extends StatelessWidget {
  final QubicListVm item;

  final bool showAmount;
  IdListItemSelect({
    super.key,
    required this.item,
    this.showAmount = true,
  });

  final ApplicationStore appStore = getIt<ApplicationStore>();

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(item.name, style: TextStyles.accountName),
          AmountFormatted(
            key: ValueKey<String>("qubicAmount${item.publicId}-${item.amount}"),
            amount: item.amount,
            isInHeader: false,
            labelOffset: -0,
            textStyle: TextStyles.accountAmount,
            labelStyle: TextStyles.accountAmountLabel,
            currencyName: '\$QUBIC',
          ),
          Text(item.publicId, // "MYSSHMYSSHMYSSHMYSSH.MYSSHMYSSH....",
              style: TextStyles.accountPublicId),
        ]));
  }
}
