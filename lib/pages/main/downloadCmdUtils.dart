import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:qubic_wallet/components/copyable_text.dart';
import 'package:qubic_wallet/components/gradient_foreground.dart';
import 'package:qubic_wallet/config.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/resources/qubic_cmd_utils.dart';
import 'package:qubic_wallet/stores/settings_store.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/link.dart';
import 'package:path/path.dart' as Path;

class DownloadCmdUtils extends StatefulWidget {
  const DownloadCmdUtils({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DownloadCmdUtilsState createState() => _DownloadCmdUtilsState();
}

class _DownloadCmdUtilsState extends State<DownloadCmdUtils> {
  final SettingsStore settingsStore = getIt<SettingsStore>();
  final QubicCmdUtils cmdUtils = QubicCmdUtils();
  String step = 'intro';
  String directory = '';
  String filename = '';
  bool manualLoading = false;
  late String downloadUrl;
  String? manualError;

  num downloadProgress = 0;
  String? downloadError = null;

  @override
  void initState() {
    super.initState();
    getApplicationSupportDirectory().then((value) {
      setState(() {
        directory = value.path;
        if (UniversalPlatform.isWindows) {
          downloadUrl = Config.qubicHelper.win64.downloadPath;
          filename = Config.qubicHelper.win64.filename;
        } else if (UniversalPlatform.isMacOS) {
          downloadUrl = Config.qubicHelper.macOs64.downloadPath;
          filename = Config.qubicHelper.macOs64.filename;
        } else if (UniversalPlatform.isLinux) {
          downloadUrl = Config.qubicHelper.linux64.downloadPath;
          filename = Config.qubicHelper.linux64.filename;
        }
      });
    });
  }

  Future<void> startDownloading() async {
    //Starts the download
    setState(() {
      downloadProgress = 0;
      downloadError = null;
    });
    Dio dio = Dio();
    try {
      dio.download(
        downloadUrl,
        Path.join(directory, filename),
        onReceiveProgress: (rcv, total) async {
          setState(() {
            downloadProgress = rcv / total;
          });
          if (downloadProgress == 1) {
            if (!await cmdUtils.checkIfUtilitiesExist()) {
              setState(() {
                downloadError = "File not saved successfully. Please try again";
              });
              return;
            }
            if (!await cmdUtils.checkUtilitiesChecksum()) {
              setState(() {
                downloadError =
                    "Downloaded file is corrupt or tampered. Please download again";
              });
              return;
            }
            settingsStore.cmdUtilsAvailable = true;
          }
        },
        deleteOnError: true,
      );
    } catch (e) {
      setState(() {
        downloadError = e.toString();
      });
    }
  }

  Widget getInstructions() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemedControls.pageHeader(headerText: "Manual download instructions"),
          ThemedControls.card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text(
                  "1. Download file from ",
                  textAlign: TextAlign.left,
                ),
                Link(
                    uri: Uri.parse(downloadUrl),
                    target: LinkTarget.blank,
                    builder: (context, followLink) => TextButton(
                        onPressed: followLink, child: Text(downloadUrl))),
              ])),
          ThemedControls.card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text("2. Place it in the following folder"),
                Padding(
                    padding: EdgeInsets.only(left: ThemePaddings.normalPadding),
                    child: CopyableText(
                        child: Text(directory), copiedText: directory)),
                const SizedBox(height: ThemePaddings.miniPadding),
              ])),
          const SizedBox(height: ThemePaddings.miniPadding),
          manualError != null
              ? SizedBox(
                  width: double.infinity,
                  child: Flex(direction: Axis.horizontal, children: [
                    Icon(Icons.warning,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: ThemePaddings.smallPadding),
                    Expanded(
                        child: Text("${manualError}",
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.error)))
                  ]))
              : Container(),
          manualError != null
              ? const SizedBox(height: ThemePaddings.bigPadding)
              : Container(),
          ThemedControls.spacerVerticalNormal(),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: manualLoading == true
                  ? [
                      const CircularProgressIndicator(),
                      const SizedBox(width: ThemePaddings.normalPadding),
                      const Text("Checking...")
                    ]
                  : [
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  step = 'intro';
                                });
                              },
                              child: Text("Back"))),
                      ThemedControls.spacerHorizontalNormal(),
                      Expanded(
                          child: FilledButton(
                              onPressed: () async {
                                setState(() {
                                  manualLoading = true;
                                });
                                if (!await cmdUtils.checkIfUtilitiesExist()) {
                                  setState(() {
                                    manualLoading = false;
                                    manualError =
                                        "Could not find file \"${filename}\" in \"${directory}\"";
                                  });
                                  return;
                                }

                                if (!await cmdUtils.checkUtilitiesChecksum()) {
                                  setState(() {
                                    manualLoading = false;
                                    manualError =
                                        "File found but is corrupt or tampered. Please download and install again";
                                  });
                                  return;
                                }

                                //Let's check the file
                                setState(() {
                                  manualLoading = false;
                                });
                              },
                              child: Text("Done"))),
                    ])
        ]);
  }

  Widget getIntroPage() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      GradientForeground(child: const Icon(Icons.file_present_sharp, size: 90)),
      ThemedControls.spacerVerticalNormal(),
      ThemedControls.pageHeader(headerText: "Missing required files"),
      ThemedControls.spacerVerticalNormal(),
      const Text(
        "Qubic-Helper-Utilities are required to use the Qubic Wallet in Windows, Linux and MacOS. Please download them in order to proceed.",
        textAlign: TextAlign.center,
      ),
      ThemedControls.spacerVerticalHuge(),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        TextButton(
            onPressed: () async {
              setState(() {
                step = "instructions";
                manualError = null;
                manualLoading = false;
              });
            },
            child: const Text("View manual instructions")),
        FilledButton(
            onPressed: () async {
              setState(() {
                step = "autoDownload";
                downloadProgress = 0;
              });
              await startDownloading();
              //settingsStore.cmdUtilsAvailable = true;
            },
            child: const Text("Download automatically")),
      ])
    ]);
  }

  Widget getDownloadingHeader() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: 200,
        width: 200,
        child: CircularPercentIndicator(
            radius: 90.0,
            lineWidth: 8.0,
            percent: downloadProgress.toDouble(),
            center: Text((downloadProgress * 100).round().toString() + "%",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontFamily: ThemeFonts.primary)),
            progressColor: Theme.of(context).colorScheme.primary),
      ),
      Text("Downloading",
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(fontFamily: ThemeFonts.primary)),
      const SizedBox(height: ThemePaddings.bigPadding),
      Text(
        downloadUrl,
        textAlign: TextAlign.center,
      )
    ]);
  }

  Widget getDownloadingError() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Download failed",
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(fontFamily: ThemeFonts.primary)),
      const SizedBox(height: ThemePaddings.normalPadding),
      Text(
        downloadError ?? "Arror",
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: ThemePaddings.normalPadding),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        FilledButton(
            onPressed: () async {
              setState(() {
                downloadError = "This is an error";
                downloadProgress = 0;
              });
              await startDownloading();
              //settingsStore.cmdUtilsAvailable = true;
            },
            child: const Text("Try again")),
        TextButton(
            onPressed: () async {
              setState(() {
                step = "instructions";
                manualError = null;
                manualLoading = false;
              });
            },
            child: const Text("Download manually"))
      ])
    ]);
  }

  Widget getAutoDownload() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      downloadError == null ? getDownloadingHeader() : getDownloadingError(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(ThemePaddings.normalPadding),
                child: Center(
                    child: step == "intro"
                        ? getIntroPage()
                        : step == "instructions"
                            ? getInstructions()
                            : getAutoDownload()))));
  }
}
