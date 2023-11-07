// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
// ignore: unused_import
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/dtos/update_details_dto.dart';
import 'package:qubic_wallet/models/settings.dart';
import 'package:qubic_wallet/models/version_number.dart';
part 'qubic_hub_store.g.dart';

// flutter pub run build_runner watch --delete-conflicting-outputs

class QubicHubStore = _QubicHubStore with _$QubicHubStore;

abstract class _QubicHubStore with Store {
  @observable
  //The current version of the app
  String? versionInfo;

  @observable
  // The minimum version required to run the app via the backend
  String? minVersion;

  @observable
  String? buildNumber;

  @observable
  // The maximum available version of the app
  String? maxVersion;

  @observable
  //A global notification
  String? notice;

  @observable
  Settings settings = Settings();

  @observable
  UpdateDetailsDto? updateDetails;

  @action
  void setUpdateDetails(UpdateDetailsDto? value) {
    if (value == null) {
      updateDetails = null;
    }
    updateDetails = value!.clone();
  }

  @action
  void setNotice(String? notice) {
    this.notice = notice;
  }

  @computed
  // Whether the app needs to be updated to the minimum version
  bool get updateNeeded {
    if (versionInfo == null || minVersion == null) {
      return false;
    }
    return VersionNumber.fromString(versionInfo!) <
        VersionNumber.fromString(minVersion!);
  }

  @computed
  // Whether the app can be updated to a new version
  bool get updateAvailable {
    if (versionInfo == null || maxVersion == null) {
      return false;
    }
    return VersionNumber.fromString(versionInfo!) <
        VersionNumber.fromString(maxVersion!);
  }

  @action
  void setVersion(String versionInfo) {
    this.versionInfo = versionInfo;
  }

  @action
  void setBuildNumer(String buildNumber) {
    this.buildNumber = buildNumber;
  }

  @action
  void setMinMaxVersions(String minVersion, String maxVersion) {
    this.minVersion = minVersion;
    this.maxVersion = maxVersion;
  }
}
