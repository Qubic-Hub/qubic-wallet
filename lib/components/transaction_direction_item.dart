import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';

enum CardItem { delete, rename }

class TransactionDirectionItem extends StatelessWidget {
  final TransactionVm item;

  TransactionDirectionItem({super.key, required this.item}) {
    isIncoming = appStore.currentQubicIDs.where((element) {
      return element.publicId == item.destId;
    }).isNotEmpty;
    isOutgoing = appStore.currentQubicIDs.where((element) {
      return element.publicId == item.sourceId;
    }).isNotEmpty;
  }

  final ApplicationStore appStore = getIt<ApplicationStore>();

  late final bool isIncoming;
  late final bool isOutgoing;

  IconData getIcon() {
    if (isIncoming && isOutgoing) {
      return Icons.wallet_giftcard_rounded;
    }
    if (isIncoming) {
      return Icons.input_outlined;
    }
    return Icons.output_outlined;
  }

  String getText() {
    if (isIncoming && isOutgoing) {
      return "In-wallet";
    }
    if (isIncoming) {
      return "Incoming";
    }
    return "Outgoing";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(ThemePaddings.miniPadding),
        child: Row(children: [
          Icon(getIcon()),
          Text(" ${getText()}",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontFamily: ThemeFonts.primary))
        ]));
  }
}
