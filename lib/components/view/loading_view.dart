

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../AppText.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          AppText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF898989),
          ),
        ],
      ),
    );
  }
}