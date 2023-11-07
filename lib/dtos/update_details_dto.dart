class UpdateDetailsDto {
  final String? version;
  final bool critical;
  final String? message;
  final String? major;
  final String? minor;
  final String? url;

  UpdateDetailsDto({
    required this.version,
    required this.critical,
    required this.message,
    required this.major,
    required this.minor,
    required this.url,
  });

  factory UpdateDetailsDto.fromJson(Map<String, dynamic> json) {
    return UpdateDetailsDto(
      version: json['version'],
      critical: json['critical'],
      message: json['message'],
      major: json['major'],
      minor: json['minor'],
      url: json['url'],
    );
  }

  UpdateDetailsDto clone() {
    return UpdateDetailsDto(
      version: version,
      critical: critical,
      message: message,
      major: major,
      minor: minor,
      url: url,
    );
  }
}
