import 'dart:core';
import 'package:mobx/mobx.dart';

class ShareVm {
  late int amount;
  late int tick;

  ShareVm(this.amount, this.tick);
}

@observable
class QubicListVm {
  @observable
  late String _publicId; //The public ID
  @observable
  late String _name; //A descriptive name of the ID
  @observable
  late int? amount; //The amount of the ID

  @observable
  late int? amountTick; //The tick when amount was valid for

  @observable
  Map<String, ShareVm> shares = {};

  @observable
  late bool? hasPendingTransaction;

  QubicListVm(String publicId, String name, this.amount, this.amountTick,
      Map<String, ShareVm>? shares) {
    _publicId = publicId.replaceAll(",", "_");
    _name = name.replaceAll(",", "_");
    this.shares.clear();
    if (shares != null) {
      this.shares.addAll(shares);
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
    shares = {};
  }

  /// Sets the number of shares (without mutation)
  void setShare(String assetName, int numberOfShares, int tick) {
    Map<String, ShareVm> newShares = {};
    newShares.addAll(shares);

    if (((newShares.containsKey(assetName)) &&
            (tick > newShares[assetName]!.tick)) ||
        (newShares.containsKey(assetName) == false)) {
      newShares[assetName] = ShareVm(numberOfShares, tick);
    }
    shares = newShares;
  }

  Map<String, ShareVm> getShares() {
    return shares;
  }

  Map<String, ShareVm> getClonedShares() {
    Map<String, ShareVm> newShares = {};
    shares.forEach((key, value) {
      newShares[key] = ShareVm(value.amount, value.tick);
    });
    return newShares;
  }

  factory QubicListVm.clone(QubicListVm original) {
    return QubicListVm(
        original.publicId,
        original.name,
        original.amount,
        original.amountTick,
        Map<String, ShareVm>.from(original.getClonedShares()));
  }
}
