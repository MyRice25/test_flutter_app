import 'package:flutter/cupertino.dart';

import '../AppText.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.text,
    this.textColor = const Color(0xFF8b8d95),
    this.borderColor = const Color(0x00000000),
    this.borderWidth = 0,
    this.fontSize = 16,
    this.backgroundColor = const Color(0xFFF7F7F7),
    this.borderRadius = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
  });

  final String text;
  final Color textColor;
  final double fontSize;
  final Color backgroundColor;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: AppText(
        text: text,
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
