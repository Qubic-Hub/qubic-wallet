// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/balance_dto.dart';
import 'package:qubic_wallet/dtos/current_balance_dto.dart';
import 'package:qubic_wallet/dtos/qubic_asset_dto.dart';
import 'package:qubic_wallet/dtos/transaction_dto.dart';
import 'package:qubic_wallet/models/qubic_id.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/models/transaction_filter.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';
import 'package:qubic_wallet/resources/secure_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
part 'application_store.g.dart';

// flutter pub run build_runner watch --delete-conflicting-outputs

class ApplicationStore = _ApplicationStore with _$ApplicationStore;

abstract class _ApplicationStore with Store {
  late final SecureStorage secureStorage = getIt<SecureStorage>();

  @observable
  int currentTick = 0;

  @observable
  bool isSignedIn = false;

  @observable
  ObservableList<QubicListVm> currentQubicIDs = ObservableList<QubicListVm>();
  @observable
  ObservableList<TransactionVm> currentTransactions =
      ObservableList<TransactionVm>();

  @observable
  TransactionFilter? transactionFilter = TransactionFilter();

  @observable
  int pendingRequests = 0; //The number of pending HTTP requests

  @computed
  int get totalAmounts {
    return currentQubicIDs.fold<int>(
        0, (sum, qubic) => sum + (qubic.amount ?? 0));
  }

  @computed
  Map<String, int> get totalShares {
    //Get all shares
    Map<String, int> shares = <String, int>{};
    currentQubicIDs.forEach((element) {
      element.shares.forEach((key, value) {
        if (shares.containsKey(key)) {
          shares[key] = shares[key]! + value;
        } else {
          shares[key] = value;
        }
      });
    });
    return shares;
  }

  @action
  void incrementPendingRequests() {
    pendingRequests++;
  }

  @action
  void decreasePendingRequests() {
    pendingRequests--;
  }

  @action
  void resetPendingRequests() {
    pendingRequests = 0;
  }

  /// Gets the stored seed by a public Id
  Future<String> getSeedByPublicId(String publicId) async {
    var result = await secureStorage.getIdByPublicKey(publicId);
    return result.getPrivateSeed();
  }

  @action
  setTransactionFilters(String? qubicId, ComputedTransactionStatus? status,
      TransactionDirection? direction) {
    transactionFilter = TransactionFilter(
        qubicId: qubicId, status: status, direction: direction);
  }

  @action
  clearTransactionFilters() {
    transactionFilter = TransactionFilter();
  }

  @action
  Future<void> biometricSignIn() async {
    try {
      isSignedIn = true;
      final results = await secureStorage.getWalletContents();
      currentQubicIDs = ObservableList.of(results);
    } catch (e) {
      isSignedIn = false;
    }
  }

  @action
  Future<bool> signIn(String password) async {
    try {
      final result = await secureStorage.signInWallet(password);
      isSignedIn = result;

      //Populate the list
      final results = await secureStorage.getWalletContents();
      currentQubicIDs = ObservableList.of(results);
      return result;
    } catch (e) {
      isSignedIn = false;
      return false;
    }
  }

  @action
  Future<bool> signUp(String password) async {
    await secureStorage.deleteWallet();
    final result = await secureStorage.createWallet(password);
    isSignedIn = result;
    currentQubicIDs = ObservableList<QubicListVm>();
    return isSignedIn;
  }

  @action
  signOut() async {
    isSignedIn = false;
    transactionFilter = TransactionFilter();
    currentQubicIDs = ObservableList<QubicListVm>();
    currentTransactions = ObservableList<TransactionVm>();
  }

  @action
  Future<void> addId(String name, String publicId, String privateSeed) async {
    //Todo store in wallet

    await secureStorage.addID(QubicId(privateSeed, publicId, name, null));
    currentQubicIDs.add(QubicListVm(publicId, name, null, null));
  }

  Future<String> getSeedById(String publicId) async {
    var result = await secureStorage.getIdByPublicKey(publicId);
    return result.getPrivateSeed();
  }

