import 'package:qubic_wallet/models/version_number.dart';

class VersionInfoDto {
  //Minimum version required to run the app
  final String minVer;
  //Maximum version available
  final String maxVer;

  final String? notice;

  VersionNumber get minimumVersionNumber => VersionNumber.fromString(minVer);
  VersionNumber get maximumVersionNumber => VersionNumber.fromString(minVer);

  VersionInfoDto({required this.minVer, required this.maxVer, this.notice});

  factory VersionInfoDto.fromJson(Map<String, dynamic> json) {
    return VersionInfoDto(
      minVer: json['minVer'],
      maxVer: json['maxVer'],
      notice: json.containsKey('notice') ? json['notice'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['minVer'] = minVer;
    data['maxVer'] = maxVer;
    if (notice != null) {
      data['noticeText'] = notice;
    }
    return data;
  }
}
