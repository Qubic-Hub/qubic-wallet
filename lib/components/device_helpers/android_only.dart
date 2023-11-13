import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class AndroidOnly extends StatelessWidget {
  final Widget child;
  const AndroidOnly({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isAndroid ? child : Container();
  }
}
