import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/components/qubic_asset.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/stores/application_store.dart';

class CumulativeWalletValue extends StatelessWidget {
  CumulativeWalletValue({super.key});

  final ApplicationStore appStore = getIt<ApplicationStore>();

  List<Widget> getShares(BuildContext context) {
    List<Widget> shares = [];
    for (var key in appStore.totalShares.keys) {
      shares.add(QubicAsset(
          assetName: key,
          numberOfShares: appStore.totalShares[key],
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.normal, fontFamily: ThemeFonts.primary)));
    }
    return shares;
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
                  Text("Total wallet value",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontFamily: ThemeFonts.primary)),
                  Observer(builder: (context) {
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
                    "Qubic IDs in wallet",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: ThemePaddings.normalPadding),
                ])));
  }
}
