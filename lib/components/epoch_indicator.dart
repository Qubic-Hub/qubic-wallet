import 'package:flutter/material.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/epoch_helperts.dart';

import '../stores/application_store.dart';

class EpochIndicator extends StatelessWidget {
  final ApplicationStore appStore = getIt<ApplicationStore>();

  EpochIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Epoch: ",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontFamily: ThemeFonts.primary)),
      Text(
        '${getCurrentEpoch()} ',
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontFamily: ThemeFonts.primary),
        // This key causes the AnimatedSwitcher to interpret this as a "new"
        // child each time the count changes, so that it will begin its animation
        // when the count changes.
      ),
    ]);
  }
}
