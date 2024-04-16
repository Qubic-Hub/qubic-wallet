import 'package:flutter/material.dart';
import 'package:qubic_wallet/flutter_flow/theme_paddings.dart';

class GradientForeground extends StatelessWidget {
  final Widget? child;
  GradientForeground({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => const LinearGradient(
        begin: Alignment(-1.0, 0.0),
        end: Alignment(1.0, 0.0),
        transform: GradientRotation(2.19911),
        stops: [
          0.03,
          1,
        ],
        colors: [
          LightThemeColors.gradient2,
          LightThemeColors.gradient1,
        ], // Gradient colors for the icon
      ).createShader(bounds),
      child: child != null ? child : Container(),
    );

    // return Container(
    //     child: this.child != null ? this.child : Container(),
    //     constraints: const BoxConstraints.expand(),
    //     decoration: const BoxDecoration(
    //         gradient: LinearGradient(
    //       begin: Alignment(-1.0, 0.0),
    //       end: Alignment(1.0, 0.0),
    //       transform: GradientRotation(2.19911),
    //       stops: [
    //         0.03,
    //         1,
    //       ],
    //       colors: [
    //         Color(0xFFBF0FFF),
    //         Color(0xFF0F27FF),
    //       ],
    //     )));
  }
}
