import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class MobileOnly extends StatelessWidget {
  final Widget child;
  const MobileOnly({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isAndroid || UniversalPlatform.isIOS
        ? child
        : Container();
  }
}
