import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/amount_formatted.dart';
import 'package:qubic_wallet/components/qubic_amount.dart';
import 'package:qubic_wallet/dtos/explorer_id_info_dto.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

class ExplorerResultPageQubicIdHeader extends StatelessWidget {
  final ExplorerIdInfoDto idInfo;
  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');
  ExplorerResultPageQubicIdHeader({super.key, required this.idInfo});

  Widget incPanel(String title, String contents) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: LightThemeColors.cardBackground,
        ),
        child: Padding(
            padding: const EdgeInsets.all(ThemePaddings.smallPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(title, style: TextStyles.secondaryTextSmall)),
                  FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(children: [
                        Text(contents, style: TextStyles.textExtraLargeBold),
                        ThemedControls.spacerHorizontalMini(),
                        Text("\$QUBIC", style: TextStyles.secondaryTextSmall)
                      ]))
                ])));
  }

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IPs != null
              ? Text("Current Value", style: TextStyles.secondaryTextSmall)
              : Text("Value reported by ${info.IP}",
                  style: panelHeaderStyleMany),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: AmountFormatted(
                  amount: info.incomingAmount - info.outgoingAmount,
                  isInHeader: false,
                  labelOffset: -0,
                  textStyle: TextStyles.textEnormous.copyWith(fontSize: 36),
                  labelStyle: TextStyles.accountAmountLabel,
                  currencyName: '\$QUBIC')),
          ThemedControls.spacerVerticalSmall(),
          Row(children: [
            Expanded(
                child: incPanel("Total incoming",
                    info.incomingAmount.asThousands().toString() + "\$QUBIC")),
            ThemedControls.spacerHorizontalMini(),
            Expanded(
                child: incPanel("Total outgoing",
                    info.outgoingAmount.asThousands().toString() + "\$QUBIC")),
          ]),
          ThemedControls.spacerVerticalSmall(),
          IPs != null
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Reported by:",
                      style: TextStyles.secondaryTextSmall,
                      textAlign: TextAlign.start),
                  Text(IPs.join(", "))
                ])
              : Container(),
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
        ThemedControls.pageHeader(
            headerText: "Qubic Address", subheaderText: idInfo.id),
        Column(children: showPeerReports(context)),
        ThemedControls.spacerVerticalNormal()
      ])
    ]);
  }
}
