import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'AppText.dart';

class AppRadioBtn<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  double? borderWidth;

  Color? selectedColor;
  Color? unSelectedColor;
  Color? circleColor;

  AppRadioBtn(
      {super.key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      this.selectedColor,
      this.unSelectedColor,
      this.borderWidth});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(value),
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? selectedColor : unSelectedColor,
                border: Border.all(
                  color: isSelected
                      ? selectedColor ?? AppColors.appColor
                      : AppColors.stroke,
                  width: isSelected ? 6 : 1,
                )),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? circleColor : unSelectedColor,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          AppText(text: value.toString()),
        ],
      ),
    );
  }
}
