
import 'package:flutter/material.dart';

import '../AppText.dart';

/// 제네릭한 리스트를 표시하는 바텀 시트
class MenuListBottomSheet<T> extends StatelessWidget {
  const MenuListBottomSheet({
    super.key,
    required this.menuList,
    required this.labelBuilder,
    required this.onMenuTapped,
  });

  final List<T> menuList;
  final String Function(T) labelBuilder;
  final Function(T) onMenuTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 34,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF767676),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 40),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menuList.length,
            itemBuilder: (context, index) {
              final menu = menuList[index];

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  onMenuTapped.call(menu);
                },
                child: Center(
                  child: AppText(
                    text: labelBuilder(menu),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
