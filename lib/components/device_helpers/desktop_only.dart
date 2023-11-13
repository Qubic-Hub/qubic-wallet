import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class DesktopOnly extends StatelessWidget {
  final Widget child;
  const DesktopOnly({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isWindows ||
            UniversalPlatform.isLinux ||
            UniversalPlatform.isFuchsia ||
            UniversalPlatform.isMacOS
        ? child
        : Container();
  }
}
