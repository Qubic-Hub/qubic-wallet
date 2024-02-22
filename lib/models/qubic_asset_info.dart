class QubicAssetInfo {
  final String name; //The asset name
  int amount; //The amount of the asset
  final bool isToken; //True if this is a QX issued token

  QubicAssetInfo(this.name, this.amount, this.isToken);
}
