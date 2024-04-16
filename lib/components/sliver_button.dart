import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';
import 'package:qubic_wallet/helpers/platform_helpers.dart';
import 'package:qubic_wallet/timed_controller.dart';

import '../stores/application_store.dart';

class SliverButton extends StatelessWidget {
  final ApplicationStore appStore = getIt<ApplicationStore>();

  final Function()? onPressed;
  final Widget icon;

  SliverButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                  if (onPressed != null) {
                    onPressed!();
                  }
                },
                icon: icon)));
  }
}
