import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/StringConstants.dart';
import '../constants/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String? initialValue;
  final bool? isCollapsed;
  final TextEditingController? textController;
  final TextInputAction? textInputAction;
  final TextInputType? keyBoardType;
  final AutovalidateMode? autoValidateMode;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Color? textColor;
  final FontWeight? fontWeight;
  final bool? obscureText;
  final String? obscuringCharacter;
  final bool? isCursorEnable;
  final VoidCallback? callbackSuffix;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final TextDecoration? textDecoration;
  final TextDecorationStyle? textDecorationStyle;
  final Color? textDecorationColor;
  String? font;
  bool? readOnly;
  int? maxLength;
  int? minLines;
  int? maxLines;
  TextAlign? textAlign;
  double? fontSize;
  TextStyle? textStyle;
  TextStyle? labelStyle;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmmited;
  final String? errorText;
  final Color? textBorderColor;
  final Color? textFieldLight;
  final Color? textFieldDark;
  final Color? textColorHint;
  final Color? fillColor;
  final Color? enableBorderColor;
  final double? radius;
  final List<TextInputFormatter>? inputFormatters;
  final double? radiousFouse;
  final double? height;
  final EdgeInsets? contentPadding;
  OutlineInputBorder? border;
  OutlineInputBorder? disabledBorder;
  UnderlineInputBorder? underLineborder;
  final FocusNode? focusNode;
  final String? labelText;
  final Color? labelTextColor;
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final Widget? counter;
  final bool? autoFocus;
  final bool? enabled;

  AppTextField({
    super.key,
    this.isCollapsed,
    this.initialValue,
    this.keyBoardType,
    this.autoValidateMode,
    this.focusNode,
    this.textInputAction,
    this.textController,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onSubmmited,
    this.errorText,
    this.textColor,
    this.fontWeight,
    this.obscureText,
    this.obscuringCharacter,
    this.callbackSuffix,
    this.suffix,
    this.textDecoration,
    this.textDecorationStyle,
    this.textDecorationColor,
    this.font,
    this.textAlign,
    this.height,
    this.validator,
    this.readOnly,
    this.isCursorEnable,
    this.maxLength,
    this.onChanged,
    this.textBorderColor,
    this.textFieldLight,
    this.textFieldDark,
    this.contentPadding,
    this.textColorHint,
    this.fillColor,
    this.enableBorderColor,
    this.minLines,
    this.fontSize,
    this.maxLines,
    this.border,
    this.disabledBorder,
    this.underLineborder,
    this.labelText,
    this.counter,
    this.inputFormatters,
    this.radius,
    this.radiousFouse,
    this.labelTextColor = const Color(0xFF282C35),
    this.labelFontSize = 16,
    this.labelFontWeight = FontWeight.w600,
    this.autoFocus,
    this.enabled,
    this.textStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      textAlignVertical: TextAlignVertical.center,
      autofocus: autoFocus ?? false,
      focusNode: focusNode,
      keyboardType: keyBoardType,
      readOnly: readOnly ?? false,
      textAlign: textAlign ?? TextAlign.start,
      enabled: enabled ?? true,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      autovalidateMode: autoValidateMode,
      validator: validator,
      textInputAction: textInputAction,
      onTap: onTap,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      obscuringCharacter: obscuringCharacter ?? '•',
      controller: textController,
      onFieldSubmitted: onSubmmited,
      inputFormatters: inputFormatters ?? [],
      cursorColor: AppColors.primary,
      style: textStyle != null
          ? textStyle!.copyWith(
              color: textColor ?? Colors.black,
              height: height ?? 1.5,
              decoration: textDecoration ?? TextDecoration.none,
              decorationStyle: textDecorationStyle ?? TextDecorationStyle.solid,
              decorationColor: textDecorationColor ?? Colors.transparent,
            )
          : TextStyle(
              color: textColor ?? AppColors.gray800,
              fontFamily: font ?? StringConstants.AppFont,
              fontSize: fontSize ?? 14,
              fontWeight: fontWeight ?? FontWeight.w400,
              letterSpacing: 0.02,
              height: height ?? 1.5,
              decoration: textDecoration ?? TextDecoration.none,
              decorationStyle: textDecorationStyle ?? TextDecorationStyle.solid,
              decorationColor: textDecorationColor ?? Colors.transparent,
            ),
      decoration: InputDecoration(
        isCollapsed: isCollapsed ?? false,
        errorStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.systemRed,
        ),
        enabledBorder: underLineborder ??
            border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.gray200),
              borderRadius: BorderRadius.circular(radius ?? 12),
            ),
        disabledBorder: disabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(radius ?? 12),
            ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.systemRed),
          borderRadius: BorderRadius.circular(radius ?? 12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.systemRed),
          borderRadius: BorderRadius.circular(radius ?? 12),
        ),
        focusedBorder: readOnly ?? false
            ? OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(radius ?? 12),
              )
            : underLineborder ??
                border ??
                OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(radius ?? 8),
                ),
        border: underLineborder ??
            border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.gray200),
              borderRadius: BorderRadius.circular(radius ?? 12),
            ),
        fillColor: fillColor != null
            ? fillColor
            : readOnly ?? false
                ? AppColors.gray100
                : Colors.white,
        filled: true,
        hintText: hintText,
        suffix: suffix,
        errorText: errorText,
        hintStyle: TextStyle(
          fontFamily: font ?? StringConstants.AppFont,
          color: textColorHint ?? AppColors.gray400,
          fontSize: fontSize ?? 14,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.02,
          height: height ?? 1.5,
          decoration: textDecoration ?? TextDecoration.none,
          decorationStyle: textDecorationStyle ?? TextDecorationStyle.solid,
          decorationColor: textDecorationColor ?? Colors.transparent,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: '',
        suffixIconConstraints: BoxConstraints(maxHeight: double.maxFinite),
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
}
