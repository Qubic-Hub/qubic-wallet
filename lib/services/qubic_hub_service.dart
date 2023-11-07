import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/models/version_number.dart';
import 'package:qubic_wallet/resources/qubic_hub.dart';

import '../stores/qubic_hub_store.dart';

class QubicHubService {
  final QubicHubStore qubicHubStore = getIt<QubicHubStore>();
  final QubicHub qubicHub = getIt<QubicHub>();

  Future<void> loadVersionInfo() async {
    final versionInfo = await qubicHub.getVersionInfo();
    qubicHubStore.setMinMaxVersions(versionInfo.minVer, versionInfo.maxVer);
    qubicHubStore.setNotice(versionInfo.notice);
  }

  Future<void> loadUpdateInfo() async {
    if ((qubicHubStore.maxVersion == null) ||
        (qubicHubStore.versionInfo == null)) {
      return;
    }
    if (VersionNumber.fromString(qubicHubStore.maxVersion!) ==
        VersionNumber.fromString(qubicHubStore.versionInfo!)) {
      return;
    }
    final updateInfo = await qubicHub.getUpdateInfo(qubicHubStore.maxVersion!);
    qubicHubStore.setUpdateDetails(updateInfo);
  }
}
