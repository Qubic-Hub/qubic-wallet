import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/qubic_asset_dto.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/pages/main/wallet_contents/transfer_asset.dart';
import 'package:qubic_wallet/stores/application_store.dart';

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
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        child: ButtonBar(
          alignment: MainAxisAlignment.end,
          buttonPadding: const EdgeInsets.all(ThemePaddings.miniPadding),
          children: [
            TextButton(
              onPressed: () {
                // Perform some action
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen:
                      TransferAsset(item: widget.account, asset: widget.asset),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Text('TRANSFER ASSET',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(
                  ThemePaddings.normalPadding,
                  ThemePaddings.miniPadding,
                  ThemePaddings.normalPadding,
                  ThemePaddings.smallPadding),
              child: Column(children: [
                Container(),
                Text("valid for tick " + widget.asset.tick.toString(),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontFamily: ThemeFonts.primary,
                        fontWeight: FontWeight.w300)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.asset.assetName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  fontFamily: ThemeFonts.primary,
                                  fontWeight: FontWeight.bold)),
                      Text("Possessed: ${widget.asset.possessedAmount ?? "-"}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontFamily: ThemeFonts.primary,
                                  fontWeight: FontWeight.w500)),
                      Text("/",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontFamily: ThemeFonts.primary)),
                      Text("Owned: ${widget.asset.ownedAmount ?? "-"}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontFamily: ThemeFonts.primary,
                                  fontWeight: FontWeight.w500)),
                    ]),
                const Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Text("Contract index",
                            style: Theme.of(context).textTheme.bodySmall!),
                        Text("${widget.asset.contractIndex}")
                      ]),
                      Column(children: [
                        Text("Contact name",
                            style: Theme.of(context).textTheme.bodySmall!),
                        Text(widget.asset.contractName)
                      ]),
                    ]),
              ])),
          getAssetButtonBar(widget.asset)
        ]));
  }
}
