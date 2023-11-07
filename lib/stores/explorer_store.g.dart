// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explorer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExplorerStore on _ExplorerStore, Store {
  late final _$networkOverviewAtom =
      Atom(name: '_ExplorerStore.networkOverview', context: context);

  @override
  NetworkOverviewDto? get networkOverview {
    _$networkOverviewAtom.reportRead();
    return super.networkOverview;
  }

  @override
  set networkOverview(NetworkOverviewDto? value) {
    _$networkOverviewAtom.reportWrite(value, super.networkOverview, () {
      super.networkOverview = value;
    });
  }

  late final _$tickInfoAtom =
      Atom(name: '_ExplorerStore.tickInfo', context: context);

  @override
  ExplorerTickInfoDto? get tickInfo {
    _$tickInfoAtom.reportRead();
    return super.tickInfo;
  }

  @override
  set tickInfo(ExplorerTickInfoDto? value) {
    _$tickInfoAtom.reportWrite(value, super.tickInfo, () {
      super.tickInfo = value;
    });
  }

  late final _$pendingRequestsAtom =
      Atom(name: '_ExplorerStore.pendingRequests', context: context);

  @override
  int get pendingRequests {
    _$pendingRequestsAtom.reportRead();
    return super.pendingRequests;
  }

  @override
  set pendingRequests(int value) {
    _$pendingRequestsAtom.reportWrite(value, super.pendingRequests, () {
      super.pendingRequests = value;
    });
  }

  late final _$_ExplorerStoreActionController =
      ActionController(name: '_ExplorerStore', context: context);

  @override
  dynamic setExplorerTickInfo(ExplorerTickInfoDto newTickInfo) {
    final _$actionInfo = _$_ExplorerStoreActionController.startAction(
        name: '_ExplorerStore.setExplorerTickInfo');
    try {
      return super.setExplorerTickInfo(newTickInfo);
    } finally {
      _$_ExplorerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearExplorerTickInfo() {
    final _$actionInfo = _$_ExplorerStoreActionController.startAction(
        name: '_ExplorerStore.clearExplorerTickInfo');
    try {
      return super.clearExplorerTickInfo();
    } finally {
      _$_ExplorerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNetworkOverview(NetworkOverviewDto newOverview) {
    final _$actionInfo = _$_ExplorerStoreActionController.startAction(
        name: '_ExplorerStore.setNetworkOverview');
    try {
      return super.setNetworkOverview(newOverview);
    } finally {
      _$_ExplorerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearNetworkOverview() {
    final _$actionInfo = _$_ExplorerStoreActionController.startAction(
        name: '_ExplorerStore.clearNetworkOverview');
    try {
      return super.clearNetworkOverview();
    } finally {
      _$_ExplorerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void incrementPendingRequests() {
    final _$actionInfo = _$_ExplorerStoreActionController.startAction(
        name: '_ExplorerStore.incrementPendingRequests');
    try {
      return super.incrementPendingRequests();
    } finally {
      _$_ExplorerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decreasePendingRequests() {
    final _$actionInfo = _$_ExplorerStoreActionController.startAction(
        name: '_ExplorerStore.decreasePendingRequests');
    try {
      return super.decreasePendingRequests();
    } finally {
      _$_ExplorerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetPendingRequests() {
    final _$actionInfo = _$_ExplorerStoreActionController.startAction(
        name: '_ExplorerStore.resetPendingRequests');
    try {
      return super.resetPendingRequests();
    } finally {
      _$_ExplorerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
networkOverview: ${networkOverview},
tickInfo: ${tickInfo},
pendingRequests: ${pendingRequests}
    ''';
  }
}
