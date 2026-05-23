import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TabController;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app_test/constants/StringConstants.dart';
import 'package:flutter_app_test/constants/app_colors.dart';
import 'package:flutter_app_test/screens/tab/tab_controller.dart';
import 'package:flutter_app_test/screens/tab/test1/test1_screen.dart';
import 'package:flutter_app_test/screens/tab/test2/test2_screen.dart';
import 'package:flutter_app_test/screens/tab/test3/test3_screen.dart';
import 'package:flutter_app_test/screens/tab/test4/test4_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants/image_paths.dart';

enum TabType {
  home,
  travel,
  insurance,
  more;
}

class TabScreen extends StatefulWidget {  
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final TabController _controller = Get.put(TabController());

  final _pages = [
    Test1Screen(key: ValueKey(TabType.home)),
    Test2Screen(key: ValueKey(TabType.travel)),
    Test3Screen(key: ValueKey(TabType.insurance)),
    Test4Screen(key: ValueKey(TabType.more)),
  ];

  @override
  void initState() {
    super.initState();
    _controller.pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages.mapIndexed((index, page) {
          return Obx(
            () => page
                .animate(
                    target: _controller.currentIndex.value == index ? 1 : 0)
                .fade(duration: 200.ms),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTabItem(
                index: 0,
                label: '메인',
                iconOn: ImagePaths.tabHomeOn,
                iconOff: ImagePaths.tabHomeOff,
              ),
              _buildTabItem(
                index: 1,
                label: '여행 기록',
                iconOn: ImagePaths.tabTravelOn,
                iconOff: ImagePaths.tabTravelOff,
              ),
              // 작성 버튼
              GestureDetector(
                onTap: () {
                  // Get.to(() => const SelectScheduleTypeScreen());
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF28B50),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, size: 28, color: Colors.white),
                ),
              ),
              _buildTabItem(
                index: 2,
                label: '나의 보험',
                iconOn: ImagePaths.tabInsuranceOn,
                iconOff: ImagePaths.tabInsuranceOff,
              ),
              _buildTabItem(
                index: 3,
                label: '더보기',
                iconOn: ImagePaths.tabMoreOn,
                iconOff: ImagePaths.tabMoreOff,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// 탭 아이템
  ///
  Widget _buildTabItem({
    required int index,
    required String label,
    required String iconOn,
    required String iconOff,
  }) {
    return Obx(() {
      bool isSelected = _controller.currentIndex.value == index;

      return GestureDetector(
        onTap: () {
          _controller.currentIndex.value = index;
          _controller.pageController.jumpToPage(index);
        },
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isSelected ? iconOn : iconOff,
                width: 24,
                height: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: StringConstants.AppFont,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.primary : AppColors.gray400,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
