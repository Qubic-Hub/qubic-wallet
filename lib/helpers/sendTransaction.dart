import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/helpers/show_alert_dialog.dart';
import 'package:qubic_wallet/resources/qubic_cmd.dart';
import 'package:qubic_wallet/resources/qubic_js.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/stores/application_store.dart';

void showTamperedWalletAlert(BuildContext context) {
  showAlertDialog(context, "TAMPERED WALLET DETECTED",
      "THE WALLET YOU ARE CURRENTLY USING IS TAMPERED.\n\nINSTALL AN OFFICIAL VERSION FROM QUBIC-HUB.COM OR RISK LOSS OF FUNDS");
}

///
/// Sends a transaction of value $QUBIC from the sourceId to the QX address
/// Also involves moving around tokens from the sourceId to the destinationId
Future<bool> sendAssetTransferTransactionDialog(
    BuildContext context,
    String sourceId,
    String destinationId,
    String assetName,
    String issuer,
    int numberOfAssets,
    int destinationTick) async {
  String seed = await getIt.get<ApplicationStore>().getSeedByPublicId(sourceId);
  late String transactionKey;
  QubicCmd qubicCmd = getIt.get<QubicCmd>();
  try {
    transactionKey = await qubicCmd.createAssetTransferTransaction(seed,
        destinationId, assetName, issuer, numberOfAssets, destinationTick);
    await getIt.get<QubicLi>().submitTransaction(transactionKey);
    return true;
  } catch (e) {
    if (e.toString().startsWith("Exception: CRITICAL:")) {
      showTamperedWalletAlert(context);
      return false;
    }

    showAlertDialog(
        context, "Error while generating transaction: ", e.toString());

    return false;
  }
}

///
/// Sends a transaction of value $QUBIC from the sourceId to the destinationId
Future<bool> sendTransactionDialog(BuildContext context, String sourceId,
    String destinationId, int value, int destinationTick) async {
  String seed = await getIt.get<ApplicationStore>().getSeedByPublicId(sourceId);
  late String transactionKey;
  QubicCmd qubicCmd = getIt.get<QubicCmd>();
  try {
    //Get the signed transaction
    transactionKey = await qubicCmd.createTransaction(
        seed, destinationId, value, destinationTick);
  } catch (e) {
    if (e.toString().startsWith("Exception: CRITICAL:")) {
      showTamperedWalletAlert(context);
      return false;
    }

    showAlertDialog(
        context, "Error while generating transaction: ", e.toString());

    return false;
  }

  //We have the transaction, now let's call the API
  try {
    await getIt.get<QubicLi>().submitTransaction(transactionKey);
  } catch (e) {
    showAlertDialog(context, "Error while sending transaction", e.toString());
    return false;
  }
  return true;
}
