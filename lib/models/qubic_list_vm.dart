import 'dart:core';
import 'package:mobx/mobx.dart';
import 'package:qubic_wallet/dtos/qubic_asset_dto.dart';

@observable
class QubicListVm {
  @observable
  late String _publicId; //The public ID
  @observable
  late String _name; //A descriptive  name of the ID
  @observable
  late int? amount; //The amount of the ID

  @observable
  late int? amountTick; //The tick when amount was valid for

  @observable
  Map<String, QubicAssetDto> assets = {};

  @observable
  late bool? hasPendingTransaction;

  QubicListVm(String publicId, String name, this.amount, this.amountTick,
      Map<String, QubicAssetDto>? assets) {
    _publicId = publicId.replaceAll(",", "_");
    _name = name.replaceAll(",", "_");
    this.assets.clear();
    if (assets != null) {
      this.assets.addAll(assets);
    }
  }

  set publicId(String publicId) {
    _publicId = publicId.replaceAll(",", "_");
  }

  String get publicId {
    return _publicId;
  }

  set name(String name) {
    _name = name.replaceAll(",", "_");
  }

  String get name {
    return _name;
  }

  void clearShares() {
    assets = {};
  }

  /// Sets the number of shares (without mutation)
  void setAssets(List<QubicAssetDto> newAssets) {
    Map<String, QubicAssetDto> mergedAssets = {};

    for (int i = 0; i < newAssets.length; i++) {
      String name = "${newAssets[i].assetName}-${newAssets[i].contractIndex}";
      if (mergedAssets.containsKey(name)) {
        if (mergedAssets[name]!.tick < newAssets[i].tick) {
          mergedAssets[name] = newAssets[i].clone();
        }
      } else {
        mergedAssets[name] = newAssets[i].clone();
      }
    }

    assets = Map<String, QubicAssetDto>.from(mergedAssets);
  }

  Map<String, QubicAssetDto> getAssets() {
    return assets;
  }

  Map<String, QubicAssetDto> getClonedAssets() {
    Map<String, QubicAssetDto> newShares = {};
    assets.forEach((key, value) {
      newShares[key] = QubicAssetDto(
          assetName: value.assetName,
          contractIndex: value.contractIndex,
          tick: value.tick,
          contractName: value.contractName,
          issuerIdentity: value.issuerIdentity,
          ownedAmount: value.ownedAmount,
          possessedAmount: value.possessedAmount,
          publicId: value.publicId,
          reportingNodes: value.reportingNodes);
    });
    return newShares;
  }

  factory QubicListVm.clone(QubicListVm original) {
    return QubicListVm(
        original.publicId,
        original.name,
        original.amount,
        original.amountTick,
        Map<String, QubicAssetDto>.from(original.getClonedAssets()));
  }
}
