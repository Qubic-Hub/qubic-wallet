import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/extensions/asThousands.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

import '../stores/application_store.dart';

//TODO: Delete me

class TickIndicator extends StatelessWidget {
  final ApplicationStore appStore = getIt<ApplicationStore>();

  TickIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Tick: ",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontFamily: ThemeFonts.primary)),
      Observer(builder: (context) {
        if (appStore.currentTick == 0) {
          return Text("...",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontFamily: ThemeFonts.primary));
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            '${appStore.currentTick.asThousands()} ',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: ThemeFonts.primary),
            // This key causes the AnimatedSwitcher to interpret this as a "new"
            // child each time the count changes, so that it will begin its animation
            // when the count changes.
            key: ValueKey<String>("tck${appStore.currentTick}"),
          ),
        );
        //Text(" Current tick: ${appStore.currentTick}");
      }),
      Observer(builder: (context) {
        if (appStore.pendingRequests > 0) {
          return SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary));
        }
        return Container();
      })
    ]);
  }
}
