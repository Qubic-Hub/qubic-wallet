class QubicHelperConfigEntry {
  String filename;
  String downloadPath;
  String checksum;

  QubicHelperConfigEntry(
      {required this.filename,
      required this.downloadPath,
      required this.checksum});
}

class QubicHelperConfig {
  QubicHelperConfigEntry win64;
  QubicHelperConfigEntry linux64;
  QubicHelperConfigEntry macOs64;

  QubicHelperConfig(
      {required this.win64, required this.linux64, required this.macOs64});
}
