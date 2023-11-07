import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/dtos/explorer_query_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';

class ExplorerResultQubicId extends StatelessWidget {
  final ExplorerQueryDto item;

  const ExplorerResultQubicId({super.key, required this.item});

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
                    resultType: ExplorerResultType.publicId, qubicId: item.id),

                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Text('VIEW ID DETAILS',
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
                const Icon(Icons.computer_outlined),
                Text(" Qubic ID",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontFamily: ThemeFonts.primary)),
              ]),
              const SizedBox(height: ThemePaddings.normalPadding),
              //Text("$lastSearchQuery}"),
              Text(item.id),
              getCardButtons(context, item)
            ])));
  }
}
