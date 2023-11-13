import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class LinuxOnly extends StatelessWidget {
  final Widget child;
  const LinuxOnly({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isLinux ? child : Container();
  }
}
