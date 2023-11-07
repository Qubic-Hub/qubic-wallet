import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobx/mobx.dart';
import 'package:qubic_wallet/models/qubic_list_vm.dart';

class CustomFormFieldValidators {
  static FormFieldValidator<T> isLessThanParsed<T>({required int lessThan}) {
    return (T? valueCandidate) {
      if (valueCandidate == null) {
        return null;
      }

      if (lessThan == 0) {
        return "Insufficient funds in ID. ID has no funds";
      }

      String toParse = (valueCandidate as String)
          .replaceAll(" ", "")
          .replaceAll("\$QUBIC", "")
          .replaceAll(",", "");

      int? parsedVal = int.tryParse(toParse);
      if (parsedVal == null) {
        return "Is not a numeric value";
      }
      if (parsedVal > lessThan) {
        return "Insufficient funds in ID";
      }

      return null;
    };
  }

  static FormFieldValidator<T> presentTick<T>({required int currentTick}) {
    return (T? valueCandidate) {
      if (valueCandidate == null) {
        return null;
      }
      if ((valueCandidate as int) > currentTick) {
        return "Provided tick is in the past. Current tick is $currentTick";
      }

      return null;
    };
  }

  static FormFieldValidator<T> isLessThan<T>({required int lessThan}) {
    return (T? valueCandidate) {
      if (valueCandidate == null) {
        return null;
      }
      if ((valueCandidate as int) > lessThan) {
        return "Must be less than $lessThan";
      }

      return null;
    };
  }

  static FormFieldValidator<T> isPublicIdAvailable<T>(
      {required ObservableList<QubicListVm> currentQubicIDs,
      maxNumberOfIDs = 0}) {
    return (T? valueCandidate) {
      if (valueCandidate == null) {
        return null;
      }
      int total = currentQubicIDs
          .where((element) =>
              element.publicId ==
              valueCandidate.toString().replaceAll(",", "_"))
          .length;
      if (total > maxNumberOfIDs) {
        return "Public ID already in use";
      }
      return null;
    };
  }

  static FormFieldValidator<T> isNameAvailable<T>(
      {required ObservableList<QubicListVm> currentQubicIDs,
      String? ignorePublicId}) {
    return (T? valueCandidate) {
      if (valueCandidate == null) {
        return null;
      }

      int total = ignorePublicId == null
          ? currentQubicIDs
              .where((element) =>
                  element.name ==
                  valueCandidate.toString().replaceAll(",", "_"))
              .length
          : currentQubicIDs
              .where((element) =>
                  element.name ==
                      valueCandidate.toString().replaceAll(",", "_") &&
                  element.publicId != ignorePublicId)
              .length;
      if (total > 0) {
        return "Name is already in use";
      }
      return null;
    };
  }

  static FormFieldValidator<T> isSeed<T>({
    String? errorText,
  }) {
    HashSet validChars = HashSet();
    validChars.addAll({
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "w",
      "x",
      "y",
      "z"
    });

    return (T? valueCandidate) {
      if (valueCandidate == null ||
          (valueCandidate is String && valueCandidate.trim().isEmpty)) {
        return errorText ?? FormBuilderLocalizations.current.requiredErrorText;
      }

      if (valueCandidate is String && valueCandidate.length != 55) {
        return "Must be 55 characters long";
      }

      bool valid = true;
      for (int i = 0; i < (valueCandidate as String).length; i++) {
        if (!validChars.contains(valueCandidate[i])) {
          valid = false;
        }
      }
      if (!valid) {
        return "Must contain only lowercase letters";
      }

      return null;
    };
  }

  static FormFieldValidator<T> isPublicID<T>({
    String? errorText,
  }) {
    HashSet validChars = HashSet();
    validChars.addAll({
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
    });

    return (T? valueCandidate) {
      if (valueCandidate == null ||
          (valueCandidate is String && valueCandidate.trim().isEmpty)) {
        return errorText ?? FormBuilderLocalizations.current.requiredErrorText;
      }

      if (valueCandidate is String && valueCandidate.length != 60) {
        return "Must be 55 characters long";
      }

      bool valid = true;
      for (int i = 0; i < (valueCandidate as String).length; i++) {
        if (!validChars.contains(valueCandidate[i])) {
          valid = false;
        }
      }
      if (!valid) {
        return "Must contain only uppercase letters";
      }

      return null;
    };
  }
}
