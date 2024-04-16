import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/components/currency_amount.dart';
import 'package:qubic_wallet/components/currency_label.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/amount_formatted.dart';
import 'package:qubic_wallet/components/qubic_asset.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/textStyles.dart';

class CumulativeWalletValueSliver extends StatelessWidget {
  CumulativeWalletValueSliver({super.key});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  List<Widget> getShares(BuildContext context) {
    List<Widget> assets = [];
    for (var asset in appStore.totalShares) {
      assets.add(QubicAsset(
          asset: asset,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.normal, fontFamily: ThemeFonts.primary)));
    }
    return assets;
  }

  Widget getTotalQubics() {
    return AmountFormatted(
      amount: appStore.totalAmounts,
      isInHeader: true,
      currencyName: '\$QUBIC',
    );
  }

  Widget getTotalUSD() {
    return AmountFormatted(
      amount: appStore.totalAmountsInUSD.toInt(),
      isInHeader: true,
      currencyName: '\$USD',
      labelOffset: -2,
      textStyle: TextStyles.sliverSmall,
    );
  }

  Widget getConversion() {
    //return Text(appStore.marketInfo!.price);
    return AmountFormatted(
        amount: 1,
        stringOverride: appStore.marketInfo!.price,
        isInHeader: true,
        currencyName: '\$USD / \$QUBIC',
        labelOffset: -2,
        textStyle: TextStyles.sliverSmall);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
                ThemePaddings.smallPadding,
                ThemePaddings.smallPadding,
                ThemePaddings.smallPadding,
                ThemePaddings.miniPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Total wallet value", style: TextStyles.sliverHeader),
                  Observer(builder: (context) {
                    if (appStore.totalAmountsInUSD == -1) {
                      return Container();
                    }
                    return getTotalQubics();
                  }),
                  Observer(builder: (context) {
                    if (appStore.totalAmountsInUSD == -1) {
                      return Container();
                    }
                    return Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Text("equals to ", style: TextStyles.sliverSmall),
                        getTotalUSD(),
                        const SizedBox(width: 2, height: 5),
                        Text(" at ", style: TextStyles.sliverSmall),
                        getConversion()
                      ],
                    );
                  }),
                ])));
  }
}
