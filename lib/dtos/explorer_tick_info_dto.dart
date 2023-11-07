import 'package:qubic_wallet/dtos/explorer_transaction_info_dto.dart';

class ExplorerTickInfoDto {
  bool isNonEmpty;
  String tickLeaderId;
  int tickLeaderIndex;
  String? tickLeaderShortCode;
  String? signature;
  bool signatureVerified;
  bool completed;
  int tick;
  DateTime? timestamp;
  List<ExplorerTransactionInfoDto>? transactions;

  ExplorerTickInfoDto(
      this.isNonEmpty,
      this.tickLeaderId,
      this.tickLeaderIndex,
      this.tickLeaderShortCode,
      this.signature,
      this.signatureVerified,
      this.completed,
      this.tick,
      this.timestamp,
      this.transactions);

  factory ExplorerTickInfoDto.fromJson(Map<String, dynamic> data) {
    List<ExplorerTransactionInfoDto>? transactions;
    if (data['transactions'] != null) {
      transactions = data['transactions']
          ?.map<ExplorerTransactionInfoDto>(
              (e) => ExplorerTransactionInfoDto.fromJson(e))
          .toList();
    }

    return ExplorerTickInfoDto(
      data['isNonEmpty'],
      data['tickLeaderId'],
      data['tickLeaderIndex'],
      data['tickLeaderShortCode'],
      // ignore: prefer_if_null_operators
      data['signature'] == null
          ? null
          : data['signature'], //Somehow needs this syntax to work, ?? doesnt!?!
      data['signatureVerified'],
      data['completed'],
      data['tick'],
      data['timestamp'] == null
          ? null
          : DateTime.parse(data[
              'timestamp']), //Somehow needs this syntax to work, ?? doesnt!?!
      transactions,
    );
  }

  factory ExplorerTickInfoDto.clone(ExplorerTickInfoDto source) {
    List<ExplorerTransactionInfoDto>? transactions = source.transactions
        ?.map<ExplorerTransactionInfoDto>(
            (e) => ExplorerTransactionInfoDto.clone(e))
        .toList();

    return ExplorerTickInfoDto(
        source.isNonEmpty,
        source.tickLeaderId,
        source.tickLeaderIndex,
        source.tickLeaderShortCode,
        source.signature,
        source.signatureVerified,
        source.completed,
        source.tick,
        source.timestamp,
        transactions);
  }
}
