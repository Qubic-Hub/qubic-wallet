class TransactionDto {
  String id;
  String sourceId;
  String destId;
  int amount;
  String status;
  DateTime? created;
  DateTime? stored;
  DateTime? staged;
  DateTime? broadcasted;
  DateTime? confirmed;
  DateTime? statusUpdate;
  int targetTick;
  bool isPending;
  int? price; //IPO Bids
  int? quantity; //IPO Bids
  bool moneyFlow;

  TransactionDto(
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

  factory TransactionDto.fromJson(Map<String, dynamic> data) {
    return TransactionDto(
      data['id'],
      data['sourceId'],
      data['destId'],
      data['amount'],
      data['status'],
      data['created'] != null ? DateTime.parse(data['created'] + "Z") : null,
      data['stored'] != null ? DateTime.parse(data['stored'] + "Z") : null,
      data['staged'] != null ? DateTime.parse(data['staged'] + "Z") : null,
      data['broadcasted'] != null
          ? DateTime.parse(data['broadcasted'] + "Z")
          : null,
      data['confirmed'] != null
          ? DateTime.parse(data['confirmed'] + "Z")
          : null,
      data['statusUpdate'] != null
          ? DateTime.parse(data['statusUpdate'] + "Z")
          : null,
      data['targetTick'],
      data['isPending'],
      data['price'],
      data['quantity'],
      data['moneyFlow'],
    );
  }
}
