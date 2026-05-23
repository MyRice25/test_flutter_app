import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/image_paths.dart';
import '../AppText.dart';

class AppSelectionBottomSheet<T> extends StatelessWidget {
  const AppSelectionBottomSheet({
    super.key,
    required this.title,
    required this.menuList,
    required this.labelBuilder,
    required this.isSelectedBuilder,
    required this.onMenuTapped,
    this.isShowPinText = '현재 선택 중',
    this.isShowPin = true,
    this.showFireIcon = true,
  });

  /// 제목
  final String title;

  /// 메뉴 리스트
  final List<T> menuList;

  /// 라벨 빌더
  final String Function(T) labelBuilder;

  /// 선택 여부 빌더
  final bool Function(T) isSelectedBuilder;

  /// 메뉴 탭 콜백
  final Function(T) onMenuTapped;

  /// 선택 인디케이터 텍스트
  final String isShowPinText;

  /// 선택 인디케이터 표시 여부
  final bool isShowPin;

  /// 아이콘 표시 여부
  final bool showFireIcon;

  /// 바텀 시트 표시
  static void show<T>(
    BuildContext context, {
    required String title,
    required List<T> menuList,
    required String Function(T) labelBuilder,
    required bool Function(T) isSelectedBuilder,
    required Function(T) onMenuTapped,
    String isShowPinText = '현재 선택 중',
    bool isShowPin = true,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return AppSelectionBottomSheet(
          title: title,
          menuList: menuList,
          labelBuilder: labelBuilder,
          isSelectedBuilder: isSelectedBuilder,
          onMenuTapped: onMenuTapped,
          isShowPinText: isShowPinText,
          isShowPin: isShowPin,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.close, size: 24, color: AppColors.gray400),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Menu list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                // 메뉴
                final menu = menuList[index];

                // 선택 여부
                final isSelected = isSelectedBuilder(menu);

                // 메뉴 아이템
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.back();
                    onMenuTapped(menu);
                  },
                  child: _buildMenuItem(menu, isSelected),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 24),
            ),
          ),
        ],
      ),
    );
  }

  /// 메뉴 아이템
  Widget _buildMenuItem(T menu, bool isSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label
        AppText(
          text: labelBuilder(menu),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isSelected ? AppColors.primary : AppColors.black,
        ),

        if (isSelected && isShowPin) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: isShowPinText,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
              const SizedBox(width: 5),
              Image.asset(
                ImagePaths.pin,
                width: 25,
                height: 25,
              ),
            ],
          ),
        ]
      ],
    );
  }
}
