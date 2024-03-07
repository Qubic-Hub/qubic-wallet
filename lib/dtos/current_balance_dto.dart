/// A data transfer object representing the current balance of a wallet.
/// Holds results from Qubic GetNetworkBalances
class CurrentBalanceDto {
  /// The public ID of the wallet.
  final String publicId;

  /// The current balance amount in the wallet.
  final int amount;

  /// The tick of the wallet.
  final int tick;

  /// Creates a new instance of [CurrentBalanceDto].
  /// [publicId] is the public ID of the wallet.
  /// [amount] is the current balance amount in the wallet.
  /// [tick] is the tick of the wallet.
  CurrentBalanceDto({
    required this.publicId,
    required this.amount,
    required this.tick,
  });

  /// Creates a new instance of [CurrentBalanceDto] from a JSON map.
  factory CurrentBalanceDto.fromJson(Map<String, dynamic> json) {
    return CurrentBalanceDto(
      publicId: json['publicId'],
      amount: json['amount'],
      tick: json['tick'],
    );
  }

  /// Converts this instance of [CurrentBalanceDto] to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['publicId'] = publicId;
    data['amount'] = amount;
    data['tick'] = tick;
    return data;
  }
}
