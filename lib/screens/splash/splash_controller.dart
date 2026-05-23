import 'package:flutter/scheduler.dart';
import 'package:flutter_app_test/data/services/auth/auth_service.dart';
import 'package:flutter_app_test/screens/tab/tab_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      checkLoginStatus();
    });
  }

  ///
  /// 로그인 여부 체크
  ///
  Future<void> checkLoginStatus() async {
    // 토큰 존재 여부 체크
    final isSignIn = await _authService.isSignIn();

    // 로그인 했을 경우 -> 메이트 모임 초기화 및 탭 화면 진입
    if (true) {
      try {
        // await MateManager.instance.initialize();
      } catch (e) {
        // log('메이트 모임 초기화 실패: $e');
      }
      Get.offAll(() => TabScreen());
    } else {
      // Get.offAll(() => SignInScreen());
    }
  }
}
