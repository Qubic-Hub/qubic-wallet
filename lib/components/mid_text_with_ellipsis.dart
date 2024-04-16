import 'package:flutter/material.dart';

class TextWithMidEllipsis extends StatelessWidget {
  final String data;
  final TextStyle style;
  final TextAlign? textAlign;
  const TextWithMidEllipsis(
    this.data, {
    Key? key,
    this.textAlign,
    this.style = const TextStyle(),
  }) : super(key: key);

  final textDirection = TextDirection.ltr;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth <= _textSize(data, style).width &&
            data.length > 10) {
          var endPart = data.trim().substring(data.length - 30);
          return Row(
            children: [
              Flexible(
                child: Text(
                  data.fixOverflowEllipsis,
                  style: style,
                  textAlign: textAlign,
                  overflow: TextOverflow.ellipsis,
                  textDirection: textDirection,
                ),
              ),
              Text(
                endPart,
                style: style,
                textDirection: textDirection,
                textAlign: textAlign,
              ),
            ],
          );
        }
        return Text(
          data,
          style: style,
          textAlign: textAlign,
          maxLines: 1,
          textDirection: textDirection,
        );
      },
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      maxLines: 1,
      textDirection: textDirection,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

extension AppStringExtension on String {
  String get fixOverflowEllipsis => Characters(this)
      .replaceAll(Characters(''), Characters('\u{200B}'))
      .toString();
}
