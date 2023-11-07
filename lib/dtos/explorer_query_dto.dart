enum ExplorerResult {
  publicId,
  transaction,
  tick;

  factory ExplorerResult.fromInt(int num) {
    if (num == 0) {
      return ExplorerResult.publicId;
    }
    if (num == 1) {
      return ExplorerResult.transaction;
    }
    if (num == 2) {
      return ExplorerResult.tick;
    }
    throw Exception("Invalid ExplorerResult");
  }
  int get toInt {
    return index;
  }
}

class ExplorerQueryDto {
  ExplorerResult type;
  String id;
  String? description;
  int tick;

  ExplorerQueryDto(this.type, this.id, this.description, this.tick);

  factory ExplorerQueryDto.fromJson(Map<String, dynamic> data) {
    return ExplorerQueryDto(
        ExplorerResult.fromInt(data['type'] as int),
        data['id'],
        data.containsKey('description') ? data['description'] : null,
        data['tick']);
  }
}
