import 'package:flutter/material.dart';
import '../AppText.dart';

/// 아이콘과 텍스트가 로우로 배치된 버튼
class IconTextRowButton extends StatelessWidget {
  const IconTextRowButton({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTapped,
  });

  final String iconPath;
  final String title;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 28,
            height: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              text: title,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
