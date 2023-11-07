import 'package:get_it/get_it.dart';
import 'package:qubic_wallet/resources/qubic_hub.dart';
import 'package:qubic_wallet/resources/qubic_js.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/resources/secure_storage.dart';
import 'package:qubic_wallet/stores/application_store.dart';
import 'package:qubic_wallet/stores/explorer_store.dart';
import 'package:qubic_wallet/stores/qubic_hub_store.dart';
import 'package:qubic_wallet/stores/settings_store.dart';
import 'package:qubic_wallet/timed_controller.dart';

import 'services/qubic_hub_service.dart';

final GetIt getIt = GetIt.instance;

/// Setups Dependency injection
void setupDI() {
  //Stores
  getIt.registerSingleton<ApplicationStore>(ApplicationStore());
  getIt.registerSingleton<SettingsStore>(SettingsStore());
  getIt.registerSingleton<ExplorerStore>(ExplorerStore());
  getIt.registerSingleton<QubicHubStore>(QubicHubStore());
  getIt.registerSingleton<SecureStorage>(SecureStorage());

  //Resources
  getIt.registerSingleton<QubicJs>(QubicJs());
  getIt.registerSingleton<QubicLi>(QubicLi());
  getIt.registerSingleton<QubicHub>(QubicHub());

  //Services
  getIt.registerSingleton<QubicHubService>(QubicHubService());
  getIt.registerSingleton<TimedController>(TimedController());
}
