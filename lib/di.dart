import 'package:get_it/get_it.dart';
import 'package:qubic_wallet/helpers/global_snack_bar.dart';
import 'package:qubic_wallet/resources/qubic_cmd.dart';
import 'package:qubic_wallet/resources/qubic_hub.dart';
import 'package:qubic_wallet/resources/qubic_js.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/resources/secure_storage.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/explorer_store.dart';
import 'package:qubic_wallet/stores/qubic_hub_store.dart';
import 'package:qubic_wallet/stores/settings_store.dart';

import 'package:qubic_wallet/timed_controller.dart';
import 'package:universal_platform/universal_platform.dart';

import 'services/qubic_hub_service.dart';

final GetIt getIt = GetIt.instance;

/// Setups Dependency injection
void setupDI() {
  //Providers
  getIt.registerSingleton<GlobalSnackBar>(GlobalSnackBar());

  //Stores
  getIt.registerSingleton<ApplicationStore>(ApplicationStore());
  getIt.registerSingleton<SettingsStore>(SettingsStore());
  getIt.registerSingleton<ExplorerStore>(ExplorerStore());
  getIt.registerSingleton<QubicHubStore>(QubicHubStore());
  getIt.registerSingleton<SecureStorage>(SecureStorage());

  getIt.registerSingleton<QubicLi>(QubicLi());
  getIt.registerSingleton<QubicHub>(QubicHub());

  //Services
  getIt.registerSingleton<QubicHubService>(QubicHubService());
  getIt.registerSingleton<TimedController>(TimedController());

  getIt.registerSingleton<QubicCmd>(QubicCmd());
}
