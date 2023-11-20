// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ApplicationStore on _ApplicationStore, Store {
  Computed<int>? _$totalAmountsComputed;

  @override
  int get totalAmounts =>
      (_$totalAmountsComputed ??= Computed<int>(() => super.totalAmounts,
              name: '_ApplicationStore.totalAmounts'))
          .value;
  Computed<Map<String, int>>? _$totalSharesComputed;

  @override
  Map<String, int> get totalShares => (_$totalSharesComputed ??=
          Computed<Map<String, int>>(() => super.totalShares,
              name: '_ApplicationStore.totalShares'))
      .value;

  late final _$currentTickAtom =
      Atom(name: '_ApplicationStore.currentTick', context: context);

  @override
  int get currentTick {
    _$currentTickAtom.reportRead();
    return super.currentTick;
  }

  @override
  set currentTick(int value) {
    _$currentTickAtom.reportWrite(value, super.currentTick, () {
      super.currentTick = value;
    });
  }

  late final _$isSignedInAtom =
      Atom(name: '_ApplicationStore.isSignedIn', context: context);

  @override
  bool get isSignedIn {
    _$isSignedInAtom.reportRead();
    return super.isSignedIn;
  }

  @override
  set isSignedIn(bool value) {
    _$isSignedInAtom.reportWrite(value, super.isSignedIn, () {
      super.isSignedIn = value;
    });
  }

  late final _$currentQubicIDsAtom =
      Atom(name: '_ApplicationStore.currentQubicIDs', context: context);

  @override
  ObservableList<QubicListVm> get currentQubicIDs {
    _$currentQubicIDsAtom.reportRead();
    return super.currentQubicIDs;
  }

  @override
  set currentQubicIDs(ObservableList<QubicListVm> value) {
    _$currentQubicIDsAtom.reportWrite(value, super.currentQubicIDs, () {
      super.currentQubicIDs = value;
    });
  }

  late final _$currentTransactionsAtom =
      Atom(name: '_ApplicationStore.currentTransactions', context: context);

  @override
  ObservableList<TransactionVm> get currentTransactions {
    _$currentTransactionsAtom.reportRead();
    return super.currentTransactions;
  }

  @override
  set currentTransactions(ObservableList<TransactionVm> value) {
    _$currentTransactionsAtom.reportWrite(value, super.currentTransactions, () {
      super.currentTransactions = value;
    });
  }

  late final _$transactionFilterAtom =
      Atom(name: '_ApplicationStore.transactionFilter', context: context);

  @override
  TransactionFilter? get transactionFilter {
    _$transactionFilterAtom.reportRead();
    return super.transactionFilter;
  }

  @override
  set transactionFilter(TransactionFilter? value) {
    _$transactionFilterAtom.reportWrite(value, super.transactionFilter, () {
      super.transactionFilter = value;
    });
  }

  late final _$pendingRequestsAtom =
      Atom(name: '_ApplicationStore.pendingRequests', context: context);

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

  late final _$biometricSignInAsyncAction =
      AsyncAction('_ApplicationStore.biometricSignIn', context: context);

  @override
  Future<void> biometricSignIn() {
    return _$biometricSignInAsyncAction.run(() => super.biometricSignIn());
  }

  late final _$signInAsyncAction =
      AsyncAction('_ApplicationStore.signIn', context: context);

  @override
  Future<bool> signIn(String password) {
    return _$signInAsyncAction.run(() => super.signIn(password));
  }

  late final _$signUpAsyncAction =
      AsyncAction('_ApplicationStore.signUp', context: context);

  @override
  Future<bool> signUp(String password) {
    return _$signUpAsyncAction.run(() => super.signUp(password));
  }

  late final _$signOutAsyncAction =
      AsyncAction('_ApplicationStore.signOut', context: context);

  @override
  Future signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  late final _$addIdAsyncAction =
      AsyncAction('_ApplicationStore.addId', context: context);

  @override
  Future<void> addId(String name, String publicId, String privateSeed) {
    return _$addIdAsyncAction
        .run(() => super.addId(name, publicId, privateSeed));
  }

  late final _$setNameAsyncAction =
      AsyncAction('_ApplicationStore.setName', context: context);

  @override
  Future<void> setName(String publicId, String name) {
    return _$setNameAsyncAction.run(() => super.setName(publicId, name));
  }

  late final _$setBalancesAndAssetsAsyncAction =
      AsyncAction('_ApplicationStore.setBalancesAndAssets', context: context);

  @override
  Future<void> setBalancesAndAssets(
      List<CurrentBalanceDto> balances, List<QubicAssetDto> assets) {
    return _$setBalancesAndAssetsAsyncAction
        .run(() => super.setBalancesAndAssets(balances, assets));
  }

  late final _$setAmountsAndAssetsAsyncAction =
      AsyncAction('_ApplicationStore.setAmountsAndAssets', context: context);

  @override
  Future<void> setAmountsAndAssets(
      List<BalanceDto> balances, List<QubicAssetDto> assets) {
    return _$setAmountsAndAssetsAsyncAction
        .run(() => super.setAmountsAndAssets(balances, assets));
  }

  late final _$setAssetsAsyncAction =
      AsyncAction('_ApplicationStore.setAssets', context: context);

  @override
  Future<void> setAssets(List<QubicAssetDto> assets) {
    return _$setAssetsAsyncAction.run(() => super.setAssets(assets));
  }

  late final _$setAmountsAsyncAction =
      AsyncAction('_ApplicationStore.setAmounts', context: context);

  @override
  Future<void> setAmounts(List<BalanceDto> balances) {
    return _$setAmountsAsyncAction.run(() => super.setAmounts(balances));
  }

  late final _$setCurrentBalanancesAsyncAction =
      AsyncAction('_ApplicationStore.setCurrentBalanances', context: context);

  @override
  Future<void> setCurrentBalanances(List<CurrentBalanceDto> balances) {
    return _$setCurrentBalanancesAsyncAction
        .run(() => super.setCurrentBalanances(balances));
  }

  late final _$updateTransactionsAsyncAction =
      AsyncAction('_ApplicationStore.updateTransactions', context: context);

  @override
  Future<void> updateTransactions(List<TransactionDto> transactions) {
    return _$updateTransactionsAsyncAction
        .run(() => super.updateTransactions(transactions));
  }

  late final _$removeIDAsyncAction =
      AsyncAction('_ApplicationStore.removeID', context: context);

  @override
  Future<void> removeID(String publicId) {
    return _$removeIDAsyncAction.run(() => super.removeID(publicId));
  }

  late final _$_ApplicationStoreActionController =
      ActionController(name: '_ApplicationStore', context: context);

  @override
  void incrementPendingRequests() {
    final _$actionInfo = _$_ApplicationStoreActionController.startAction(
        name: '_ApplicationStore.incrementPendingRequests');
    try {
      return super.incrementPendingRequests();
    } finally {
      _$_ApplicationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decreasePendingRequests() {
    final _$actionInfo = _$_ApplicationStoreActionController.startAction(
        name: '_ApplicationStore.decreasePendingRequests');
    try {
      return super.decreasePendingRequests();
    } finally {
      _$_ApplicationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetPendingRequests() {
    final _$actionInfo = _$_ApplicationStoreActionController.startAction(
        name: '_ApplicationStore.resetPendingRequests');
    try {
      return super.resetPendingRequests();
    } finally {
      _$_ApplicationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTransactionFilters(String? qubicId,
      ComputedTransactionStatus? status, TransactionDirection? direction) {
    final _$actionInfo = _$_ApplicationStoreActionController.startAction(
        name: '_ApplicationStore.setTransactionFilters');
    try {
      return super.setTransactionFilters(qubicId, status, direction);
    } finally {
      _$_ApplicationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearTransactionFilters() {
    final _$actionInfo = _$_ApplicationStoreActionController.startAction(
        name: '_ApplicationStore.clearTransactionFilters');
    try {
      return super.clearTransactionFilters();
    } finally {
      _$_ApplicationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentTick: ${currentTick},
isSignedIn: ${isSignedIn},
currentQubicIDs: ${currentQubicIDs},
currentTransactions: ${currentTransactions},
transactionFilter: ${transactionFilter},
pendingRequests: ${pendingRequests},
totalAmounts: ${totalAmounts},
totalShares: ${totalShares}
    ''';
  }
}
