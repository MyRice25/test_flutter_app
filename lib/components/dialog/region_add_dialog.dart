import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../AppButton.dart';
import '../AppText.dart';
import '../AppTextField.dart';
import '../view/gap.dart';

class RegionAddDialog extends Dialog {
  const RegionAddDialog({
    super.key,
    required this.onSubmitted,
  });

  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final controller = useTextEditingController();

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: '지역 추가',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
                const Gap(height: 16),
                AppTextField(
                  hintText: '입력',
                  textController: controller,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black,
                  textColorHint: AppColors.gray400,
                  fillColor: AppColors.white,
                  radius: 8,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                const Gap(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: '닫기',
                        height: 50,
                        margin: 0,
                        borderRadius: 8,
                        color: AppColors.gray100,
                        textColor: AppColors.gray500,
                        onTap: () => Get.back(),
                      ),
                    ),
                    const Gap(width: 10),
                    Expanded(
                      child: AppButton(
                        text: '완료',
                        height: 50,
                        margin: 0,
                        borderRadius: 8,
                        color: AppColors.black,
                        textColor: AppColors.white,
                        onTap: () {
                          onSubmitted(controller.text);
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
