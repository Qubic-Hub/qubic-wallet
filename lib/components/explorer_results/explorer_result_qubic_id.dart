import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/gradient_foreground.dart';
import 'package:qubic_wallet/components/radiant_gradient_mask.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/explorer_query_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

import '../../stores/application_store.dart';

class ExplorerResultQubicId extends StatelessWidget {
  final ExplorerQueryDto item;
  final String? walletAccountName;
  const ExplorerResultQubicId(
      {super.key, required this.item, required this.walletAccountName});

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
                  resultType: ExplorerResultType.publicId, qubicId: item.id),

              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          text: "View details")
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ThemedControls.card(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(children: [
        GradientForeground(child: Icon(Icons.computer_outlined)),
        Text(
            " Qubic Address ${walletAccountName != null ? "($walletAccountName)" : ""}",
            style: TextStyles.labelText),
      ]),
      ThemedControls.spacerVerticalNormal(),
      //Text("$lastSearchQuery}"),
      Text(item.id),
      ThemedControls.spacerVerticalNormal(),
      getCardButtons(context, item)
    ]));
  }
}
