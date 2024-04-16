import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/gradient_foreground.dart';
import 'package:qubic_wallet/components/radiant_gradient_mask.dart';
import 'package:qubic_wallet/dtos/explorer_query_dto.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

class ExplorerResultTransaction extends StatelessWidget {
  final ExplorerQueryDto item;

  const ExplorerResultTransaction({super.key, required this.item});

  Widget getInfoLabel(BuildContext context, String text) {
    return Text(text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold, fontFamily: ThemeFonts.secondary));
  }

  Widget getCardButtons(BuildContext context, ExplorerQueryDto info) {
    return Row(children: [
      ThemedControls.primaryButtonNormal(
        onPressed: () {
          pushNewScreen(
            context,
            screen: ExplorerResultPage(
                resultType: ExplorerResultType.tick,
                tick: info.tick,
                focusedTransactionHash: item.id),

            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        text: 'View details',
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ThemedControls.card(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(children: [
        //const RadiantGradientMask(child: Icon(Icons.compare_arrows)),
        GradientForeground(child: Icon(Icons.compare_arrows)),
        Text(" Transaction", style: TextStyles.labelText),
      ]),
      ThemedControls.spacerVerticalNormal(),
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
      ThemedControls.spacerVerticalNormal(),
      getCardButtons(context, item)
    ]));
  }
}
