// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qubic_wallet/models/qubic_id.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';
import 'package:qubic_wallet/models/settings.dart';

class SecureStorageKeys {
  static const prepend = kReleaseMode
      ? "QW_"
      : "QW_DEBUG_"; // The prefix of all the keys in the secure storage

  static const criticalSettings =
      "${prepend}_CSETTINGS"; //The critical settings

  static const passwordHash =
      "${prepend}_PH"; // The hash of the password used to sign in the wallet
  static const walletSchemaVersion =
      "${prepend}_WV"; // The version of the wallet schema
  static const numberOfIDs =
      "${prepend}_NIDs"; // The number of IDs in the wallet
  static const privateSeedsList = "${prepend}_PS"; // The private IDs
  static const publicIdsList = "${prepend}_PIDs"; // The public IDs
  static const namesList = "${prepend}_NAMEs"; // The names of the IDs
  static const settings = "${prepend}_SETTINGS"; // The settings of the wallet
}

class PassAndHash {
  late String password;
  late String hash;
  PassAndHash({required this.password, required this.hash});
}

class PassAndSalt {
  late String password;
  late Salt salt;
  PassAndSalt({required this.password, required this.salt});
}

class CriticalSettings {
  late String? storedPasswordHash;
  late List<String> publicIds;
  late List<String> privateSeeds;
  late List<String> names;
  String? padding;
  CriticalSettings(
      {required this.storedPasswordHash,
      required this.publicIds,
      required this.privateSeeds,
      required this.names,
      this.padding}) {
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

    return json.encode(data);
  }

  factory CriticalSettings.fromJSON(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    final String storedPasswordHash = data['storedPasswordHash'];
    final List<String> publicIds = List<String>.from(data['publicIds']);
    final List<String> privateSeeds = List<String>.from(data['privateSeeds']);
    final List<String> names = List<String>.from(data['names']);
    final String? padding =
        data.containsKey("padding") ? data['padding'] : null; //data['padding'];
    return CriticalSettings(
        storedPasswordHash: storedPasswordHash,
        publicIds: publicIds,
        privateSeeds: privateSeeds,
        names: names,
        padding: padding);
  }
}

