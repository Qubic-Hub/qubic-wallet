// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qubic_wallet/config.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/auth_login_dto.dart';
import 'package:qubic_wallet/dtos/balance_dto.dart';
import 'package:qubic_wallet/dtos/current_balance_dto.dart';
import 'package:qubic_wallet/dtos/current_tick_dto.dart';
import 'package:qubic_wallet/dtos/explorer_id_info_dto.dart';
import 'package:qubic_wallet/dtos/explorer_query_dto.dart';
import 'package:qubic_wallet/dtos/explorer_tick_info_dto.dart';
import 'package:qubic_wallet/dtos/network_overview_dto.dart';
import 'package:qubic_wallet/dtos/qubic_asset_dto.dart';
import 'package:qubic_wallet/dtos/transaction_dto.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/explorer_store.dart';
import 'package:qubic_wallet/dtos/market_info_dto.dart';

class QubicLi {
  ApplicationStore appStore = getIt<ApplicationStore>();
  ExplorerStore explorerStore = getIt<ExplorerStore>();
  String? _authenticationToken;
  // ignore: unused_field
  String? _refreshToken;
  String? get authenticationToken => _authenticationToken;

  bool _gettingNetworkBalances = false;
  bool _gettingCurrentBalances = false;
  bool _gettingNetworkAssets = false;
  bool _gettingNetworkTransactions = false;

  bool get gettingNetworkBalances => _gettingNetworkBalances;
  bool get gettingNetworkAssets => _gettingNetworkAssets;
  bool get gettingNetworkTransactions => _gettingNetworkTransactions;
  bool get gettingCurrentBalances => _gettingCurrentBalances;

  void resetGetters() {
    _gettingNetworkBalances = false;
    _gettingCurrentBalances = false;
    _gettingNetworkAssets = false;
    _gettingNetworkTransactions = false;
  }

