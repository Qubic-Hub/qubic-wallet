class CurrentTickDto {
  int tick;

  CurrentTickDto(this.tick);

  factory CurrentTickDto.fromJson(Map<String, dynamic> data) {
    if (data
        case {
          'tick': int currentTick,
          //'tickDate': String tickDate,
        }) {
      return CurrentTickDto(currentTick);
    } else {
      throw FormatException('Invalid Tick JSON: $data');
    }
  }
}
