// ignore_for_file: non_constant_identifier_names

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

  /// Signs a user in the wallet
  /// Returns true if the password is correct
  Future<bool> signInWallet(String password) async {
    String? storedPasswordHash =
        await storage.read(key: SecureStorageKeys.passwordHash);

    if (password.isEmpty ||
        password.trim().isEmpty ||
        storedPasswordHash == null ||
        storedPasswordHash.trim().isEmpty) {
      return false;
    }
    return await compute((PassAndHash message) async {
      try {
        DArgon2Flutter.init();

        var res = await argon2.verifyHashString(message.password, message.hash,
            type: ARGON2_TYPE);
        return res;
      } catch (e) {
        return false;
      }
    }, PassAndHash(password: password, hash: storedPasswordHash));
  }

  //Makes sure that all the wallet keys are valid
  Future<bool> validateWalletContents() async {
    String? storedPasswordHash =
        await storage.read(key: SecureStorageKeys.passwordHash);
    String? storedWalletSchemaVersion =
        await storage.read(key: SecureStorageKeys.walletSchemaVersion);
    String? storedNumberOfIDs =
        await storage.read(key: SecureStorageKeys.numberOfIDs);
    String? storedPrivateIDsList =
        await storage.read(key: SecureStorageKeys.privateSeedsList);
    String? storedPublicIDsList =
        await storage.read(key: SecureStorageKeys.publicIdsList);
    String? storedNamesList =
        await storage.read(key: SecureStorageKeys.namesList);
    String? settings = await storage.read(key: SecureStorageKeys.settings);

    if (storedPasswordHash == null ||
        storedWalletSchemaVersion == null ||
        storedNumberOfIDs == null ||
        storedPrivateIDsList == null ||
        storedPublicIDsList == null ||
        storedNamesList == null ||
        settings == null) {
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
      await storage.write(
          key: SecureStorageKeys.passwordHash, value: result.encodedString);
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

    await storage.write(
        key: SecureStorageKeys.passwordHash, value: result.encodedString);
    await storage.write(key: SecureStorageKeys.walletSchemaVersion, value: "1");
    await storage.write(key: SecureStorageKeys.numberOfIDs, value: "0");
    await storage.write(key: SecureStorageKeys.privateSeedsList, value: "");
    await storage.write(key: SecureStorageKeys.publicIdsList, value: "");
    await storage.write(key: SecureStorageKeys.namesList, value: "");
    await storage.write(
        key: SecureStorageKeys.settings,
        value: Settings(TOTPKey: null, biometricEnabled: false).toJSON());
    return true;
  }

  Future<Settings> getWalletSettings() async {
    String? settings = await storage.read(key: SecureStorageKeys.settings);
    if (settings == null) {
      throw Exception("Settings not found");
    }
    try {
      return Settings.fromJson(settings);
    } catch (e) {
      throw Exception("Settings not found or malformed");
    }
  }

  Future<Settings> setWalletSettings(Settings settings) async {
    await storage.write(
        key: SecureStorageKeys.settings, value: settings.toJSON());
    return settings;
  }

  Future<List<QubicListVm>> getWalletContents() async {
    String storedPublicIDsList =
        await storage.read(key: SecureStorageKeys.publicIdsList) ?? "";
    String storedNamesList =
        await storage.read(key: SecureStorageKeys.namesList) ?? "";

    List<QubicListVm> list = [];

//    List<String> privateSeeds = storedPrivateSeedsList != "" ? storedPrivateSeedsList.split(",") : [];
    List<String> publicIds =
        storedPublicIDsList != "" ? storedPublicIDsList.split(",") : [];
    List<String> names =
        storedNamesList != "" ? storedNamesList.split(",") : [];

    for (int i = 0; i < publicIds.length; i++) {
      list.add(QubicListVm(publicIds[i], names[i], null, null));
    }
    return list;
  }

  Future<bool> deleteWallet() async {
    //Note The current implementation of flutter_secure_storage does not support readAll and deleteAll .
    await storage.delete(key: SecureStorageKeys.privateSeedsList);
    await storage.delete(key: SecureStorageKeys.passwordHash);
    await storage.delete(key: SecureStorageKeys.walletSchemaVersion);
    await storage.delete(key: SecureStorageKeys.numberOfIDs);
    await storage.delete(key: SecureStorageKeys.publicIdsList);
    await storage.delete(key: SecureStorageKeys.namesList);
    await storage.delete(key: SecureStorageKeys.settings);
    return true;
  }

  // Adds a new Qubic ID to the secure storage
  Future<void> addID(QubicId qubicId) async {
    String storedPrivateSeedsList =
        await storage.read(key: SecureStorageKeys.privateSeedsList) ?? "";
    String storedPublicIDsList =
        await storage.read(key: SecureStorageKeys.publicIdsList) ?? "";
    String storedNamesList =
        await storage.read(key: SecureStorageKeys.namesList) ?? "";

    List<String> privateSeeds =
        storedPrivateSeedsList != "" ? storedPrivateSeedsList.split(",") : [];
    List<String> publicIds =
        storedPublicIDsList != "" ? storedPublicIDsList.split(",") : [];
    List<String> names =
        storedNamesList != "" ? storedNamesList.split(",") : [];

    privateSeeds.add(qubicId.getPrivateSeed());
    publicIds.add(qubicId.getPublicId());
    names.add(qubicId.getName());

    await storage.write(
        key: SecureStorageKeys.privateSeedsList, value: privateSeeds.join(","));
    await storage.write(
        key: SecureStorageKeys.publicIdsList, value: publicIds.join(","));
    await storage.write(
        key: SecureStorageKeys.namesList, value: names.join(","));
  }

  Future<void> renameId(String publicId, String name) async {
    String storedPrivateSeedsList =
        await storage.read(key: SecureStorageKeys.privateSeedsList) ?? "";
    String storedPublicIDsList =
        await storage.read(key: SecureStorageKeys.publicIdsList) ?? "";
    String storedNamesList =
        await storage.read(key: SecureStorageKeys.namesList) ?? "";
    List<String> privateSeeds =
        storedPrivateSeedsList != "" ? storedPrivateSeedsList.split(",") : [];
    List<String> publicIds =
        storedPublicIDsList != "" ? storedPublicIDsList.split(",") : [];
    List<String> names =
        storedNamesList != "" ? storedNamesList.split(",") : [];

    int i = publicIds.indexOf(publicId);
    if (i == -1) return;
    names[i] = name.replaceAll(",", "_");
    await storage.write(
        key: SecureStorageKeys.privateSeedsList, value: privateSeeds.join(","));
    await storage.write(
        key: SecureStorageKeys.publicIdsList, value: publicIds.join(","));
    await storage.write(
        key: SecureStorageKeys.namesList, value: names.join(","));
  }

  //Gets a Qubic ID from a public key
  Future<QubicId> getIdByPublicKey(String publicKey) async {
    String storedPrivateSeedsList =
        await storage.read(key: SecureStorageKeys.privateSeedsList) ?? "";
    String storedPublicIDsList =
        await storage.read(key: SecureStorageKeys.publicIdsList) ?? "";
    String storedNamesList =
        await storage.read(key: SecureStorageKeys.namesList) ?? "";

    List<String> privateSeeds =
        storedPrivateSeedsList != "" ? storedPrivateSeedsList.split(",") : [];
    List<String> publicIds =
        storedPublicIDsList != "" ? storedPublicIDsList.split(",") : [];
    List<String> names =
        storedNamesList != "" ? storedNamesList.split(",") : [];

    int i = publicIds.indexOf(publicKey);
    if (i == -1) {
      throw Exception("ID not found");
    }

    return QubicId(privateSeeds[i], publicIds[i], names[i], null);
  }

  //Removes a Qubic ID from the secure Storage (Based on its public key)
  Future<bool> removeID(String publicKey) async {
    String storedPrivateSeedsList =
        await storage.read(key: SecureStorageKeys.privateSeedsList) ?? "";
    String storedPublicIDsList =
        await storage.read(key: SecureStorageKeys.publicIdsList) ?? "";
    String storedNamesList =
        await storage.read(key: SecureStorageKeys.namesList) ?? "";

    List<String> privateSeeds =
        storedPrivateSeedsList != "" ? storedPrivateSeedsList.split(",") : [];
    List<String> publicIds =
        storedPublicIDsList != "" ? storedPublicIDsList.split(",") : [];
    List<String> names =
        storedNamesList != "" ? storedNamesList.split(",") : [];

    int i = publicIds.indexOf(publicKey);
    if (i == -1) {
      return false;
    }

    privateSeeds.removeAt(i);
    publicIds.removeAt(i);
    names.removeAt(i);

    if (privateSeeds.isEmpty) {
      await storage.write(key: SecureStorageKeys.privateSeedsList, value: "");
      await storage.write(key: SecureStorageKeys.publicIdsList, value: "");
      await storage.write(key: SecureStorageKeys.namesList, value: "");
      return true;
    }

    await storage.write(
        key: SecureStorageKeys.privateSeedsList, value: privateSeeds.join(","));
    await storage.write(
        key: SecureStorageKeys.publicIdsList, value: publicIds.join(","));
    await storage.write(
        key: SecureStorageKeys.namesList, value: names.join(","));
    return true;
  }
}