  static Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept-Language': 'en-US,en;q=0.9',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
      'Host': 'api.qubic.li',
      'Pragma': 'no-cache',
      'Referer': 'https://wallet.qubic.li',
      'Origin': 'https://wallet.qublic.li',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36',
      'Sec-Ch-Ua':
          '"Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"',
      'Sec-Ch-Ua-Mobile': '?0',
      'Sec-Ch-Ua-Platform': '"Windows"',
      'Sec-Fetch-Dest': 'empty',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Site': 'same-site'
    };
  }

  void _assertAuthorized() {
    if (_authenticationToken == null) {
      throw Exception('Failed to contact qubic network. Not authenticated');
    }
  }

  void _assert200Response(int statusCode) {
    if (statusCode != 200) {
      throw Exception(
          'Failed to perform action. Server returned status $statusCode');
    }
  }

  /// Authenticates with Qubic.li and stores authentication cookie in memory
  Future<void> authenticate() async {
    appStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({
        'Content-Type': 'application/json',
      });
      response = await http.post(
          Uri.https(Config.walletDomain, Config.URL_Login),
          body: json.encode({
            'username': Config.authUser,
            'password': Config.authPass,
            'twoFactorCode': ""
          }),
          headers: headers);
      appStore.decreasePendingRequests();
    } catch (e) {
      appStore.decreasePendingRequests();
      throw Exception('Failed to contact server.');
    }

    if (response.statusCode == 200) {
      late dynamic parsedJson;
      late AuthLoginDto loginDto;
      try {
        parsedJson = jsonDecode(response.body);
      } catch (e) {
        throw Exception('Failed to authenticate. Could not parse response');
      }
      try {
        loginDto = AuthLoginDto.fromJson(parsedJson);
      } catch (e) {
        throw Exception(
            'Failed to authenticate. Server response is missing required info');
      }
      if (!loginDto.success) {
        throw Exception('Failed to authenticate. Wrong server credentials');
      }
      _authenticationToken = loginDto.token;
      _refreshToken = loginDto.refreshToken;
    } else {
      throw Exception(
          'Failed to authenticate. Got status response ${response.statusCode}');
    }
  }

  /// Submits a transcation (with amount transfer) to the Qubic network
  Future<String> submitTransaction(String transaction) async {
    appStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({
        'Authorization': 'bearer ${_authenticationToken!}',
        'Content-Type': 'application/json'
      });
      response = await http.post(
          Uri.https(Config.walletDomain, Config.URL_Transaction),
          body: json.encode({'SignedTransaction': transaction}),
          headers: headers);
      appStore.decreasePendingRequests();
    } catch (e) {
      appStore.decreasePendingRequests();
      throw Exception('Failed to contact server for submitting transaction.');
    }
    print(response.body);
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception(
          'Failed to submit transaction. Could not parse response.');
    }
    return parsedJson['id'];
  }

  /// Gets current tick form the Qubic network
  Future<int> getCurrentTick() async {
    _assertAuthorized();
    appStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({'Authorization': 'bearer ${_authenticationToken!}'});
      response = await http.get(Uri.https(Config.walletDomain, Config.URL_Tick),
          headers: headers);

      appStore.decreasePendingRequests();
    } catch (e) {
      appStore.decreasePendingRequests();
      throw Exception('Failed to contact server for fetching ticks.');
    }
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    late CurrentTickDto tickDto;
    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch ticks. Could not parse response');
    }
    try {
      tickDto = CurrentTickDto.fromJson(parsedJson);
    } catch (e) {
      throw Exception(
          'Failed to fetch ticks. Server response is missing required info');
    }

    return tickDto.tick;
  }

  // Gets the Qubic network overview for use in explorer
  Future<NetworkOverviewDto> getNetworkOverview() async {
    _assertAuthorized();
    appStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({
        'Authorization': 'bearer ${_authenticationToken!}',
        'Content-Type': 'application/json'
      });
      response = response = await http.get(
          Uri.https(Config.walletDomain, Config.URL_TickOverview),
          headers: headers);
      appStore.decreasePendingRequests();
    } catch (e) {
      appStore.decreasePendingRequests();
      throw Exception('Failed to contact server for fetching tick overview.');
    }
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    late NetworkOverviewDto networkOverviewDto;
    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception(
          'Failed to fetch tick overview. Could not parse response');
    }
    try {
      networkOverviewDto = NetworkOverviewDto.fromJson(parsedJson);
    } catch (e) {
      throw Exception(
          'Failed to fetch tick overview. Server response is missing required info');
    }
    return networkOverviewDto;
  }

  ///Gets the transactions from the network
  ///@param publicIds - List of public IDs to get transactions for
  ///@return List of transactions
  Future<List<TransactionDto>> getTransactions(List<String> publicIds) async {
    _assertAuthorized();
    appStore.incrementPendingRequests();
    _gettingNetworkTransactions = true;
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({
        'Authorization': 'bearer ${_authenticationToken!}',
        'Content-Type': 'application/json'
      });
      response = await http.post(
          Uri.https(Config.walletDomain, Config.URL_NetworkTransactions),
          body: json.encode(publicIds),
          headers: headers);

      appStore.decreasePendingRequests();
      _gettingNetworkTransactions = false;
    } catch (e) {
      _gettingNetworkTransactions = false;
      appStore.decreasePendingRequests();
      throw Exception(
          'Failed to contact server for fetching current transactions.');
    }
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    late var transactions = <TransactionDto>[];

    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception(
          'Failed to fetch current transactions. Could not parse response');
    }
    try {
      transactions = parsedJson
          .map((e) => TransactionDto.fromJson(e))
          .toList()
          .cast<TransactionDto>();
      transactions.sort((a, b) => a.targetTick.compareTo(b.targetTick));
    } catch (e) {
      throw Exception(
          'Failed to fetch current transactions. Server response is missing required info');
    }
    return transactions;
  }

  /// Gets the balances from the network
  /// @param publicIds - List of public IDs to get balances for
  /// @return List of balances
  Future<List<CurrentBalanceDto>> getNetworkBalances(
      List<String> publicIds) async {
    _assertAuthorized();

    _gettingNetworkBalances = true;

    appStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({
        'Authorization': 'bearer ${_authenticationToken!}',
        'Content-Type': 'application/json'
      });
      response = await http.post(
          Uri.https(Config.walletDomain, Config.URL_NetworkBalances),
          body: json.encode(publicIds),
          headers: headers);

      appStore.decreasePendingRequests();
      _gettingNetworkBalances = false;
    } catch (e) {
      appStore.decreasePendingRequests();
      _gettingNetworkBalances = false;
      throw Exception(
          'Failed to contact server for fetching current balances.');
    }
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    late var balances = <CurrentBalanceDto>[];

    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception(
          'Failed to fetch current balances. Could not parse response');
    }
    try {
      balances = parsedJson
          .map((e) => CurrentBalanceDto.fromJson(e))
          .toList()
          .cast<CurrentBalanceDto>();
    } catch (e) {
      throw Exception(
          'Failed to fetch current balances. Server response is missing required info');
    }
    return balances;
  }

  // Gets the balances (and transactions) of a list of public IDs
  Future<List<BalanceDto>> getCurrentBalances(List<String> publicIds) async {
    _assertAuthorized();
    appStore.incrementPendingRequests();
    _gettingCurrentBalances = true;
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({
        'Authorization': 'bearer ${_authenticationToken!}',
        'Content-Type': 'application/json'
      });
      response = await http.post(
          Uri.https(Config.walletDomain, Config.URL_Balance),
          body: json.encode(publicIds),
          headers: headers);

      appStore.decreasePendingRequests();
      _gettingCurrentBalances = false;
    } catch (e) {
      appStore.decreasePendingRequests();
      _gettingCurrentBalances = false;
      throw Exception('Failed to contact server for fetching balances.');
    }
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    late var balances = <BalanceDto>[];

    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch balances. Could not parse response');
    }
    try {
      balances = parsedJson
          .map((e) => BalanceDto.fromJson(e))
          .toList()
          .cast<BalanceDto>();
    } catch (e) {
      throw Exception(
          'Failed to fetch balances. Server response is missing required info');
    }
    return balances;
  }

  /// Gets current tick form the Qubic network
  Future<List<ExplorerQueryDto>> getExplorerQuery(String query) async {
    _assertAuthorized();
    explorerStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({'Authorization': 'bearer ${_authenticationToken!}'});
      response = await http.get(
          Uri.https(Config.walletDomain, Config.URL_ExplorerQuery,
              {'searchTerm': query}),
          headers: headers);
      explorerStore.decreasePendingRequests();
    } catch (e) {
      explorerStore.decreasePendingRequests();
      throw Exception('Failed to contact server for explorer query.');
    }
    _assert200Response(response.statusCode);
    late dynamic parsedJson;
    late List<ExplorerQueryDto> resultDto = [];
    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception(
          'Failed to fetch explorer query. Could not parse response');
    }
    try {
      resultDto = parsedJson
          .map((e) => ExplorerQueryDto.fromJson(e))
          .toList()
          .cast<ExplorerQueryDto>();
    } catch (e) {
      throw Exception(
          'Failed to fetch explorer query. Server response is missing required info');
    }

    return resultDto;
  }

  Future<ExplorerTickInfoDto> getExplorerTickInfo(int tick) async {
    _assertAuthorized();
    explorerStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({'Authorization': 'bearer ${_authenticationToken!}'});
      response = await http.get(
          Uri.https(Config.walletDomain, Config.URL_ExplorerTickInfo,
              {'tick': tick.toString()}),
          headers: headers);
      explorerStore.decreasePendingRequests();
    } catch (e) {
      explorerStore.decreasePendingRequests();
      throw Exception('Failed to contact server for explorer tick info.');
    }
    if (response.statusCode == 500) {
      throw Exception('Tick info not available yet.');
    }
    _assert200Response(response.statusCode);
    late dynamic parsedJson;
    late ExplorerTickInfoDto resultDto;
    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception(
          'Failed to fetch explorer tick info. Could not parse response');
    }
    try {
      resultDto = ExplorerTickInfoDto.fromJson(parsedJson);
    } catch (e) {
      throw Exception(
          'Failed to fetch explorer tick info. Server response is missing required info');
    }

    return resultDto;
  }

  Future<ExplorerIdInfoDto> getExplorerIdInfo(String publicId) async {
    _assertAuthorized();
    explorerStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({'Authorization': 'bearer ${_authenticationToken!}'});
      response = await http.get(
          Uri.https(
              Config.walletDomain, "${Config.URL_ExplorerIdInfo}/$publicId"),
          headers: headers);
      explorerStore.decreasePendingRequests();
    } catch (e) {
      explorerStore.decreasePendingRequests();
      throw Exception('Failed to contact server for explorer id info.');
    }
    _assert200Response(response.statusCode);
    late dynamic parsedJson;
    late ExplorerIdInfoDto resultDto;
    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception(
          'Failed to fetch explorer id info. Could not parse response');
    }
    try {
      resultDto = ExplorerIdInfoDto.fromJson(parsedJson);
    } catch (e) {
      throw Exception(
          'Failed to fetch explorer id info. Server response is missing required info');
    }

    return resultDto;
  }

  /// Gets the assets from the network
  /// @param publicIds - List of public IDs to get assets for
  /// @return List of assets
  Future<List<QubicAssetDto>> getCurrentAssets(List<String> publicIds) async {
    _assertAuthorized();
    _gettingNetworkAssets = true;
    appStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({
        'Authorization': 'bearer ${_authenticationToken!}',
        'Content-Type': 'application/json'
      });
      response = await http.post(
          Uri.https(Config.walletDomain, Config.URL_Assets),
          body: json.encode(publicIds),
          headers: headers);

      appStore.decreasePendingRequests();
      _gettingNetworkAssets = false;
    } catch (e) {
      appStore.decreasePendingRequests();
      _gettingNetworkAssets = false;
      throw Exception('Failed to contact server for fetching current assets.');
    }
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    late List<QubicAssetDto> assets = <QubicAssetDto>[];

    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception(
          'Failed to fetch current assets. Could not parse response');
    }
    try {
      assets = parsedJson
          .map((e) => QubicAssetDto.fromJson(e))
          .toList()
          .cast<QubicAssetDto>();
    } catch (e) {
      throw Exception(
          'Failed to fetch current assets. Server response is missing required info');
    }
    return assets;
  }

  /// Gets the market info from the network
  Future<MarketInfoDto> getMarketInfo() async {
    appStore.incrementPendingRequests();
    late http.Response response;
    try {
      var headers = QubicLi.getHeaders();
      headers.addAll({'Content-Type': 'application/json'});
      response = await http.get(
          Uri.https(Config.walletDomain, Config.URL_MarketInfo),
          headers: headers);
      appStore.decreasePendingRequests();
    } catch (e) {
      appStore.decreasePendingRequests();
      throw Exception('Failed to contact server for fetching market info.');
    }
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    late MarketInfoDto marketInfo;

    try {
      parsedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch market info. Could not parse response');
    }
    try {
      marketInfo = MarketInfoDto.fromJson(parsedJson);
    } catch (e) {
      rethrow;
      throw Exception(
          'Failed to fetch market info. Server response is missing required info');
    }
    return marketInfo;
  }
}
