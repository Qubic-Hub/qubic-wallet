import 'dart:core';

import 'package:mobx/mobx.dart';
import 'package:qubic_wallet/dtos/transaction_dto.dart';

enum ComputedTransactionStatus {
  //** Transfer is broadcasted but pending */
  pending,
  //** Transfer is confirmed */
  confirmed,
  //** Transfer is successful (processed by computors) */
  success,
  //** Transfer has failed */
  failure,
  //** Transfer is invalid (may be successful but invalidated) */
  invalid,
}

@observable
class TransactionVm {
  @observable
  late String id; //The transaction Id

  @observable
  String sourceId;

  @observable
  String destId;

  @observable
  int amount;

  @observable
  String status;

  @observable
  DateTime? created;

  @observable
  DateTime? stored;

  @observable
  DateTime? staged;

  @observable
  DateTime? broadcasted;

  @observable
  DateTime? confirmed;

  @observable
  DateTime? statusUpdate;

  @observable
  int targetTick;

  @observable
  bool isPending;

  @observable
  int? price; //IPO Bids

  @observable
  int? quantity; //IPO Bids

  @observable
  bool moneyFlow;

  TransactionVm(
      this.id,
      this.sourceId,
      this.destId,
      this.amount,
      this.status,
      this.created,
      this.stored,
      this.staged,
      this.broadcasted,
      this.confirmed,
      this.statusUpdate,
      this.targetTick,
      this.isPending,
      this.price,
      this.quantity,
      this.moneyFlow);

  ComputedTransactionStatus getStatus() {
    if (isPending) {
      return ComputedTransactionStatus.pending;
    }
    if ((status == 'Confirmed') || (status == 'Staged')) {
      return ComputedTransactionStatus.confirmed;
    }
    if ((status == 'Success')) {
      if (moneyFlow == true) {
        return ComputedTransactionStatus.success;
      } else {
        return ComputedTransactionStatus.invalid;
      }
    }
    if ((status == 'Failed')) {
      return ComputedTransactionStatus.failure;
    }
    return ComputedTransactionStatus.pending;
  }

  String toReadableString() {
    return "ID: $id \nSource: $sourceId \nDestination: $destId \nAmount: $amount \nStatus: $status \nCreated: $created \nStored: $stored \nStaged: $staged \nBroadcasted: $broadcasted \nConfirmed: $confirmed \nStatusUpdate: $statusUpdate \nTarget Tick: $targetTick \nIs Pending: $isPending \nPrice: $price \nQuantity: $quantity \nMoney Flow: $moneyFlow \n";
  }

  updateContentsFromTransactionDto(TransactionDto update) {
    //Will copy all values from a transaction DTO (does not update id)
    if (update.id != id) {
      throw Exception("Cannot update a transaction with a different ID");
    }
    sourceId = update.sourceId;
    destId = update.destId;
    amount = update.amount;
    status = update.status;
    created = update.created;
    stored = update.stored;
    staged = update.staged;
    broadcasted = update.broadcasted;
    confirmed = update.confirmed;
    statusUpdate = update.statusUpdate;
    targetTick = update.targetTick;
    isPending = update.isPending;
    price = update.price;
    quantity = update.quantity;
    moneyFlow = update.moneyFlow;
  }

  @override
  String toString() {
    return "TransactionVm: $id, Source: $sourceId, Dest: $destId, Amount: $amount, Status: $status,Created: $created,Stored: $stored,Staged: $staged,Broadcasted: $broadcasted,Confirmed: $confirmed,StatusUpdate: $statusUpdate,TargetTick: $targetTick,isPending: $isPending,Price: $price, Quantity: $quantity, Moneyflow: $moneyFlow";
  }

  factory TransactionVm.fromTransactionDto(TransactionDto original) {
    return TransactionVm(
        original.id,
        original.sourceId,
        original.destId,
        original.amount,
        original.status,
        original.created,
        original.stored,
        original.staged,
        original.broadcasted,
        original.confirmed,
        original.statusUpdate,
        original.targetTick,
        original.isPending,
        original.price,
        original.quantity,
        original.moneyFlow);
  }
}
