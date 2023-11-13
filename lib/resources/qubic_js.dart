// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/services.dart' show rootBundle;

/// A class that handles the secure storage of the wallet. The wallet is stored in the secure storage of the device
/// The wallet password is encrypted using Argon2
class QubicJs {
  HeadlessInAppWebView? InAppWebView;
  InAppWebViewController? controller;
  bool validatedFileStream = false;
  final INDEX_MD5 =
      "04f37ff21095e21b6175408be018f849"; //MD5 of the index.html file to prevent tampering in run time
  initialize() async {
    if (controller != null) {
      debugPrint("QubicJS: Controller already set. No need to initialize");
      return;
    }
    InAppWebView = HeadlessInAppWebView(
        onWebViewCreated: (WVcontroller) {
          WVcontroller.loadFile(assetFilePath: "assets/qubic_js/index.html");

          controller = WVcontroller;
        },
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint(consoleMessage.toString());
        },
        onLoadStart: (controller, url) {},
        onLoadStop: (controller, url) async {
          isReady = true;
        });

    await InAppWebView!.run();
  }

  bool isReady = false;

  disposeController() {
    controller!.dispose();
    controller = null;
    isReady = false;
  }

  guardInitialized() {
    if (controller == null) {
      throw Exception('Controller not set');
    }
    if (!isReady) {
      throw Exception('WebView not initialized yet');
    }
  }

  setController(InAppWebViewController controller) {
    this.controller = controller;
  }

  Future<String> createTransaction(
      String seed, String destinationId, int value, int tick) async {
    await validateFileStreamSignature();

    String functionBody =
        "await qHelper.createTransaction('${seed.replaceAll("'", "\\'")}', '${destinationId.replaceAll("'", "\\'")}', $value, $tick)";
    functionBody = "return arrayBufferToBase64($functionBody)";

    initialize();
    CallAsyncJavaScriptResult? result =
        await controller!.callAsyncJavaScript(functionBody: functionBody);

    if (result == null) {
      throw Exception("Error trying to create transcation");
    }
    if (result.error != null) {
      throw Exception("Error trying to create transcation: ${result.error}");
    }
    return result.value;
  }

  Future<void> validateFileStreamSignature() async {
    final jsSource = await controller!.getHtml();
    final checksum = crypto.md5.convert(utf8.encode(jsSource!)).toString();

    if (checksum != INDEX_MD5) {
      throw Exception(
          "CRITICAL: YOUR INSTALLATION OF QUBIC WALLET IS TAMPERED. PLEASE UNINSTALL AND DOWNLOAD AGAIN FROM QUBIC-HUB.COM CHECKSUM:${checksum} VS ${INDEX_MD5}");
    }
    validatedFileStream = true;

    return;
  }

  Future<String> getPublicIdFromSeed(String seed) async {
    await validateFileStreamSignature();
    CallAsyncJavaScriptResult? result = await controller!.callAsyncJavaScript(
        functionBody:
            "return await qHelper.createPublicId('${seed.replaceAll("'", "\\'")}')");

    if (result == null) {
      throw Exception('Error getting public id from seed: Generic error');
    }
    if (result.error != null) {
      throw Exception('Error getting public id from seed:  ${result.error!}');
    }
    return result.value['publicId'];
  }
}
