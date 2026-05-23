import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../AppButton.dart';
import '../AppText.dart';
import '../view/gap.dart';

class TimePickerBottomSheet extends HookWidget {
  const TimePickerBottomSheet({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  final DateTime initialTime;
  final Function(DateTime) onTimeSelected;

  /// 바텀 시트 표시
  static void show(
    BuildContext context, {
    required DateTime initialTime,
    required Function(DateTime) onTimeSelected,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return TimePickerBottomSheet(
          initialTime: initialTime,
          onTimeSelected: onTimeSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 선택된 시간
    final tempSelectedTime = useState<DateTime>(initialTime);

    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildTimeSelector(tempSelectedTime),
            ),
            const Gap(height: 24),
            _buildSubmitButton(tempSelectedTime.value),
            const Gap(height: 24),
          ],
        ),
      ),
    );
  }

  // 헤더 영역
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: '시간 선택',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.close, size: 24, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  ///
  /// 시간 선택기
  ///
  Widget _buildTimeSelector(ValueNotifier<DateTime> tempTime) {
    return SizedBox(
      height: 200,
      child: CupertinoTheme(
        data: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(
              fontSize: 20,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: initialTime,
          onDateTimeChanged: (DateTime newTime) {
            tempTime.value = newTime;
          },
          use24hFormat: false,
          minuteInterval: 1,
        ),
      ),
    );
  }

  // 선택 완료 버튼
  Widget _buildSubmitButton(DateTime selectedTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AppButton(
        text: '선택 완료',
        margin: 0,
        height: 50,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        onTap: () {
          onTimeSelected(selectedTime);
          Get.back();
        },
      ),
    );
  }
}