  @action
  Future<void> setName(String publicId, String name) async {
    for (var i = 0; i < currentQubicIDs.length; i++) {
      if (currentQubicIDs[i].publicId == publicId) {
        var item = QubicListVm.clone(currentQubicIDs[i]);
        item.name = name;
        currentQubicIDs[i] = item;
        await secureStorage.renameId(publicId, name);
        return;
      }

      //currentQubicIDs.forEach((element) {
    } //);
  }

  @action
  Future<void> setAmountsAndAssets(
      List<BalanceDto> balances, List<QubicAssetDto> assets) async {
    for (var i = 0; i < currentQubicIDs.length; i++) {
      BalanceDto? balance = balances
          .firstWhereOrNull((e) => e.publicId == currentQubicIDs[i].publicId);
      QubicAssetDto? asset = assets
          .firstWhereOrNull((e) => e.publicId == currentQubicIDs[i].publicId);

      if ((asset != null) || (balance != null)) {
        var item = QubicListVm.clone(currentQubicIDs[i]);
        if (asset != null) {
          item.setShare(asset.contractName, asset.ownedAmount);
        }
        if (balance != null) {
          item.amount = balance.currentEstimatedAmount;
        }

        currentQubicIDs[i] = item;
      }
    }
    ObservableList<QubicListVm> newList = ObservableList<QubicListVm>();
    newList.addAll(currentQubicIDs);
    currentQubicIDs = newList;
  }

  @action
  Future<void> setAssets(List<QubicAssetDto> assets) async {
    for (var i = 0; i < currentQubicIDs.length; i++) {
      QubicAssetDto? asset = assets
          .firstWhereOrNull((e) => e.publicId == currentQubicIDs[i].publicId);
      if (asset != null) {
        var item = QubicListVm.clone(currentQubicIDs[i]);
        item.setShare(asset.contractName, asset.ownedAmount);
        currentQubicIDs[i] = item;
      }
    }
  }

  @action
  Future<void> setAmounts(List<BalanceDto> balances) async {
    for (var i = 0; i < currentQubicIDs.length; i++) {
      BalanceDto? balance = balances
          .firstWhereOrNull((e) => e.publicId == currentQubicIDs[i].publicId);
      if (balance != null) {
        var item = QubicListVm.clone(currentQubicIDs[i]);
        item.amount = balance.currentEstimatedAmount;
        currentQubicIDs[i] = item;
      }
    }
  }

  @action
  Future<void> setCurrentBalanances(List<CurrentBalanceDto> balances) async {
    for (var i = 0; i < currentQubicIDs.length; i++) {
      CurrentBalanceDto? balance = balances
          .firstWhereOrNull((e) => e.publicId == currentQubicIDs[i].publicId);
      if (balance != null) {
        var item = QubicListVm.clone(currentQubicIDs[i]);
        item.amount = balance.amount;
        currentQubicIDs[i] = item;
      }
    }
  }

  @action
  Future<void> updateTransactions(List<TransactionDto> transactions) async {
    transactions.forEach((transaction) {
      var existing = currentTransactions
          .firstWhereOrNull((element) => element.id == transaction.id);
      if (existing == null) {
        currentTransactions.add(TransactionVm.fromTransactionDto(transaction));
      } else {
        existing.updateContentsFromTransactionDto(transaction);
      }
    });
  }

  int getQubicIDsWithPublicId(String publicId) {
    return currentQubicIDs
        .where((element) => element.publicId == publicId.replaceAll(",", "_"))
        .length;
  }

  @action
  Future<void> removeID(String publicId) async {
    await secureStorage.removeID(publicId);
    currentQubicIDs.removeWhere(
        (element) => element.publicId == publicId.replaceAll(",", "_"));
    //Remove all from transactions which contain this qubicId and no other wallet ids

    currentTransactions.removeWhere((element) =>
        element.destId == publicId.replaceAll(",", "_") &&
        currentQubicIDs.any(
                (el) => el.publicId == element.sourceId.replaceAll(",", "_")) ==
            false);

    currentTransactions.removeWhere((element) =>
        element.sourceId == publicId.replaceAll(",", "_") &&
        currentQubicIDs.any(
                (el) => el.publicId == element.destId.replaceAll(",", "_")) ==
            false);
  }
}
