import 'dart:convert';
import 'dart:math';

/// Stores all encrypted critical settings
class CriticalSettings {
  /// The password hash for accessing the wallet
  late String? storedPasswordHash;

  /// A list of public Ids
  late List<String> publicIds;

  /// A list of private seeds
  late List<String> privateSeeds;

  /// A list of names (for each account)
  late List<String> names;

  String? padding;

  /// The mnemonic for the wallet. If null, wallet has only manual accounts
  late String? mnemonic;

  /// Contains the publicIds which were generated from the mnemonic
  late List<String> idsGeneratedFromMnemonic;

  /// The derivation index for the generated Ids
  late int derivationIndex;

  CriticalSettings(
      {required this.storedPasswordHash,
      required this.publicIds,
      required this.privateSeeds,
      required this.names,
      this.padding,
      this.mnemonic,
      this.idsGeneratedFromMnemonic = const []}) {
    padding ??= _generateRandomString();
  }

  String _generateRandomString() {
    var r = Random();
    var len = Random().nextInt(128);
    while (len < 64) {
      len = Random().nextInt(128);
    }
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  String toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storedPasswordHash'] = storedPasswordHash;
    data['padding'] = padding;
    data['publicIds'] = publicIds;
    data['privateSeeds'] = privateSeeds;
    data['names'] = names;
    data['mnemonic'] = mnemonic;
    data['IdsGeneratedFromMnemonic'] = idsGeneratedFromMnemonic;
    return json.encode(data);
  }

  factory CriticalSettings.fromJSON(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    final String storedPasswordHash = data['storedPasswordHash'];
    final List<String> publicIds = List<String>.from(data['publicIds']);
    final List<String> privateSeeds = List<String>.from(data['privateSeeds']);
    final List<String> names = List<String>.from(data['names']);
    final String? mnemonic =
        data.containsKey("mnemonic") ? data['mnemonic'] : null;
    final List<String> idsGeneratedFromMnemonic =
        data.containsKey("IdsGeneratedFromMnemonic")
            ? List<String>.from(data['IdsGeneratedFromMnemonic'])
            : [];
    final String? padding =
        data.containsKey("padding") ? data['padding'] : null; //data['padding'];
    return CriticalSettings(
        storedPasswordHash: storedPasswordHash,
        publicIds: publicIds,
        privateSeeds: privateSeeds,
        names: names,
        padding: padding,
        idsGeneratedFromMnemonic: idsGeneratedFromMnemonic,
        mnemonic: mnemonic);
  }
}
