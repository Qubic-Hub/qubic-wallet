import 'package:mobx/mobx.dart';
import 'package:qubic_wallet/models/transaction_vm.dart';

enum TransactionDirection { incoming, outgoing }

@observable
class TransactionFilter {
  @observable
  String? qubicId;

  @observable
  TransactionDirection? direction;

  @observable
  ComputedTransactionStatus? status;

  @observable
  int? amountFrom;

  @observable
  int? amountTo;

  @observable
  int get totalActiveFilters {
    int nu = 0;
    if (qubicId != null) {
      nu++;
      if (direction != null) {
        nu++;
      }
    }
    if (status != null) {
      nu++;
    }
    return nu;
  }

  @observable
  DateTime? broadcastedFrom;
  @observable
  DateTime? broadcastedTo;
  @observable
  DateTime? confirmedFrom;
  @observable
  DateTime? confirmedTo;

  TransactionFilter({
    this.qubicId,
    this.direction,
    this.status,
    this.amountFrom,
    this.amountTo,
    this.broadcastedFrom,
    this.broadcastedTo,
    this.confirmedFrom,
    this.confirmedTo,
  });

  bool matchesVM(TransactionVm filtered) {
    if (amountFrom != null) {
      if (filtered.amount < amountFrom!) {
        return false;
      }
    }
    if (amountTo != null) {
      if (filtered.amount < amountTo!) {
        return false;
      }
    }
    if ((broadcastedFrom != null) && (filtered.broadcasted != null)) {
      if (filtered.broadcasted!.isBefore(broadcastedFrom!)) {
        return false;
      }
    }
    if ((broadcastedTo != null) && (filtered.broadcasted != null)) {
      if (filtered.broadcasted!.isAfter(broadcastedFrom!)) {
        return false;
      }
    }
    if ((broadcastedFrom != null) && (filtered.broadcasted != null)) {
      if (filtered.broadcasted!.isBefore(broadcastedFrom!)) {
        return false;
      }
    }
    if ((confirmedFrom != null) && (filtered.confirmed != null)) {
      if (filtered.broadcasted!.isAfter(confirmedFrom!)) {
        return false;
      }
    }
    if ((confirmedTo != null) && (filtered.confirmed != null)) {
      if (filtered.broadcasted!.isAfter(confirmedTo!)) {
        return false;
      }
    }
    if (qubicId != null) {
      if (direction == TransactionDirection.incoming) {
        if (filtered.destId != qubicId) {
          return false;
        }
      }
      if (direction == TransactionDirection.outgoing) {
        if (filtered.sourceId != qubicId) {
          return false;
        }
      }
      if ((filtered.destId != qubicId) && (filtered.sourceId != qubicId)) {
        return false;
      }
    }
    if (status != null) {
      if (status != filtered.getStatus()) {
        return false;
      }
    }
    return true;
  }
}
