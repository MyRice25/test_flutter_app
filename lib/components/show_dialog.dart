import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get/get_core/src/get_main.dart';
import '../constants/app_colors.dart';
import '../constants/image_paths.dart';
import '../constants/utils.dart';
import 'AppButton.dart';
import 'AppText.dart';
import 'appTextField.dart';

Future showCustomDialog(
  context, {
  required String title,
  required String bodyText,
  required Color rightButtonColor,
  required String rightButtonText,
  String? image,
  String? leftButtonText,
  GestureTapCallback? onTapCancel,
  Color? backgroundColor,
  required GestureTapCallback onTapRight,
  bool barrierDismissible = true,
}) {
  double size = Get.width - 80;
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => WillPopScope(
      onWillPop: () {
        if (barrierDismissible) Navigator.pop(context);
        return Future.value(false);
      },
      child: AlertDialog(
        surfaceTintColor: backgroundColor ?? Colors.white,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: size,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  if (title.isNotEmpty)
                    AppText(
                      text: title,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      maxLine: 2,
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (bodyText.isNotEmpty)
                    AppText(
                      text: bodyText,
                      textAlign: TextAlign.center,
                      color: AppColors.color9d,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  SizedBox(
                    height: 12,
                  ),
                  if (image != null)
                    Image.asset(
                      image,
                      width: 120,
                      height: 120,
                    ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      if (leftButtonText != null)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);

                              if (onTapCancel != null) {
                                onTapCancel();
                              }
                            },
                            child: Container(
                              height: 50.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.appGrayBG,
                                  borderRadius: BorderRadius.circular(10)),
                              child: AppText(
                                text: leftButtonText!,
                                textAlign: TextAlign.center,
                                color: AppColors.appGrayBtn,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                maxLine: 1,
                              ),
                            ),
                          ),
                        ),
                      if (leftButtonText != null)
                        SizedBox(
                          width: 12,
                        ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(false);
                            onTapRight();
                          },
                          child: Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: rightButtonColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: AppText(
                              text: rightButtonText,
                              textAlign: TextAlign.center,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              maxLine: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    ),
  );
}

Future showCustomTextFieldDialog(
  context, {
  required String title,
  required String bodyText,
  required Color rightButtonColor,
  required String rightButtonText,
  String? leftButtonText,
  GestureTapCallback? onTapCancel,
  required Function(String) onTapRight,
  bool barrierDismissible = true,
}) {
  double size = Get.width - 80;
  TextEditingController controller = TextEditingController();
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => WillPopScope(
      onWillPop: () {
        if (barrierDismissible) Navigator.pop(context);
        return Future.value(false);
      },
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: size,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  if (title.isNotEmpty)
                    AppText(
                      text: title,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      maxLine: 1,
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (bodyText.isNotEmpty)
                    AppText(
                      text: bodyText,
                      textAlign: TextAlign.center,
                      color: AppColors.appGrayBtn,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  SizedBox(
                    height: 24,
                  ),
                  AppTextField(
                    textController: controller,
                    obscureText: true,
                    hintText: "비밀번호를 입력해 주세요",
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      if (leftButtonText != null)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);

                              if (onTapCancel != null) {
                                onTapCancel();
                              }
                            },
                            child: Container(
                              height: 50.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.appGrayBG,
                                  borderRadius: BorderRadius.circular(10)),
                              child: AppText(
                                text: leftButtonText!,
                                textAlign: TextAlign.center,
                                color: AppColors.appGrayBtn,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                maxLine: 1,
                              ),
                            ),
                          ),
                        ),
                      if (leftButtonText != null)
                        SizedBox(
                          width: 12,
                        ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (controller.text.isEmpty) {
                              return;
                            }
                            Navigator.of(context).pop(false);
                            onTapRight(controller.text);
                          },
                          child: Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: rightButtonColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: AppText(
                              text: rightButtonText,
                              textAlign: TextAlign.center,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              maxLine: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    ),
  );
}
