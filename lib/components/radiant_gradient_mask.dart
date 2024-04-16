import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

class RadiantGradientMask extends StatelessWidget {
  final Widget child;
  const RadiantGradientMask({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment(-1.0, 0.0),
          end: Alignment(1.0, 0.0),
          transform: GradientRotation(2.19911),
          stops: [
            0.03,
            1,
          ],
          colors: [
            Color(0xFFBF0FFF),
            Color(0xFF0F27FF),
          ]).createShader(bounds),
      child: child,
    );
  }
}
