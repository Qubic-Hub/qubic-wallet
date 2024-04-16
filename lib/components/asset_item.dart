import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:qubic_wallet/components/amount_formatted.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/qubic_asset_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/transfer_asset.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/styles/textStyles.dart';
import 'package:qubic_wallet/styles/themed_controls.dart';

class AssetItem extends StatefulWidget {
  final QubicListVm account;
  final QubicAssetDto asset;
  const AssetItem({super.key, required this.account, required this.asset});

  @override
  // ignore: library_private_types_in_public_api
  _AssetItemState createState() => _AssetItemState();
}

class _AssetItemState extends State<AssetItem> {
  final ApplicationStore appStore = getIt<ApplicationStore>();

  String? generatedPublicId;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getAssetButtonBar(QubicAssetDto asset) {
    return Container(
      child: ButtonBar(
          alignment: MainAxisAlignment.start,
          buttonPadding:
              const EdgeInsets.fromLTRB(ThemePaddings.hugePadding, 0, 0, 0),
          children: [
            ThemedControls.primaryButtonBig(
                onPressed: () {
                  // Perform some action
                  pushNewScreen(
                    context,
                    screen: TransferAsset(
                        item: widget.account, asset: widget.asset),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                text: "Send",
                icon: LightThemeColors.shouldInvertIcon
                    ? ThemedControls.invertedColors(
                        child: Image.asset("assets/images/send.png"))
                    : Image.asset("assets/images/send.png")),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Card(
            color: LightThemeColors.cardBackground,
            elevation: 0,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      ThemePaddings.normalPadding,
                      ThemePaddings.normalPadding,
                      ThemePaddings.normalPadding,
                      0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(widget.asset.assetName,
                                  style: TextStyles.accountName)),
                        ]),
                        Text("Valid for tick " + widget.asset.tick.toString(),
                            style: TextStyles.assetSecondaryTextLabel),
                        SizedBox(height: ThemePaddings.normalPadding),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Owned",
                                  style: TextStyles.assetSecondaryTextLabel),
                              Text("${widget.asset.ownedAmount ?? "-"}",
                                  style:
                                      TextStyles.assetSecondaryTextLabelValue),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Possessed",
                                  style: TextStyles.assetSecondaryTextLabel),
                              Text("${widget.asset.possessedAmount ?? "-"}",
                                  style:
                                      TextStyles.assetSecondaryTextLabelValue),
                            ]),
                        SizedBox(height: ThemePaddings.miniPadding),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Contract name ",
                                  style: TextStyles.assetSecondaryTextLabel),
                              Text("${widget.asset.contractName}",
                                  style:
                                      TextStyles.assetSecondaryTextLabelValue),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Contract Index ",
                                  style: TextStyles.assetSecondaryTextLabel),
                              Text("${widget.asset.contractIndex}",
                                  style:
                                      TextStyles.assetSecondaryTextLabelValue),
                            ]),
                      ])),
              getAssetButtonBar(widget.asset),
            ])));
    // return Card(
    //     elevation: 5,
    //     child: Column(children: [
    //       Padding(
    //           padding: const EdgeInsets.fromLTRB(
    //               ThemePaddings.normalPadding,
    //               ThemePaddings.miniPadding,
    //               ThemePaddings.normalPadding,
    //               ThemePaddings.smallPadding),
    //           child: Column(children: [
    //             Container(),
    //             Text("valid for tick " + widget.asset.tick.toString(),
    //                 textAlign: TextAlign.right,
    //                 style: Theme.of(context).textTheme.titleSmall!.copyWith(
    //                     fontFamily: ThemeFonts.primary,
    //                     fontWeight: FontWeight.w300)),
    //             Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: [
    //                   Text(widget.asset.assetName,
    //                       textAlign: TextAlign.center,
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .headlineLarge!
    //                           .copyWith(
    //                               fontFamily: ThemeFonts.primary,
    //                               fontWeight: FontWeight.bold)),
    //                   Text("Possessed: ${widget.asset.possessedAmount ?? "-"}",
    //                       textAlign: TextAlign.center,
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .titleLarge!
    //                           .copyWith(
    //                               fontFamily: ThemeFonts.primary,
    //                               fontWeight: FontWeight.w500)),
    //                   Text("/",
    //                       textAlign: TextAlign.center,
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .titleLarge!
    //                           .copyWith(fontFamily: ThemeFonts.primary)),
    //                   Text("Owned: ${widget.asset.ownedAmount ?? "-"}",
    //                       textAlign: TextAlign.center,
    //                       style: Theme.of(context)
    //                           .textTheme
    //                           .titleLarge!
    //                           .copyWith(
    //                               fontFamily: ThemeFonts.primary,
    //                               fontWeight: FontWeight.w500)),
    //                 ]),
    //             const Divider(),
    //             Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: [
    //                   Column(children: [
    //                     Text("Contract index",
    //                         style: Theme.of(context).textTheme.bodySmall!),
    //                     Text("${widget.asset.contractIndex}")
    //                   ]),
    //                   Column(children: [
    //                     Text("Contact name",
    //                         style: Theme.of(context).textTheme.bodySmall!),
    //                     Text(widget.asset.contractName)
    //                   ]),
    //                 ]),
    //           ])),
    //       getAssetButtonBar(widget.asset)
    //     ]));
  }
}
