import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../AppText.dart';
import '../../grid/dynamic_height_grid_view.dart';

class SelectableOptionGridView<T> extends StatelessWidget {
  const SelectableOptionGridView({
    super.key,
    required this.selectedOption,
    required this.optionList,
    required this.onOptionTapped,
    required this.labelBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    this.padding,
  });

  final T selectedOption;
  final List<T> optionList;
  final String Function(T) labelBuilder;
  final Function(T) onOptionTapped;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return DynamicHeightGridView(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemCount: optionList.length,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      rowCrossAxisAlignment: rowCrossAxisAlignment,
      builder: (context, index) {
        final option = optionList[index];
        final isSelected = option == selectedOption;

        return _buildDefaultItem(
          option: option,
          isSelected: isSelected,
          onTap: () {
            onOptionTapped(option);
          },
        );
      },
    );
  }

  Widget _buildDefaultItem({
    required T option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: labelBuilder(option),
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? AppColors.primary : AppColors.black,
            ),
            _buildRadioIndicator(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioIndicator(bool isSelected) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.gray200,
          width: isSelected ? 5 : 1,
        ),
      ),
    );
  }
}
