import 'package:flutter/material.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';

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
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
                ThemePaddings.normalPadding,
                ThemePaddings.smallPadding,
                ThemePaddings.normalPadding,
                ThemePaddings.smallPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(item.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  showAmount
                      ? FittedBox(child: QubicAmount(amount: item.amount))
                      : Container(),
                  FittedBox(
                      child: Text(
                          item.publicId, // "MYSSHMYSSHMYSSHMYSSH.MYSSHMYSSH....",
                          style: Theme.of(context).textTheme.titleMedium)),
                ])));
  }
}
