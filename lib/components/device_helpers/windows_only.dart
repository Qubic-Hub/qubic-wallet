import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class WindowsOnly extends StatelessWidget {
  final Widget child;
  const WindowsOnly({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isWindows ? child : Container();
  }
}
