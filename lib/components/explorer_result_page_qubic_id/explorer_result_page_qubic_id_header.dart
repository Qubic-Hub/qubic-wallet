import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/dtos/explorer_id_info_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

class ExplorerResultPageQubicIdHeader extends StatelessWidget {
  final ExplorerIdInfoDto idInfo;
  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');
  ExplorerResultPageQubicIdHeader({super.key, required this.idInfo});

  //Shows the report of a peer. If IPs are specified
  //they are included
  Widget getPeerReport(
      BuildContext context,
      ExplorerIdInfoReportedValueDto info,
      // ignore: non_constant_identifier_names
      List<String>? IPs) {
    TextStyle panelHeaderStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontFamily: ThemeFonts.secondary);
    TextStyle panelHeaderStyleMany = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontFamily: ThemeFonts.secondary);
    return Container(
        width: double.infinity,
        child: Column(children: [
          IPs != null
              ? Text("Current Value", style: panelHeaderStyle)
              : Text("Value reported by ${info.IP}",
                  style: panelHeaderStyleMany),
          SizedBox(
              width: double.infinity,
              child: FittedBox(
                  child: QubicAmount(
                      amount: info.incomingAmount - info.outgoingAmount))),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("Total incoming"), Text("Total outgoing")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(child: QubicAmount(amount: info.incomingAmount)),
              FittedBox(child: QubicAmount(amount: info.outgoingAmount))
            ],
          ),
          const SizedBox(height: ThemePaddings.normalPadding),
          IPs != null
              ? Column(
                  children: [const Text("Reported by:"), Text(IPs.join(", "))])
              : Container(),
          const Divider(),
        ]));
  }

  List<Widget> showPeerReports(BuildContext context) {
    List<Widget> output = [];
    if (!idInfo.areReportedValuesEqual) {
      for (var element in idInfo.reportedValues) {
        output.add(getPeerReport(context, element, null));
      }
    } else {
      output.add(
          getPeerReport(context, idInfo.reportedValues[0], idInfo.reportedIPs));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Column(children: [
        Text(
          "Qubic ID\n${idInfo.id}",
          softWrap: true,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontFamily: ThemeFonts.primary),
        ),
        const SizedBox(height: ThemePaddings.normalPadding),
        Column(children: showPeerReports(context)),
        Container(
          margin: const EdgeInsets.only(top: 5.0),
        ),
      ])
    ]);
  }
}
