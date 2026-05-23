import 'package:flutter/material.dart';
import '../../constants/image_paths.dart';
import '../AppText.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagePaths.emptyFace,
            width: 52,
            height: 52,
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
