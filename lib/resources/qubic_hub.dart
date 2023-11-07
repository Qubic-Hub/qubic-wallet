// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qubic_wallet/config.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/update_details_dto.dart';
import 'package:qubic_wallet/dtos/version_info_dto.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:universal_platform/universal_platform.dart';

import 'package:qubic_wallet/stores/qubic_hub_store.dart';

class QubicHub {
  ApplicationStore appStore = getIt<ApplicationStore>();
  QubicHubStore qHubStore = getIt<QubicHubStore>();
  String? _authenticationToken;
  // ignore: unused_field
  String? _refreshToken;
  String? get authenticationToken => _authenticationToken;

  String getUserAgentHeader() {
    String OS = UniversalPlatform.isAndroid
        ? 'Android'
        : UniversalPlatform.isIOS
            ? 'iOS'
            : UniversalPlatform.isLinux
                ? 'Linux'
                : UniversalPlatform.isMacOS
                    ? 'MacOS'
                    : UniversalPlatform.isWindows
                        ? 'Windows'
                        : UniversalPlatform.isFuchsia
                            ? 'Fuchsia'
                            : UniversalPlatform.isWeb
                                ? 'Web'
                                : UniversalPlatform.isDesktop
                                    ? 'Desktop'
                                    : UniversalPlatform.isDesktopOrWeb
                                        ? 'DesktopOrWeb'
                                        : 'unknown';
    return 'QubicWallet/${qHubStore.versionInfo ?? "0.0.0"} ($OS)';
  }

  /// Returns the headers required for qubic-hub requests
  static Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept-Language': 'en-US,en;q=0.9',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
      'Host': 'wallet.qubic-hub.com',
      'Pragma': 'no-cache',
      'Referer': 'https://ref.qubic-hub.com',
    };
  }

  void _assert200Response(int statusCode) {
    if (statusCode != 200) {
      throw Exception(
          'Failed to perform qubic-hub action. Server returned status $statusCode');
    }
  }

  /// Submits a transcation (with amount transfer) to the Qubic network
  Future<VersionInfoDto> getVersionInfo() async {
    appStore.incrementPendingRequests();
    late http.Response response;

    try {
      var headers = QubicHub.getHeaders();
      headers.addEntries([
        MapEntry('User-Agent', getUserAgentHeader()),
      ]);
      response = await http.get(
          Uri.https(Config.servicesDomain, Config.URL_VersionInfo),
          headers: headers);
      appStore.decreasePendingRequests();
    } catch (e) {
      appStore.decreasePendingRequests();
      throw Exception('Failed to contact server for fetching version info.');
    }
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    late VersionInfoDto versionInfoDto;
    try {
      //Awful hack because of server side adding UTF-8 BOM .
      //TODO: Fix this on the server side
      var fI = response.body.indexOf("{");
      var lI = response.body.lastIndexOf("}") + 1;
      parsedJson = jsonDecode(response.body.substring(fI, lI));
    } catch (e) {
      throw Exception('Failed to get version info. Could not parse response.');
    }

    try {
      versionInfoDto = VersionInfoDto.fromJson(parsedJson);
    } catch (e) {
      throw Exception('Failed to get version info. Invalid response.');
    }
    return versionInfoDto;
  }

  /// Gets the update details for a version
  Future<UpdateDetailsDto> getUpdateInfo(String updateVersion) async {
    appStore.incrementPendingRequests();
    late http.Response response;

    try {
      var headers = QubicHub.getHeaders();
      headers.addEntries([
        MapEntry('User-Agent', getUserAgentHeader()),
      ]);
      response = await http.get(
          Uri.https(Config.servicesDomain, Config.URL_VersionInfo, {
            'ver': updateVersion,
          }),
          headers: headers);
      appStore.decreasePendingRequests();
    } catch (e) {
      appStore.decreasePendingRequests();
      throw Exception('Failed to contact server for fetching update info.');
    }
    _assert200Response(response.statusCode);

    late dynamic parsedJson;
    late UpdateDetailsDto updateDetails;
    try {
      //Awful hack because of server side adding UTF-8 BOM .
      //TODO: Fix this on the server side
      var fI = response.body.indexOf("{");
      var lI = response.body.lastIndexOf("}") + 1;
      parsedJson = jsonDecode(response.body.substring(fI, lI));
    } catch (e) {
      throw Exception('Failed to get update info. Could not parse response.');
    }

    try {
      updateDetails = UpdateDetailsDto.fromJson(parsedJson);
    } catch (e) {
      throw Exception('Failed to get update info. Invalid response.');
    }
    return updateDetails;
  }
}
