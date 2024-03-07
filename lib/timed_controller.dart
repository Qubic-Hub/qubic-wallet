import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qubic_wallet/config.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/globals.dart';
import 'package:qubic_wallet/helpers/global_snack_bar.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/stores/application_store.dart';

class TimedController {
  Timer? _fetchTimer;
  Timer? _fetchTimerSlow;

  DateTime? lastFetch;
  DateTime? lastFetchSlow;

  final ApplicationStore appStore = getIt<ApplicationStore>();
  final QubicLi _apiService = getIt<QubicLi>();
  final GlobalSnackBar _globalSnackBar = getIt<GlobalSnackBar>();
  TimedController();

  /// Fetch balances assets and transactions from the network
  /// Makes four calls (balances, network balances, network assets, network transactions
  /// and updates the store with the results)
  /// Will not make a call if there's a pending call
  /// If any of the calls fail, it shows a snackbar with the error message
  _getNetworkBalancesAndAssets() async {
    try {
      List<String> myIds =
          appStore.currentQubicIDs.map((e) => e.publicId).toList();

      //Fetch balances
      if (!_apiService.gettingCurrentBalances) {
        _apiService.getCurrentBalances(myIds).then((balances) {
          appStore.setCurrentBalances(balances);
        });
      }

      //Fetch network balances
      if (!_apiService.gettingNetworkBalances) {
        _apiService.getNetworkBalances(myIds).then((balances) {
          debugPrint("Got balances for ${balances.length} IDs");
          appStore.setAmounts(balances);
        });
      }

      //Fetch network assets
      if (!_apiService.gettingNetworkAssets) {
        _apiService
            .getCurrentAssets(myIds)
            .then((assets) => appStore.setAssets(assets));
      }

      if (!_apiService.gettingNetworkTransactions) {
        _apiService
            .getTransactions(myIds)
            .then((transactions) => appStore.updateTransactions(transactions));
      }
    } on Exception catch (e) {
      _globalSnackBar.show(e.toString().replaceAll("Exception: ", ""));
    }
  }

  /// Fetch the market info from the backend
  /// If the call fails, it shows a snackbar with the error message
  /// If the call succeeds, it updates the store with the results
  _getMarketInfo() async {
    try {
      _apiService.getMarketInfo().then((marketInfo) {
        debugPrint(
            "Got market info: ${marketInfo.capitalization} ${marketInfo.price} ${marketInfo.currency} ${marketInfo.supply}");
        appStore.setMarketInfo(marketInfo);
      });
    } on Exception catch (e) {
      _globalSnackBar.show(e.toString().replaceAll("Exception: ", ""));
    }
  }

  /// Called by the main timer
  /// Fetches the current tick and the network balances and assets
  /// If the call fails, it shows a snackbar with the error message
  fetchData() async {
    try {
      //Fetch the ticks
      int tick = await _apiService.getCurrentTick();
      appStore.currentTick = tick;
      _getNetworkBalancesAndAssets();
      lastFetch = DateTime.now();
    } on Exception catch (e) {
      _globalSnackBar.show(e.toString().replaceAll("Exception: ", ""));
    }
  }

  /// Called by the slow timer
  /// Fetches the market info
  /// If the call fails, it shows a snackbar with the error message
  /// If the call succeeds, it updates the store with the results

  fetchDataSlow() async {
    try {
      _getMarketInfo();
      lastFetchSlow = DateTime.now();
    } on Exception catch (e) {
      _globalSnackBar.show(e.toString().replaceAll("Exception: ", ""));
    }
  }

  /// Stop the fetching timer
  /// If the timer is not running, it does nothing
  stopFetchTimer() {
    if (_fetchTimer == null) {
      return;
    }
    _fetchTimer!.cancel();
  }

  /// Restart the fetching timer.
  /// If the timer is already running, it stops it and starts it again
  interruptFetchTimer() async {
    if (_fetchTimer == null) {
      return;
    }
    _fetchTimer!.cancel();
    _apiService.resetGetters();

    setupFetchTimer(true);
    if ((lastFetchSlow == null) ||
        (lastFetchSlow!.isBefore(DateTime.now().subtract(
            const Duration(seconds: Config.fetchEverySecondsSlow))))) {
      await fetchDataSlow();
    }
  }

  /// Setup the fetching timer
  setupFetchTimer(bool makeInitialCall) async {
    if (makeInitialCall) {
      await fetchData();
    }
    _fetchTimer = Timer.periodic(
        const Duration(seconds: Config.fetchEverySeconds), (timer) async {
      await fetchData();
    });
  }

  /// Setup the slow fetching timer
  setupSlowTimer(bool makeInitialCall) async {
    if (makeInitialCall) {
      await fetchDataSlow();
    }
    _fetchTimerSlow =
        Timer.periodic(const Duration(seconds: Config.fetchEverySecondsSlow),
            (timerSlow) async {
      await fetchDataSlow();
    });
  }
}
