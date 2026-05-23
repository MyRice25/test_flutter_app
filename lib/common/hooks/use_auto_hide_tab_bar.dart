// import 'package:flutter/material.dart' hide TabController;
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:get/get.dart';


// /// 탭바 자동 숨김 컨트롤러
// class AutoHideTabBarController {
//   final bool Function(ScrollNotification) onNotification;

//   const AutoHideTabBarController({required this.onNotification});
// }

// /// 탭바 자동 숨김 훅
// AutoHideTabBarController useBottomBarVisibility({
//   double hideOffset = 30,
//   double hideDelta = 10,
// }) {
//   final tabController = Get.find<TabController>();
//   final isHidden = useRef(false);

//   bool handleNotification(ScrollNotification notification) {
//     // 수직 스크롤 이벤트만 처리. 가로 스크롤은 무시.
//     if (notification.metrics.axis != Axis.vertical) {
//       return false;
//     }

//     // 스크롤 업데이트 이벤트 발생 시,
//     if (notification is ScrollUpdateNotification) {
//       final currentOffset = notification.metrics.pixels;

//       // 스크롤 위치가 hideOffset 이하일 경우, 탭바 보이게 (최상단)
//       if (currentOffset <= hideOffset) {
//         isHidden.value = false;
//         tabController.updateBottomBarVisibility(true);
//         return false;
//       }

//       // 이번 이벤트에서의 스크롤 변화량 (양수: 아래로 스크롤, 음수: 위로 스크롤)
//       final delta = notification.scrollDelta ?? 0;

//       // 아래로 스크롤 할 경우 -> 탭바 숨기기
//       if (!isHidden.value && delta > hideDelta) {
//         isHidden.value = true;
//         tabController.updateBottomBarVisibility(false);

//         // 위로 스크롤 할 경우 -> 탭바 보이기
//       } else if (isHidden.value && delta < -hideDelta) {
//         isHidden.value = false;
//         tabController.updateBottomBarVisibility(true);
//       }
//     }

//     return false;
//   }

//   return AutoHideTabBarController(onNotification: handleNotification);
// }
