import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/stores/explorer_store.dart';

class ExplorerLoadingIndicator extends StatelessWidget {
  final ExplorerStore expStore = getIt<ExplorerStore>();

  ExplorerLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Observer(builder: (context) {
        if (expStore.pendingRequests > 0) {
          return SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.inversePrimary));
        }
        return Container();
      })
    ]);
  }
}
