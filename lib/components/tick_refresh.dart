import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/helpers/platform_helpers.dart';
import 'package:qubic_wallet/timed_controller.dart';

import '../stores/application_store.dart';

class TickRefresh extends StatelessWidget {
  final ApplicationStore appStore = getIt<ApplicationStore>();
  final TimedController _timedController = getIt<TimedController>();

  TickRefresh({super.key});

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Container()
        : Observer(builder: (context) {
            if (appStore.pendingRequests == 0) {
              return IconButton(
                onPressed: () {
                  _timedController.interruptFetchTimer();
                },
                icon: Icon(Icons.refresh,
                    color: Theme.of(context).colorScheme.primary),
              );
            } else {
              return Container();
            }
          });
  }
}
