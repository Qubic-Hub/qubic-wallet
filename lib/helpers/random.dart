import 'dart:math';

/// Generates a random seed
String getRandomSeed() {
  const chars = 'abcdefghijklmnopqrstuvwxyz';
  Random rnd = Random.secure();

  return String.fromCharCodes(Iterable.generate(
      55, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}
