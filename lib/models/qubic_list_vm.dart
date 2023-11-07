import 'dart:core';

import 'package:mobx/mobx.dart';

@observable
class QubicListVm {
  @observable
  late String _publicId; //The public ID
  @observable
  late String _name; //A descriptive name of the ID
  @observable
  late int? amount; //The amount of the ID

  @observable
  Map<String, int> shares = {};

  QubicListVm(
      String publicId, String name, this.amount, Map<String, int>? shares) {
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
  void setShare(String assetName, int numberOfShares) {
    Map<String, int> newShares = {};
    newShares.addAll(shares);
    newShares[assetName] = numberOfShares;
    shares = newShares;
  }

  Map<String, int> getShares() {
    return shares;
  }

  factory QubicListVm.clone(QubicListVm original) {
    return QubicListVm(original.publicId, original.name, original.amount,
        Map<String, int>.from(original.getShares()));
  }
}
