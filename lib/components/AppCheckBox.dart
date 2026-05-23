import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/ImageUtils.dart';
import '../constants/app_colors.dart';
import '../constants/image_paths.dart';
import '../constants/StringConstants.dart';
import 'AppText.dart';

class AppCheckBox extends StatefulWidget {
  AppCheckBox(
      {Key? key,
      required this.isChecked,
      required this.name,
      this.onTapCheck,
      this.image,
      this.textStyle,
      this.onTapText,
      this.checkedBox,
      this.unCheckedBox})
      : super(key: key);
  String name;
  bool isChecked;
  Function(bool)? onTapCheck;
  TextStyle? textStyle;
  Function()? onTapText;
  String? checkedBox;
  String? image;
  String? unCheckedBox;

  @override
  State<AppCheckBox> createState() => _AppCheckBox();
}

class _AppCheckBox extends State<AppCheckBox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(covariant AppCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          if (widget.onTapCheck != null) {
            widget.onTapCheck!(isChecked);
          }
        });
      },
      child: Container(
        height: widget.image != null ? 40 : 30,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            Image.asset(
              isChecked
                  ? widget.checkedBox ?? iconPath + "ic_checked.png"
                  : widget.unCheckedBox ?? iconPath + "ic_unchecked.png",
              width: 24,
            ),
            SizedBox(
              width: 10,
            ),
            if (widget.image != null)
              Row(
                children: [
                  ImageUtils.ProfileImage(widget.image!, 40, 40),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            GestureDetector(
              onTap: () {
                if (widget.onTapText != null) {
                  widget.onTapText!();
                } else {
                  setState(() {
                    isChecked = !isChecked;
                    if (widget.onTapCheck != null) {
                      widget.onTapCheck!(isChecked);
                    }
                  });
                }
              },
              child: AppText(
                text: widget.name,
                fontSize: widget.textStyle?.fontSize ?? 16,
                fontFamily:
                    widget.textStyle?.fontFamily ?? StringConstants.AppFont,
                fontWeight: widget.textStyle?.fontWeight ?? FontWeight.w400,
                color: widget.textStyle?.color ?? AppColors.appBlack,
                textDecoration:
                    widget.onTapText != null ? TextDecoration.underline : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
