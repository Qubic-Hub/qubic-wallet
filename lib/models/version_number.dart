import 'dart:io';

/// A class representing a version number.
class VersionNumber {
  int major;
  int minor;
  int patch;

  /// Constructor for creating a VersionNumber object.
  ///
  /// [major], [minor], and [patch] are required integer values representing the version number.
  VersionNumber({
    required this.major,
    required this.minor,
    required this.patch,
  });

  /// Factory constructor for creating a VersionNumber object from a string.
  ///
  /// [version] is a string representing the version number in the format "major.minor.patch".
  factory VersionNumber.fromString(String version) {
    final parts = version.split('.');
    return VersionNumber(
      major: int.parse(parts[0]),
      minor: int.parse(parts[1]),
      patch: int.parse(parts[2]),
    );
  }

  /// Greater than operator for comparing two VersionNumber objects.
  bool operator >(VersionNumber b) {
    if (major > b.major) return true;
    if (major == b.major && minor > b.minor) return true;
    if (major == b.major && minor == b.minor && patch > b.patch) return true;
    return false;
  }

  /// Less than operator for comparing two VersionNumber objects.
  bool operator <(VersionNumber b) {
    if (major < b.major) return true;
    if (major == b.major && minor < b.minor) return true;
    if (major == b.major && minor == b.minor && patch < b.patch) return true;
    return false;
  }

  /// Equality operator for comparing two VersionNumber objects.
  @override
  bool operator ==(Object other) =>
      other is VersionNumber &&
      major == other.major &&
      minor == other.minor &&
      patch == other.patch;

  /// Hash code getter for the VersionNumber object.
  @override
  int get hashCode => Object.hash(major, minor, patch);

  /// Greater than or equal to operator for comparing two VersionNumber objects.
  bool operator >=(VersionNumber b) {
    return this > b || this == b;
  }

  /// Less than or equal to operator for comparing two VersionNumber objects.
  bool operator <=(VersionNumber b) {
    return this < b || this == b;
  }
}
