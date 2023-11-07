import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qubic_wallet/components/explorer_result_page_qubic_id/explorer_result_page_qubic_id.dart';
import 'package:qubic_wallet/components/explorer_result_page_tick/explorer_result_page_tick.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/explorer_id_info_dto.dart';
import 'package:qubic_wallet/dtos/explorer_tick_info_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/stores/explorer_store.dart';

enum ExplorerResultType { publicId, tick, transaction }

class ExplorerResultPage extends StatefulWidget {
  final ExplorerResultType resultType;
  final int? tick;
  final String? qubicId;
  final String? focusedTransactionHash;
  const ExplorerResultPage(
      {super.key,
      required this.resultType,
      this.tick,
      this.qubicId,
      this.focusedTransactionHash});

  @override
  // ignore: library_private_types_in_public_api
  _ExplorerResultPageState createState() => _ExplorerResultPageState();
}

class _ExplorerResultPageState extends State<ExplorerResultPage> {
  final ExplorerStore explorerStore = getIt<ExplorerStore>();
  final QubicLi qubicLi = getIt<QubicLi>();

  late int? tick;
  late String? qubicId;
  late ExplorerResultType resultType;
  late String? focusedTransactionHash;

  final DateFormat formatter = DateFormat('dd MMM yyyy \'at\' HH:mm:ss');

  ExplorerTickInfoDto? tickInfo;
  ExplorerIdInfoDto? idInfo;

  bool isLoading = true;
  String? error = "An error";
  @override
  void initState() {
    super.initState();

    focusedTransactionHash = widget.focusedTransactionHash;

    tick = widget.tick;
    qubicId = widget.qubicId;
    resultType = widget.resultType;
    validateNonMissingQueryData();
    getInfo();
  }

  // Validates that query data is not missing for this widget
  void validateNonMissingQueryData() {
    if (((resultType == ExplorerResultType.tick) ||
            (resultType == ExplorerResultType.transaction)) &&
        (tick == null)) {
      throw Exception("Tick cannot be null");
    }
    if ((resultType == ExplorerResultType.publicId) && (qubicId == null)) {
      throw Exception("PublicId cannot be null");
    }
  }

  //Gets info from the backend and stores it in the store
  void getInfo() {
    setState(() {
      isLoading = true;
      error = null;
    });
    if (resultType == ExplorerResultType.tick) {
      qubicLi.getExplorerTickInfo(tick!).then((value) {
        setState(() {
          tickInfo = value;
          isLoading = false;
        });
      },
          onError: (err) => setState(() {
                error = err.toString().replaceAll("Exception: ", "");
              }));
    } else if (resultType == ExplorerResultType.publicId) {
      //PUBLIC ID
      qubicLi.getExplorerIdInfo(qubicId!).then((value) {
        setState(() {
          idInfo = value;
          isLoading = false;
        });
      },
          onError: (err) => setState(() {
                error = err.toString().replaceAll("Exception: ", "");
              }));
    } else if (resultType == ExplorerResultType.transaction) {
      qubicLi.getExplorerTickInfo(tick!).then((value) {
        explorerStore.setExplorerTickInfo(value);
        setState(() {
          tickInfo = value;
          isLoading = false;
        });
      },
          onError: (err) => setState(() {
                error = err.toString().replaceAll("Exception: ", "");
              }));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getErrorView() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: ThemePaddings.normalPadding),
          Text("An error has occured",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontFamily: ThemeFonts.primary)),
          Text(error ?? "-"),
          FilledButton(
              child: const Text("Try again"),
              onPressed: () {
                getInfo();
              })
        ]));
  }

  Widget getLoadingView() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: ThemePaddings.normalPadding),
          Text("Loading...",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontFamily: ThemeFonts.primary))
        ]));
  }

  Widget getHeader() {
    if (resultType == ExplorerResultType.publicId) {
      return Column(children: [
        Text(qubicId!.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontFamily: ThemeFonts.primary))
      ]);
    }
    return Container();
  }

  Widget getScrollView() {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            resultType == ExplorerResultType.tick ||
                    resultType == ExplorerResultType.transaction
                ? ExplorerResultPageTick(
                    tickInfo: tickInfo!,
                    focusedTransactionId: focusedTransactionHash,
                    onRequestViewChange: (type, tick, publicId) {
                      if (type == RequestViewChangeType.tick) {
                        setState(() {
                          focusedTransactionHash = null;
                          tickInfo = null;
                          this.tick = tick;
                          getInfo();
                        });
                      } else if (type == RequestViewChangeType.publicId) {
                        setState(() {
                          focusedTransactionHash = null;
                          tickInfo = null;
                          qubicId = publicId;
                          getInfo();
                        });
                      }
                    })
                : ExplorerResultPageQubicId(idInfo: idInfo!),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding, 0,
                ThemePaddings.normalPadding, ThemePaddings.miniPadding),
            child: error != null
                ? getErrorView()
                : isLoading
                    ? getLoadingView()
                    : getScrollView()));
  }
}