/// A class that handles the secure storage of the wallet. The wallet is stored in the secure storage of the device
/// The wallet password is encrypted using Argon2
class SecureStorage {
  final ARGON2_TYPE = Argon2Type.id;
  final ARGON2_SALT_SIZE_BYTES = 32; //(256 bit)
  final ARGON2_ITERATIONS = 64;
  final ARGON2_MEMORY_SIZE = 1024;
  final ARGON2_PARALLELISM = 2;
  final ARGON2_LENGTH = 32;
  late final FlutterSecureStorage storage;
  late String prepend;
  SecureStorage() {
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<DArgon2Result> getPasswordHash(String password) async {
    var result = await compute((String password) async {
      DArgon2Flutter.init();

      return await argon2.hashPasswordString(password,
          salt: Salt.newSalt(length: ARGON2_SALT_SIZE_BYTES),
          type: ARGON2_TYPE,
          iterations: ARGON2_ITERATIONS,
          memory: ARGON2_MEMORY_SIZE,
          parallelism: ARGON2_PARALLELISM,
          length: ARGON2_LENGTH,
          version: Argon2Version.V13);
    }, password);
    return result;
  }

  Future<CriticalSettings> getCriticalSettings() async {
    String? json = await storage.read(key: SecureStorageKeys.criticalSettings);
    if (json == null) {
      throw "Error while fetching critical settings";
    }
    try {
      return CriticalSettings.fromJSON(json);
    } catch (e) {
      throw "Error while parsing critical settings";
    }
  }

  /// Signs a user in the wallet. Updates the padding of the wallet settings
  /// if user signs in correctly
  /// Returns true if the password is correct
  Future<bool> signInWallet(String password) async {
    CriticalSettings settings = await getCriticalSettings();
    if (password.isEmpty ||
        password.trim().isEmpty ||
        settings.storedPasswordHash == null ||
        settings.storedPasswordHash!.trim().isEmpty) {
      return false;
    }

    var result = await compute((PassAndHash message) async {
      try {
        DArgon2Flutter.init();

        var res = await argon2.verifyHashString(message.password, message.hash,
            type: ARGON2_TYPE);
        return res;
      } catch (e) {
        return false;
      }
    }, PassAndHash(password: password, hash: settings.storedPasswordHash!));

    if (result) {
      Settings s = await getWalletSettings();
      s.padding = settings.padding;
      await setWalletSettings(s);
    }
    return result;
  }

  //Makes sure that all the wallet keys are valid
  Future<bool> validateWalletContents() async {
    late CriticalSettings csettings;
    try {
      csettings = await getCriticalSettings();
    } catch (e) {
      return false;
    }
    String? settings = await storage.read(key: SecureStorageKeys.settings);
    if (settings == null) {
      return false;
    }
    return true;
  }

  Future<bool> savePassword(String password) async {
    if (password.isEmpty || password.trim().isEmpty) {
      return false;
    }
    try {
      var result = await getPasswordHash(password);
      CriticalSettings settings = await getCriticalSettings();
      settings.storedPasswordHash = result.encodedString;
      await storage.write(
          key: SecureStorageKeys.criticalSettings, value: settings.toJSON());
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  // Creates a new wallet
  // Returns true if the wallet was created successfully
  Future<bool> createWallet(String password) async {
    if (password.isEmpty || password.trim().isEmpty) {
      return false;
    }
    var result = await getPasswordHash(password);
    CriticalSettings csettings = CriticalSettings(
        storedPasswordHash: result.encodedString,
        publicIds: [],
        privateSeeds: [],
        names: []);

    await storage.write(
        key: SecureStorageKeys.criticalSettings, value: csettings.toJSON());
    await storage.write(
        key: SecureStorageKeys.settings,
        value: Settings(
                TOTPKey: null,
                biometricEnabled: false,
                padding: csettings.padding)
            .toJSON());
    return true;
  }

  Future<Settings> getWalletSettings() async {
    String? settings = await storage.read(key: SecureStorageKeys.settings);
    if (settings == null) {
      throw Exception("Settings not found");
    }

    Settings settingsObj;
    try {
      settingsObj = Settings.fromJson(settings);
    } catch (e) {
      throw Exception("Settings not found or malformed");
    }

    return settingsObj;
  }

  Future<void> updateWalletSettingsPadding(String padding) async {
    var settings = await getWalletSettings();
    settings.padding = padding;
    await storage.write(
        key: SecureStorageKeys.settings, value: settings.toJSON());
  }

  Future<Settings> setWalletSettings(Settings settings) async {
    var csettings = await getCriticalSettings();
    settings.padding = csettings.padding;

    await storage.write(
        key: SecureStorageKeys.settings, value: settings.toJSON());
    return settings;
  }

  Future<List<QubicListVm>> getWalletContents() async {
    CriticalSettings settings = await getCriticalSettings();
    List<QubicListVm> list = [];
    for (int i = 0; i < settings.publicIds.length; i++) {
      list.add(QubicListVm(
          settings.publicIds[i], settings.names[i], null, null, null));
    }
    return list;
  }

  Future<bool> deleteWallet() async {
    //Note The current implementation of flutter_secure_storage does not support readAll and deleteAll .
    await storage.delete(key: SecureStorageKeys.criticalSettings);
    await storage.delete(key: SecureStorageKeys.settings);
    return true;
  }

  // Adds a new Qubic ID to the secure storage
  Future<void> addID(QubicId qubicId) async {
    CriticalSettings settings = await getCriticalSettings();

    settings.privateSeeds.add(qubicId.getPrivateSeed());
    settings.publicIds.add(qubicId.getPublicId());
    settings.names.add(qubicId.getName());
    await storage.write(
        key: SecureStorageKeys.criticalSettings, value: settings.toJSON());
    await updateWalletSettingsPadding(settings.padding!);
  }

  Future<void> renameId(String publicId, String name) async {
    CriticalSettings settings = await getCriticalSettings();
    int i = settings.publicIds.indexOf(publicId);
    if (i == -1) return;
    settings.names[i] = name;

    await storage.write(
        key: SecureStorageKeys.criticalSettings, value: settings.toJSON());
    await updateWalletSettingsPadding(settings.padding!);
  }

  //Gets a Qubic ID from a public key
  Future<QubicId> getIdByPublicKey(String publicKey) async {
    CriticalSettings settings = await getCriticalSettings();
    int i = settings.publicIds.indexOf(publicKey);
    if (i == -1) {
      throw Exception("ID not found");
    }
    return QubicId(settings.privateSeeds[i], settings.publicIds[i],
        settings.names[i], null);
  }

  //Removes a Qubic ID from the secure Storage (Based on its public key)
  Future<bool> removeID(String publicKey) async {
    CriticalSettings settings = await getCriticalSettings();
    int i = settings.publicIds.indexOf(publicKey);
    if (i == -1) {
      return false;
    }

    settings.privateSeeds.removeAt(i);
    settings.publicIds.removeAt(i);
    settings.names.removeAt(i);
    await storage.write(
        key: SecureStorageKeys.criticalSettings, value: settings.toJSON());
    await updateWalletSettingsPadding(settings.padding!);
    return true;
  }
}
