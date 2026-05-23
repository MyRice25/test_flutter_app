
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/image_paths.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Image.asset(
        ImagePaths.close,
        width: 24,
        height: 24,
      ),
    );
  }
}
