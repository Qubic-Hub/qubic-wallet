// ignore_for_file: non_constant_identifier_names

import 'dart:core';

import 'package:mobx/mobx.dart';
import 'dart:convert';

enum TwoFaStrategy {
  lone,
  login,
  transfer,
  seed,
  all,
}

@observable
class Settings {
  @observable
  bool biometricEnabled = false; //The public ID

  @observable
  String? TOTPKey;

  Settings({
    this.biometricEnabled = false,
    this.TOTPKey,
  });

  factory Settings.clone(Settings original) {
    return Settings(
      biometricEnabled: original.biometricEnabled,
      TOTPKey: original.TOTPKey,
    );
  }

  String toJSON() {
    Map<String, dynamic> json = {
      'biometricEnabled': biometricEnabled,
      'TOTPKey': TOTPKey,
    };
    return jsonEncode(json);
  }

  factory Settings.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return Settings(
      biometricEnabled: json['biometricEnabled'],
      TOTPKey: json['TOTPKey'],
    );
  }
}
