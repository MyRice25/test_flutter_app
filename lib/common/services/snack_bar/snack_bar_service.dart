import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/AppText.dart';
import '../../../constants/app_colors.dart';

abstract class SnackBarService {
  SnackBarService._();

  static void showSnackBar(String text) {
    final context = Get.context;

    if (context != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.black,
          duration: const Duration(milliseconds: 800),
          content: Center(
            child: AppText(
              text: text,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
