import 'package:qubic_wallet/dtos/transaction_dto.dart';

/// Holds the results from Qubic.li / GetCurrentBalances
class BalanceDto {
  String? computorIndex;
  bool isComputor;
  String publicId;
  int epochBaseAmount;
  int epochChanges;
  int currentEstimatedAmount;
  DateTime baseDate;
  List<TransactionDto> transactions;

  BalanceDto(
      this.computorIndex,
      this.isComputor,
      this.publicId,
      this.epochBaseAmount,
      this.epochChanges,
      this.currentEstimatedAmount,
      this.baseDate,
      this.transactions);

  factory BalanceDto.fromJson(Map<String, dynamic> data) {
    List<TransactionDto> a = data['transactions']
        .map<TransactionDto>((e) => TransactionDto.fromJson(e))
        .toList();

    return BalanceDto(
        data['computorIndex'],
        data['isComputor'],
        data['publicId'],
        data['epochBaseAmount'],
        data['epochChanges'],
        data['currentEstimatedAmount'],
        DateTime.parse(data['baseDate']),
        a);
  }
}
