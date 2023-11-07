import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/copyable_text.dart';
import 'package:qubic_wallet/dtos/explorer_tick_info_dto.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

class ExplorerResultPageTickHeader extends StatelessWidget {
  final ExplorerTickInfoDto tickInfo;
  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');

  final Function(int tick)? onTickChange;

  ExplorerResultPageTickHeader(
      {super.key, required this.tickInfo, this.onTickChange});

  @override
  Widget build(BuildContext context) {
    TextStyle panelHeaderStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontFamily: ThemeFonts.secondary);
    TextStyle panelHeaderValue = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontFamily: ThemeFonts.primary);

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Column(children: [
        Container(
            width: double.infinity,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  onTickChange != null
                      ? IconButton(
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            onTickChange!(tickInfo.tick - 1);
                          },
                          icon: const Icon(Icons.keyboard_arrow_left_sharp))
                      : Container(),
                  Text("Tick ${tickInfo.tick.asThousands()}",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontFamily: ThemeFonts.primary)),
                  onTickChange != null
                      ? IconButton(
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            onTickChange!(tickInfo.tick + 1);
                          },
                          icon: const Icon(Icons.keyboard_arrow_right_sharp))
                      : Container()
                ])),
      ]),
      tickInfo.timestamp != null
          ? Text(formatter.format(tickInfo.timestamp!.toLocal()))
          : Container(),
      const SizedBox(height: ThemePaddings.normalPadding),
      Flex(direction: Axis.horizontal, children: [
        Flexible(
            flex: 1,
            child: Column(
              children: [
                Text("Block Status", style: panelHeaderStyle),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      tickInfo.isNonEmpty
                          ? const Icon(Icons.check, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red),
                      Text(
                        tickInfo.isNonEmpty ? " Non Empty" : " Empty",
                        style: panelHeaderValue,
                      )
                    ]),
              ],
            )),
        Flexible(
            flex: 1,
            child: Column(
              children: [
                Text("Data Status", style: panelHeaderStyle),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      tickInfo.completed
                          ? const Icon(Icons.check, color: Colors.green)
                          : const Icon(Icons.hourglass_empty,
                              color: Colors.yellow),
                      Text(
                        tickInfo.completed ? " Completed" : " Not validated",
                        style: panelHeaderValue,
                      )
                    ]),
              ],
            )),
      ]),
      const SizedBox(height: ThemePaddings.normalPadding),
      Text(
        "Tick Leader - (Short Code / Index)",
        style: panelHeaderStyle,
      ),
      CopyableText(
          copiedText: tickInfo.tickLeaderId,
          child: Text(
              "${tickInfo.tickLeaderId}- (${tickInfo.tickLeaderShortCode} / ${tickInfo.tickLeaderIndex})",
              style: panelHeaderValue,
              textAlign: TextAlign.center)),
      const SizedBox(height: ThemePaddings.smallPadding),
      Container(
        margin: const EdgeInsets.only(top: 5.0),
      ),
    ]);
  }
}
