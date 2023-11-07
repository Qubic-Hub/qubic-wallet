import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qubic_wallet/dtos/update_details_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:url_launcher/url_launcher.dart';

class AvailableUpdateCard extends StatelessWidget {
  final UpdateDetailsDto updateDetails;

  const AvailableUpdateCard({Key? key, required this.updateDetails})
      : super(key: key);

  Widget getButtonBar(BuildContext context) {
    if (updateDetails.url == null) {
      return Container();
    }
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      buttonPadding: const EdgeInsets.all(ThemePaddings.miniPadding),
      children: [
        TextButton(
          onPressed: () {
            if (updateDetails.url == null) {
              return;
            }
            // Perform some action
            var url = updateDetails.url!
                .replaceAll(":", "")
                .replaceAll("\:", "")
                .replaceAll("\[github\]", "https://github.com/Qubic-Hub/");
            url = url.replaceAll("\[qubichub\]", "https://www.qubic-hub.com/");

            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          },
          child: Text('VISIT DOWNLOAD SITE',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )),
        )
      ],
    );
  }

  getHeadedText(BuildContext context, String header, String text) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: ThemeFonts.secondary)),
          const SizedBox(height: ThemePaddings.smallPadding),
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontFamily: ThemeFonts.secondary))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(ThemePaddings.normalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: double.infinity),
                Row(children: [
                  Icon(Icons.info,
                      color:
                          updateDetails.critical ? Colors.red : Colors.yellow),
                  Text(" Update available",
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontFamily: ThemeFonts.secondary)),
                ]),
                Row(children: [
                  Text("Version ${updateDetails.version}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontFamily: ThemeFonts.secondary)),
                  updateDetails.critical
                      ? Text(" - CRITICAL",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.red,
                                  fontFamily: ThemeFonts.secondary))
                      : Container(),
                ]),
                const Divider(),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: ThemePaddings.smallPadding),
                      updateDetails.message != null
                          ? Text(updateDetails.message!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontFamily: ThemeFonts.secondary))
                          : Container(),
                      updateDetails.major != null
                          ? const SizedBox(height: ThemePaddings.smallPadding)
                          : Container(),
                      getHeadedText(
                          context, "Major changes", updateDetails.major!),
                      updateDetails.minor != null
                          ? const SizedBox(height: ThemePaddings.smallPadding)
                          : Container(),
                      getHeadedText(
                          context, "Other changes", updateDetails.minor!)
                    ]),
                getButtonBar(context)
              ],
            )));
  }
}
