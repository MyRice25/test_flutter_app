
// import 'package:flutter/material.dart' hide TabController;
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:get/get.dart';
// import 'package:trillow/common/hooks/use_auto_hide_bar.dart';

// /// 상단 Bar와 탭바를 스크롤 방향에 따라 hide/show 하는 공용 Hook 로직
// AutoHideBarController useAutoHideBars({
//   Duration duration = const Duration(milliseconds: 300),
//   double hideOffset = 30, // 앱바 숨기기 위한 최소 스크롤 위치
// }) {
//   // 애니메이션 컨트롤러 설정
//   final animationController = useAnimationController(
//     duration: duration,
//     initialValue: 1.0, // 처음에는 보이게
//   );

//   // 애니메이션 설정
//   final offset = useMemoized(
//     () => Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero).animate(
//       CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
//     ),
//     [animationController],
//   );

//   // 탭바 컨트롤러 (탭 바 숨기기)
//   final tabController = Get.find<TabController>();
//   final communityController = Get.put(CommunityController());
//   final isTabBarVisible = useRef(false);

//   // 앱바 숨기기 여부
//   final isBarVisible = useRef(true);

//   bool handleScroll(ScrollNotification notification) {
//     // 수직 스크롤 이벤트만 처리. 가로 스크롤은 무시.
//     if (notification.metrics.axis != Axis.vertical) return false;

//     if (notification is ScrollUpdateNotification) {
//       // 현재 스크롤 위치
//       final currentOffset = notification.metrics.pixels;

//       // 이번 이벤트에서의 스크롤 변화량 (양수: 아래로 스크롤, 음수: 위로 스크롤)
//       final delta = notification.scrollDelta ?? 0;

//       // 스크롤 위치가 hideOffset 이하일 경우, 앱바 보이게 (최상단)
//       if (currentOffset < hideOffset) {
//         // 앱바가 숨겨져 있고, 애니메이션이 진행중이 아니면 앱바 보이기
//         if (!isBarVisible.value && !animationController.isAnimating) {
//           animationController.forward();
//           isBarVisible.value = true;
//         }

//         // 탭바 숨기기
//         if (isTabBarVisible.value) {
//           isTabBarVisible.value = false;
//           tabController.updateBottomBarVisibility(true);
//           communityController.isVisibleDial.value = true;
//         }

//         return false;
//       }

//       // 아래로 스크롤 할 경우 -> 숨기기
//       if (isBarVisible.value && delta > 5 && !animationController.isAnimating) {
//         animationController.reverse();
//         isBarVisible.value = false;

//         // 탭바 숨기기
//         isTabBarVisible.value = true;
//         tabController.updateBottomBarVisibility(false);
//         communityController.isVisibleDial.value = false;

//         // 위로 스크롤 할 경우 -> 보이기
//       } else if (!isBarVisible.value &&
//           delta < -5 &&
//           !animationController.isAnimating) {
//         animationController.forward();
//         isBarVisible.value = true;

//         isTabBarVisible.value = false;
//         tabController.updateBottomBarVisibility(true);
//         communityController.isVisibleDial.value = true;
//       }
//     }

//     return false;
//   }

//   return AutoHideBarController(
//     offsetAnimation: offset,
//     onNotification: handleScroll,
//     animationController: animationController,
//   );
// }
