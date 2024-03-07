import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobx/mobx.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qubic_wallet/components/asset_item.dart';
import 'package:qubic_wallet/components/copyable_text.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/qubic_asset_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/global_snack_bar.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/transfer_asset.dart';
import 'package:qubic_wallet/smart_contracts/sc_info.dart';

import 'package:qubic_wallet/stores/application_store.dart';
import 'package:share_plus/share_plus.dart';

class Assets extends StatefulWidget {
  final String PublicId;
  const Assets({super.key, required this.PublicId});

  @override
  // ignore: library_private_types_in_public_api
  _AssetsState createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final GlobalSnackBar _globalSnackBar = getIt<GlobalSnackBar>();
  late final QubicListVm accountItem;
  late final reactionDispose;

  String? generatedPublicId;
  @override
  void initState() {
    super.initState();
    reactionDispose = autorun((_) {
      accountItem = appStore.currentQubicIDs
          .firstWhere((element) => element.publicId == widget.PublicId);
    });
  }

  @override
  void dispose() {
    reactionDispose();
    super.dispose();
  }

  Widget getAssetLine(QubicAssetDto asset) {
    return Text(asset.assetName);
  }

  Widget getQXAssets() {
    List<QubicAssetDto> qxAssets = accountItem.assets.values
        .where(
            (element) => QubicAssetDto.isSmartContractShare(element) == false)
        .toList();
    if (qxAssets.isEmpty) {
      return Container();
    }

    List<Widget> output = [];
    output.add(const Text("QX Issued Tokens"));
    qxAssets.forEach((element) => output.add(getAssetEntry(element)));
    return Column(children: output);
  }

  Widget getSCAssets() {
    List<QubicAssetDto> scAssets = accountItem.assets.values
        .where((element) => QubicAssetDto.isSmartContractShare(element))
        .toList();
    if (scAssets.isEmpty) {
      return Container();
    }

    List<Widget> output = [];

    output.add(const Text("Smart Contract Shares"));
    scAssets.forEach((element) => output.add(getAssetEntry(element)));
    return Column(children: output);
  }

  Widget getAssetEntry(QubicAssetDto asset) {
    return AssetItem(account: accountItem, asset: asset);
  }

  Widget getScrollView() {
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Row(children: [
          Container(
              child: Expanded(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Assets of \"${accountItem.name}\"",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontFamily: ThemeFonts.primary)),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: ThemePaddings.normalPadding),
                  child: Column(
                    children: [
                      Container(color: Colors.red),
                      getSCAssets(),
                      const SizedBox(height: ThemePaddings.bigPadding),
                      getQXAssets(),
                      const SizedBox(height: ThemePaddings.miniPadding),
                    ],
                  ))
            ],
          )))
        ]));
  }

  List<Widget> getButtons() {
    return [
      FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "CLOSE",
          ))
    ];
  }

  void saveIdHandler() async {
    _formKey.currentState?.validate();
    if (!_formKey.currentState!.isValid) {
      return;
    }

    //Prevent duplicates

    if (appStore.currentQubicIDs
        .where(((element) =>
            element.publicId == generatedPublicId!.replaceAll(",", "_")))
        .isNotEmpty) {
      _globalSnackBar.show("This ID already exists in your wallet", true);

      return;
    }

    setState(() {
      isLoading = true;
    });
    appStore.addId(
      _formKey.currentState?.instantValue["accountName"] as String,
      generatedPublicId!,
      _formKey.currentState?.instantValue["privateSeed"] as String,
    );

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);
  }

  TextEditingController privateSeed = TextEditingController();

  bool showAccountInfoTooltip = false;
  bool showSeedInfoTooltip = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(!isLoading);
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
                minimum: const EdgeInsets.fromLTRB(ThemePaddings.normalPadding,
                    0, ThemePaddings.normalPadding, ThemePaddings.miniPadding),
                child: Column(children: [
                  Expanded(child: getScrollView()),
                ]))));
  }
}
