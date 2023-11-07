import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/dtos/explorer_query_dto.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';

class ExplorerResultTransaction extends StatelessWidget {
  final ExplorerQueryDto item;

  const ExplorerResultTransaction({super.key, required this.item});

  Widget getInfoLabel(BuildContext context, String text) {
    return Text(text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold, fontFamily: ThemeFonts.secondary));
  }

  Widget getCardButtons(BuildContext context, ExplorerQueryDto info) {
    return ButtonBar(
        alignment: MainAxisAlignment.start,
        buttonPadding: const EdgeInsets.all(ThemePaddings.miniPadding),
        children: [
          TextButton(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: ExplorerResultPage(
                    resultType: ExplorerResultType.tick,
                    tick: info.tick,
                    focusedTransactionHash: item.id),

                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Text('VIEW TRANSACTION TICK DETAILS',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    )),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Container(
            padding: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding,
                ThemePaddings.normalPadding, ThemePaddings.normalPadding, 0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(children: [
                const Icon(Icons.compare_arrows),
                Text(" Transaction",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontFamily: ThemeFonts.primary)),
              ]),
              const SizedBox(height: ThemePaddings.normalPadding),
              Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: getInfoLabel(context, "ID")),
                    Expanded(flex: 10, child: Text(item.id)),
                  ]),
              Flex(direction: Axis.horizontal, children: [
                Expanded(flex: 2, child: getInfoLabel(context, "Tick")),
                Expanded(
                    flex: 10,
                    child: Text(item.description != null
                        ? int.parse(item.description!.replaceAll("Tick: ", ""))
                            .asThousands()
                        : "")),
              ]),
              getCardButtons(context, item)
            ])));
  }
}
