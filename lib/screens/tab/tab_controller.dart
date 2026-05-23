import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/screens/tab/tab_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt currentIndex = 0.obs; // 현재 선택된 탭 인덱스 추가
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
  }

  /// 탭 이동
  void moveTab(TabType type) {
    currentIndex.value = type.index;
    pageController.jumpToPage(type.index);
  }
}
