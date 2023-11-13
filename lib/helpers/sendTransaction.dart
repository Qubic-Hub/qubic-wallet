import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/helpers/show_alert_dialog.dart';
import 'package:qubic_wallet/resources/qubic_cmd.dart';
import 'package:qubic_wallet/resources/qubic_js.dart';
import 'package:qubic_wallet/resources/qubic_li.dart';
import 'package:qubic_wallet/stores/application_store.dart';

Future<bool> sendTransactionDialog(BuildContext context, String sourceId,
    String destinationId, int value, int destinationTick) async {
  String seed = await getIt.get<ApplicationStore>().getSeedByPublicId(sourceId);
  late String transactionKey;
  late QubicCmd qubicCmd = QubicCmd();
  try {
    await qubicCmd.initialize();
    //Get the signed transaction
    transactionKey = await qubicCmd.createTransaction(
        seed, destinationId, value, destinationTick);
  } catch (e) {
    if (e.toString().startsWith("Exception: CRITICAL:")) {
      showAlertDialog(context, "TAMPERED WALLET DETECTED",
          "THE WALLET YOU ARE CURRENTLY USING IS TAMPERED.\n\nINSTALL AN OFFICIAL VERSION FROM QUBIC-HUB.COM OR RISK LOSS OF FUNDS");
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
