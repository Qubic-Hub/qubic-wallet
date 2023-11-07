import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qubic_wallet/config.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/globals.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/stores/application_store.dart';

class TimedController {
  Timer? _fetchTimer;

  final ApplicationStore appStore = getIt<ApplicationStore>();
  final QubicLi _apiService = getIt<QubicLi>();

  TimedController();

  //Fetches data (ticks and contents) from the backend
  fetchData() async {
    //TODO HANDLE ERRORS
    try {
      //Fetch the ticks
      debugPrint("Getting tick...");
      int tick = await _apiService.getCurrentTick();
      appStore.currentTick = tick;

      //Fetch the balances
      final balances = await _apiService.getBalances(
          appStore.currentQubicIDs.map((e) => e.publicId).toList());

      // //Fetch the current balances
      // final currentBalances = await _apiService.getCurrentBalances(
      //     appStore.currentQubicIDs.map((e) => e.publicId).toList());
      // await appStore.setCurrentBalanances(currentBalances);

      final assets = await _apiService.getCurrentAssets(
          appStore.currentQubicIDs.map((e) => e.publicId).toList());

      //await appStore.setAmounts(balances);
      await appStore.setAmountsAndAssets(
          balances, assets); //appStore.setAssets(assets);

      balances.forEach((balance) {
        appStore.updateTransactions(balance.transactions);
      });

      // final ticks = await _apiService.getTicks();
      // currentTick = ticks;

      //Fetch the contents
      // final contents = await _apiService.getContents();
      // currentQubicIDs = ObservableSet.of(contents);
    } on Exception catch (e) {
      SnackBar snackBar =
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", "")));
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  //Stops the fetching timer
  stopFetchTimer() {
    if (_fetchTimer == null) {
      return;
    }
    _fetchTimer!.cancel();
  }

  //Stops the fetching timer. Fetches data once. Restarts the fetching timer.
  interruptFetchTimer() async {
    if (_fetchTimer == null) {
      return;
    }
    _fetchTimer!.cancel();

    setupFetchTimer(true);
  }

  setupFetchTimer(bool makeInitialCall) async {
    if (makeInitialCall) {
      await fetchData();
    }
    _fetchTimer = Timer.periodic(
        const Duration(seconds: Config.fetchEverySeconds), (timer) async {
      await fetchData();
    });
  }
}
