// ignore_for_file: constant_identifier_names

import 'package:qubic_wallet/models/qubic_helper_config.dart';

abstract class Config {
  /// General backend via qubic.li
  static const walletDomain = "api.qubic.li";

  static const URL_Login = "Auth/Login";
  static const URL_Tick = "Public/CurrentTick";
  static const URL_Balance = "Wallet/CurrentBalance";
  static const URL_NetworkBalances = "Wallet/NetworkBalances";
  static const URL_NetworkTransactions = "Wallet/Transactions";
  static const URL_Assets = "Wallet/Assets";
  static const URL_Transaction = "Public/SubmitTransaction";
  static const URL_TickOverview = "Network/TickOverview";
  static const URL_ExplorerQuery = "Search/Query";
  static const URL_ExplorerTickInfo = "Network/Block";
  static const URL_ExplorerIdInfo = "Network/Id";

  static const URL_MarketInfo = "Public/MarketInformation";

  static const authUser = "guest@qubic.li";
  static const authPass = "guest13@Qubic.li";

  static const fetchEverySeconds = 60;
  static const fetchEverySecondsSlow = 60 * 5;

  static const checkForTamperedUtils = true;

  // The qubic-hub.com backend
  static const servicesDomain = "wallet.qubic-hub.com";
  static const URL_VersionInfo = "/versionInfo.php";

  //Qubic Helper Utilities
  static final qubicHelper = QubicHelperConfig(
      win64: QubicHelperConfigEntry(
          filename: "qubic-helper-win-x64-2_0_0.exe",
          downloadPath:
              "https://github.com/Qubic-Hub/qubic-helper-utils/releases/download/2.0.0/qubic-helper-win-x64-2_0_0.exe",
          checksum: "bd86d41c87f22a4bab0c768800bbfe45"),
      linux64: QubicHelperConfigEntry(
          filename: "qubic-helper-linux-x64-2_0_0",
          downloadPath:
              "https://github.com/Qubic-Hub/qubic-helper-utils/releases/download/2.0.0/qubic-helper-linux-x64-2_0_0",
          checksum: "23ce9be3f56897013bec4d3c520c3a95"),
      macOs64: QubicHelperConfigEntry(
          filename: "qubic-helper-mac-x64-2_0_0",
          downloadPath:
              "https://github.com/Qubic-Hub/qubic-helper-utils/releases/download/2.0.0/qubic-helper-mac-x64-2_0_0",
          checksum: "6f10fee6f783b866622213ce169c4876"));
}
