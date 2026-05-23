import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../constants/StringConstants.dart';
import '../constants/app_colors.dart';

class AppText extends StatelessWidget {
  TextDecoration? textDecoration;
  String text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  String? fontFamily;
  TextAlign? textAlign;
  FontStyle? fontStyle;
  TextOverflow? overflow = TextOverflow.ellipsis;
  int? maxLine;
  int? maxLength;
  double? height;
  double? width;
  double? letterSpacing;

  AppText({
    super.key,
    required this.text,
    this.color,
    this.fontFamily,
    this.height,
    this.textAlign,
    this.overflow,
    this.maxLine,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.width,
    this.maxLength,
    this.letterSpacing,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLine,
      style: TextStyle(
        height: height ?? 1.4,
        decoration: textDecoration ?? TextDecoration.none,
        decorationColor: color ?? AppColors.appBlack,
        fontFamily: fontFamily ?? StringConstants.AppFont,
        fontSize: fontSize ?? 14,
        letterSpacing: letterSpacing ?? -0.48,
        fontStyle: fontStyle ?? FontStyle.normal,
        fontWeight: fontWeight ?? FontWeight.w700,
        color: color ?? AppColors.gray800,
      ),
    );
  }
}
