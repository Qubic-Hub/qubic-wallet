// Holds transaction information for an explorer query
import 'package:qubic_wallet/models/transaction_vm.dart';

class ExplorerTransactionInfoDto {
  String id;
  bool executed;
  int tick;
  bool includedByTickLeader;
  String sourceId;
  String destId;
  int amount;
  int type;
  String digest;
  bool moneyFlew;

  ComputedTransactionStatus getStatus() {
    if (!executed) {
      return ComputedTransactionStatus.failure;
    }
    if (executed && moneyFlew) {
      return ComputedTransactionStatus.success;
    }
    if (executed && !moneyFlew) {
      return ComputedTransactionStatus.invalid;
    }
    return ComputedTransactionStatus.failure;
  }

  ExplorerTransactionInfoDto(
      this.id,
      this.executed,
      this.tick,
      this.includedByTickLeader,
      this.sourceId,
      this.destId,
      this.amount,
      this.type,
      this.digest,
      this.moneyFlew);

  factory ExplorerTransactionInfoDto.fromJson(Map<String, dynamic> data) {
    return ExplorerTransactionInfoDto(
        data['id'],
        data['executed'],
        data['tick'],
        data['includedByTickLeader'],
        data['sourceId'],
        data['destId'],
        data['amount'],
        data['type'],
        data['digest'],
        data['moneyFlew']);
  }

  factory ExplorerTransactionInfoDto.clone(ExplorerTransactionInfoDto source) {
    return ExplorerTransactionInfoDto(
        source.id,
        source.executed,
        source.tick,
        source.includedByTickLeader,
        source.sourceId,
        source.destId,
        source.amount,
        source.type,
        source.digest,
        source.moneyFlew);
  }
}
