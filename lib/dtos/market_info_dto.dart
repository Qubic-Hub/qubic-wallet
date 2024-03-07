import 'package:decimal/decimal.dart';

class MarketInfoDto {
  late int supply;
  late String price;
  late int capitalization;
  late String currency;

  MarketInfoDto({
    required this.supply,
    required this.price,
    required this.capitalization,
    required this.currency,
  });

  Decimal get priceAsDecimal => Decimal.parse(price);
  double get priceAsDouble => double.parse(price);

  factory MarketInfoDto.fromJson(Map<String, dynamic> json) {
    return MarketInfoDto(
      supply: json['supply'],
      price: "${json['price']}",
      capitalization: json['capitalization'],
      currency: json['currency'],
    );
  }

  MarketInfoDto clone() {
    return MarketInfoDto(
        supply: supply,
        price: price,
        capitalization: capitalization,
        currency: currency);
  }
}
