import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/components/currency_amount.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/qubic_asset.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/stores/application_store.dart';

//TODO Delete me
class CumulativeWalletValue extends StatelessWidget {
  CumulativeWalletValue({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding,
                ThemePaddings.normalPadding, ThemePaddings.normalPadding, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Wallet contents",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontFamily: ThemeFonts.primary)),
                  Observer(builder: (context) {
                    if (appStore.totalAmountsInUSD == -1) {
                      return Container();
                    }
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Total value: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontFamily: ThemeFonts.primary)),
                          CurrencyAmount(
                              amount: appStore.totalAmountsInUSD,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontFamily: ThemeFonts.primary))
                        ]);
                  }),
                  Observer(builder: (context) {
                    if (appStore.marketInfo == null) {
                      return Container();
                    }
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "${appStore.marketInfo!.priceAsDecimal.toString()} USD per \$QUBIC",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontFamily: ThemeFonts.primary)),
                        ]);
                  }),
                  Observer(builder: (context) {
                    if (appStore.currentQubicIDs.length == 1) {
                      return Container();
                    }
                    return FittedBox(
                        child: QubicAmount(amount: appStore.totalAmounts));
                  }),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Observer(builder: (context) {
                      if (appStore.totalShares.isEmpty) {
                        return Container();
                      }
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: getShares(context));
                    }),
                  ),
                  const Divider(),
                  const SizedBox(height: ThemePaddings.normalPadding),
                  const Text(
                    "Accounts in wallet",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: ThemePaddings.normalPadding),
                ])));
  }
}
