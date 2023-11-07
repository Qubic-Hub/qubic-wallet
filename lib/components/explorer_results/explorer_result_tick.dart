import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/dtos/explorer_query_dto.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/explorer/explorer_result_page.dart';

class ExplorerResultTick extends StatelessWidget {
  final ExplorerQueryDto item;

  const ExplorerResultTick({super.key, required this.item});

  Widget getInfoLabel(BuildContext context, String text) {
    return Text(text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold, fontFamily: ThemeFonts.secondary));
  }

  //Get the tick description by parsing formatted output from the API
  Widget getDateTimeFromTickDescription(
      BuildContext context, String tickDescription) {
    try {
      String cleaned =
          tickDescription.replaceAll("Tick: ", "").replaceAll("from ", "");
      List<String> parts = cleaned.split(" ");
      int tickNumber = int.parse(parts[0]);
      String unparsedDate = parts[1];
      String unparsedTime = parts[2];

      List<int> dateParts =
          unparsedDate.split(".").map((e) => int.parse(e)).toList();
      List<int> timeParts =
          unparsedTime.split(":").map((e) => int.parse(e)).toList();

      DateTime date = DateTime.utc(dateParts[2], dateParts[1], dateParts[0],
          timeParts[0], timeParts[1], timeParts[1]);

      final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');

      return Column(children: [
        Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: getInfoLabel(context, "Tick")),
              Expanded(flex: 10, child: Text(tickNumber.asThousands()))
            ]),
        Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: getInfoLabel(context, "Date")),
              Expanded(flex: 10, child: Text(formatter.format(date.toLocal())))
            ])
      ]);
    } catch (e) {
      return Column(children: [
        Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: getInfoLabel(context, "Info")),
              Expanded(flex: 10, child: Text(tickDescription))
            ])
      ]);
    }
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
                    resultType: ExplorerResultType.tick, tick: info.tick),

                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Text('VIEW TICK DETAILS',
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
                const Icon(Icons.grid_view),
                Text(" Tick",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontFamily: ThemeFonts.primary)),
              ]),
              const SizedBox(height: ThemePaddings.normalPadding),
              getDateTimeFromTickDescription(context, item.description ?? "-"),
              getCardButtons(context, item)
            ])));
  }
}
