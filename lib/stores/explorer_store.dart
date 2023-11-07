// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:qubic_wallet/dtos/explorer_tick_info_dto.dart';
import 'package:qubic_wallet/dtos/network_overview_dto.dart';
part 'explorer_store.g.dart';

// flutter pub run build_runner watch --delete-conflicting-outputs

class ExplorerStore = _ExplorerStore with _$ExplorerStore;

abstract class _ExplorerStore with Store {
  @observable
  NetworkOverviewDto? networkOverview;

  @observable
  ExplorerTickInfoDto? tickInfo;

  @action
  setExplorerTickInfo(ExplorerTickInfoDto newTickInfo) {
    tickInfo = ExplorerTickInfoDto.clone(newTickInfo);
  }

  @action
  clearExplorerTickInfo() {
    tickInfo = null;
  }

  @action
  void setNetworkOverview(NetworkOverviewDto newOverview) {
    networkOverview = NetworkOverviewDto.clone(newOverview);
  }

  @action
  void clearNetworkOverview() {
    networkOverview = null;
  }

  @observable
  int pendingRequests = 0;

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
}
