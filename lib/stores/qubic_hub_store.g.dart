// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qubic_hub_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QubicHubStore on _QubicHubStore, Store {
  Computed<bool>? _$updateNeededComputed;

  @override
  bool get updateNeeded =>
      (_$updateNeededComputed ??= Computed<bool>(() => super.updateNeeded,
              name: '_QubicHubStore.updateNeeded'))
          .value;
  Computed<bool>? _$updateAvailableComputed;

  @override
  bool get updateAvailable =>
      (_$updateAvailableComputed ??= Computed<bool>(() => super.updateAvailable,
              name: '_QubicHubStore.updateAvailable'))
          .value;

  late final _$versionInfoAtom =
      Atom(name: '_QubicHubStore.versionInfo', context: context);

  @override
  String? get versionInfo {
    _$versionInfoAtom.reportRead();
    return super.versionInfo;
  }

  @override
  set versionInfo(String? value) {
    _$versionInfoAtom.reportWrite(value, super.versionInfo, () {
      super.versionInfo = value;
    });
  }

  late final _$minVersionAtom =
      Atom(name: '_QubicHubStore.minVersion', context: context);

  @override
  String? get minVersion {
    _$minVersionAtom.reportRead();
    return super.minVersion;
  }

  @override
  set minVersion(String? value) {
    _$minVersionAtom.reportWrite(value, super.minVersion, () {
      super.minVersion = value;
    });
  }

  late final _$buildNumberAtom =
      Atom(name: '_QubicHubStore.buildNumber', context: context);

  @override
  String? get buildNumber {
    _$buildNumberAtom.reportRead();
    return super.buildNumber;
  }

  @override
  set buildNumber(String? value) {
    _$buildNumberAtom.reportWrite(value, super.buildNumber, () {
      super.buildNumber = value;
    });
  }

  late final _$maxVersionAtom =
      Atom(name: '_QubicHubStore.maxVersion', context: context);

  @override
  String? get maxVersion {
    _$maxVersionAtom.reportRead();
    return super.maxVersion;
  }

  @override
  set maxVersion(String? value) {
    _$maxVersionAtom.reportWrite(value, super.maxVersion, () {
      super.maxVersion = value;
    });
  }

  late final _$noticeAtom =
      Atom(name: '_QubicHubStore.notice', context: context);

  @override
  String? get notice {
    _$noticeAtom.reportRead();
    return super.notice;
  }

  @override
  set notice(String? value) {
    _$noticeAtom.reportWrite(value, super.notice, () {
      super.notice = value;
    });
  }

  late final _$settingsAtom =
      Atom(name: '_QubicHubStore.settings', context: context);

  @override
  Settings get settings {
    _$settingsAtom.reportRead();
    return super.settings;
  }

  @override
  set settings(Settings value) {
    _$settingsAtom.reportWrite(value, super.settings, () {
      super.settings = value;
    });
  }

  late final _$updateDetailsAtom =
      Atom(name: '_QubicHubStore.updateDetails', context: context);

  @override
  UpdateDetailsDto? get updateDetails {
    _$updateDetailsAtom.reportRead();
    return super.updateDetails;
  }

  @override
  set updateDetails(UpdateDetailsDto? value) {
    _$updateDetailsAtom.reportWrite(value, super.updateDetails, () {
      super.updateDetails = value;
    });
  }

  late final _$_QubicHubStoreActionController =
      ActionController(name: '_QubicHubStore', context: context);

  @override
  void setUpdateDetails(UpdateDetailsDto? value) {
    final _$actionInfo = _$_QubicHubStoreActionController.startAction(
        name: '_QubicHubStore.setUpdateDetails');
    try {
      return super.setUpdateDetails(value);
    } finally {
      _$_QubicHubStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotice(String? notice) {
    final _$actionInfo = _$_QubicHubStoreActionController.startAction(
        name: '_QubicHubStore.setNotice');
    try {
      return super.setNotice(notice);
    } finally {
      _$_QubicHubStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setVersion(String versionInfo) {
    final _$actionInfo = _$_QubicHubStoreActionController.startAction(
        name: '_QubicHubStore.setVersion');
    try {
      return super.setVersion(versionInfo);
    } finally {
      _$_QubicHubStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBuildNumer(String buildNumber) {
    final _$actionInfo = _$_QubicHubStoreActionController.startAction(
        name: '_QubicHubStore.setBuildNumer');
    try {
      return super.setBuildNumer(buildNumber);
    } finally {
      _$_QubicHubStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMinMaxVersions(String minVersion, String maxVersion) {
    final _$actionInfo = _$_QubicHubStoreActionController.startAction(
        name: '_QubicHubStore.setMinMaxVersions');
    try {
      return super.setMinMaxVersions(minVersion, maxVersion);
    } finally {
      _$_QubicHubStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
versionInfo: ${versionInfo},
minVersion: ${minVersion},
buildNumber: ${buildNumber},
maxVersion: ${maxVersion},
notice: ${notice},
settings: ${settings},
updateDetails: ${updateDetails},
updateNeeded: ${updateNeeded},
updateAvailable: ${updateAvailable}
    ''';
  }
}
