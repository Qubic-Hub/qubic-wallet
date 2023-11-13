import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class MacOSOnly extends StatelessWidget {
  final Widget child;
  const MacOSOnly({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isMacOS ? child : Container();
  }
}
