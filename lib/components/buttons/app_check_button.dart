
import 'package:flutter/material.dart';

import '../../constants/image_paths.dart';
import '../AppText.dart';

///
/// 체크 버튼
///
class AppCheckButton extends StatelessWidget {
  const AppCheckButton({
    super.key,
    this.text,
    required this.isSelected,
    required this.onTapped,
    this.onArrowTapped,
  });

  final String? text;
  final bool isSelected;
  final Function(bool) onTapped;
  final VoidCallback? onArrowTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTapped(!isSelected),
      child: Row(
        children: [
          // Image.asset(
          //   isSelected ? ImagePaths.check : ImagePaths.checkOFF,
          //   width: 18,
          //   height: 18,
          // ),
          if (text != null) ...[
            const SizedBox(width: 8),
            AppText(
              text: text!,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ],
          const Spacer(),
          if (onArrowTapped != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onArrowTapped,
              child: Image.asset(
                ImagePaths.arrowRight,
                width: 12,
                height: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
