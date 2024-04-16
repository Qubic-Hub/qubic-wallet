import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
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
              return Ink(
                  decoration: const ShapeDecoration(
                    color: LightThemeColors.panelBackground,
                    shape: CircleBorder(),
                  ),
                  child: SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        color: LightThemeColors.cardBackground,
                        highlightColor: LightThemeColors.extraStrongBackground,
                        onPressed: () {
                          _timedController.interruptFetchTimer();
                        },
                        icon: const Icon(Icons.refresh,
                            color: LightThemeColors.primary, size: 20),
                      )));
            } else {
              return Container();
            }
          });
  }
}
