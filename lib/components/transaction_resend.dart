import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/components/amount_formatted.dart';
import 'package:qubic_wallet/components/currency_amount.dart';
import 'package:qubic_wallet/components/currency_label.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/transaction_details.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/stores/application_store.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/styles/textStyles.dart';

import 'package:intl/intl.dart';

enum CardItem { explorer, clipboardCopy }

class TransactionResend extends StatelessWidget {
  final TransactionVm item;
  final NumberFormat numberFormat = NumberFormat.decimalPattern("en_US");

  TransactionResend({super.key, required this.item});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  //Gets the labels for Source and Destination in transcations. Also copies to clipboard
  Widget getFromTo(BuildContext context, String prepend, String id) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Observer(builder: (context) {
        QubicListVm? source =
            appStore.currentQubicIDs.firstWhereOrNull((element) {
          return element.publicId == id;
        });
        if (source != null) {
          return Container(
              width: double.infinity,
              child: Text("$prepend wallet account \"${source.name}\"",
                  style: TextStyles.labelText));
        }
        return Container(
            width: double.infinity,
            child: Text("$prepend address",
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontFamily: ThemeFonts.primary)));
      }),
      Text(id,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontFamily: ThemeFonts.secondary)),
    ]);
  }

  void showDetails(BuildContext context) {
    showModalBottomSheet<void>(
        useRootNavigator: true,
        showDragHandle: false,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return TransactionDetails(item: item);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Flex(direction: Axis.horizontal, children: [
            Text(
                numberFormat.format(
                  item.amount!,
                ),
                style: TextStyles.accountAmount),
            const SizedBox(width: 6, height: 6),
            CurrencyLabel(
                currencyName: "QUBIC",
                isInHeader: false,
                style: TextStyles.accountAmountLabel)
          ]),
          //FittedBox(child: QubicAmount(amount: item.amount)),
          getFromTo(context, "From", item.sourceId),
          const SizedBox(height: ThemePaddings.smallPadding),
          getFromTo(context, "To", item.destId),
          const SizedBox(height: ThemePaddings.smallPadding),
          Container(
              width: double.infinity,
              child: Text("Target tick",
                  textAlign: TextAlign.start, style: TextStyles.labelText)),
          Observer(builder: (context) {
            return Text(
                "${(appStore.currentTick + 20).asThousands()} (current ${appStore.currentTick.asThousands()})",
                style: TextStyles.textNormal);
          })
        ]));
  }
}
