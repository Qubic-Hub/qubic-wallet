class AuthLoginDto {
  late final bool success;
  late final String token;
  late final String refreshToken;

  AuthLoginDto(this.success, this.token, this.refreshToken);
  factory AuthLoginDto.fromJson(Map<String, dynamic> data) {
    if (data
        case {
          'success': bool success,
          'token': String token,
          'refreshToken': String refreshToken, // ⚠️ warning - see below
        }) {
      return AuthLoginDto(success, token, refreshToken);
    } else {
      throw FormatException('Invalid JSON: $data');
    }
  }
}
