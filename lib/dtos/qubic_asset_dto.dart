/// A Qubic asset.
class QubicAssetDto {
  /// The public ID of where the asset belongs
  final String publicId;

  /// The index of the contract.
  final int contractIndex;

  /// The name of the contract.
  final String contractName;

  /// The amount of shares owned by the asset.
  final int ownedAmount;

  /// The reported tick for the asset
  final int tick;

  /// Creates a new instance of the [QubicAsset] class.
  QubicAssetDto({
    required this.publicId,
    required this.contractIndex,
    required this.contractName,
    required this.ownedAmount,
    required this.tick,
  });

  /// Creates a new instance of the [QubicAsset] class from a JSON map.
  factory QubicAssetDto.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('publicId') ||
        json['publicId'] == null ||
        !json.containsKey('contractIndex') ||
        json['contractIndex'] == null ||
        !json.containsKey('contractName') ||
        json['contractName'] == null ||
        !json.containsKey('ownedAmount') ||
        json['ownedAmount'] == null ||
        !json.containsKey('tick') ||
        json['tick'] == null) {
      throw FormatException('Missing required field in JSON: $json');
    }

    return QubicAssetDto(
      publicId: json['publicId'],
      contractIndex: json['contractIndex'],
      contractName: json['contractName'],
      ownedAmount: json['ownedAmount'],
      tick: json['tick'],
    );
  }

  /// Converts this [QubicAsset] instance to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['publicId'] = publicId;
    data['contractIndex'] = contractIndex;
    data['contractName'] = contractName;
    data['ownedAmount'] = ownedAmount;
    data['tick'] = tick;
    return data;
  }
}
