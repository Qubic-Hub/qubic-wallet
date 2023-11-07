// ignore_for_file: camel_case_extensions

extension thousands on int {
  String asThousands({
    final String separator = ",",
    final int digits = 3,
  }) {
    assert(digits >= 1, 'digits must be greater than or equal to 1');
    final chars = abs().truncate().toString().split("").reversed;
    var n = 0;
    var result = "";
    for (final ch in chars) {
      if (n == digits) {
        result = '$ch$separator$result';
        n = 1;
      } else {
        result = '$ch$result';
        n++;
      }
    }
    result = this < 0 ? '-$result' : result;
    result = (this is double)
        ? '$result${toString().substring(toString().lastIndexOf('.'))}'
        : result;
    return result;
  }
}
