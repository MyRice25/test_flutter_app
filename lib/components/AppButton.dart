import 'package:flutter/material.dart';
import '../constants/Constants.dart';
import '../constants/StringConstants.dart';
import '../constants/app_colors.dart';

// 앱 고유 텍스트
class AppButton extends StatelessWidget {
  TextDecoration? textDecoration;
  String text;
  Color? textColor;
  Color? disableTextColor;
  Color? color;
  Color? disableColor;
  double? fontSize;
  FontWeight? fontWeight;
  String? fontFamily;
  TextAlign? textAlign;
  TextOverflow? overflow;
  Function() onTap;
  int? maxLine;
  double? borderRadius;
  double? margin;
  double? verticalMargin;
  double? height;
  double? width;
  BoxBorder? border;
  bool? disabled;
  String? image;
  double? imageSize;

  AppButton({
    Key? key,
    required this.text,
    this.color,
    this.disableTextColor,
    this.disableColor,
    this.fontFamily,
    this.height,
    this.textAlign,
    this.overflow,
    this.maxLine,
    this.margin,
    this.borderRadius,
    required this.onTap,
    this.width,
    this.textColor,
    this.fontWeight,
    this.disabled,
    this.fontSize,
    this.border,
    this.image,
    this.verticalMargin,
    this.textDecoration,
    this.imageSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50,
      margin: EdgeInsets.only(
        left: margin ?? sideMargin,
        right: margin ?? sideMargin,
        top: verticalMargin ?? 0,
        bottom: verticalMargin ?? 0,
      ),
      decoration: BoxDecoration(
        color: disabled ?? false
            ? disableColor ?? AppColors.gray200
            : color ?? AppColors.black,
        border: border ?? null,
        borderRadius: BorderRadius.circular(
          borderRadius ?? 8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
        child: Material(
          color: disabled ?? false
              ? disableColor ?? AppColors.gray200
              : color ?? AppColors.black,
          child: InkWell(
            onTap: disabled ?? false ? () {} : onTap,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (image != null)
                    Row(
                      children: [
                        Image.asset(
                          image!,
                          width: imageSize ?? 30,
                          height: imageSize ?? 30,
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  Text(
                    text,
                    textAlign: textAlign ?? TextAlign.center,
                    overflow: overflow,
                    maxLines: maxLine,
                    style: TextStyle(
                      decoration: textDecoration ?? TextDecoration.none,
                      fontFamily: StringConstants.AppFont,
                      fontWeight: fontWeight ?? FontWeight.w500,
                      fontSize: fontSize ?? 16,
                      letterSpacing: 0.02,
                      color: disabled ?? false
                          ? disableTextColor ?? AppColors.white
                          : textColor ?? AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
