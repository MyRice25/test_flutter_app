import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/base/base_screen.dart';
import 'splash_controller.dart';

class SplashScreen extends BaseScreen<SplashController> {
  const SplashScreen({super.key});

  @override
  void onInit(BuildContext context) {
    super.onInit(context);
    Get.put(SplashController());
  }

  @override
  void onDispose(BuildContext context) {
    Get.delete<SplashController>();
    super.onDispose(context);
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container();
  }
}
