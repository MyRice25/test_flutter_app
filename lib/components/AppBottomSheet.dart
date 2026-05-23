import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Trans;

import '../constants/app_colors.dart';
import '../models/BtnBottomModel.dart';
import 'AppText.dart';

class AppBottomSheetWidget extends StatelessWidget {
  AppBottomSheetWidget(
      {Key? key,
      required this.btnItems,
      required this.onTapItem,
      this.textColor})
      : super(key: key);
  List<BtnBottomModel> btnItems;
  Function(int) onTapItem;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + btnItems.length * 64 + 48,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), topLeft: Radius.circular(24))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 14,
          ),
          Center(
            child: Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                  color: AppColors.colorc8,
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          SizedBox(height: 20),
          Column(
              children: btnItems.map((item) {
            return GestureDetector(
              onTap: () {
                Get.back();
                onTapItem(item.index);
              },
              child: Container(
                height: 52,
                margin: EdgeInsets.only(bottom: 12, left: 14, right: 14),
                decoration: BoxDecoration(
                    color: item.bgColor,
                    border: Border.all(color: item.borderColor, width: 1),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (item.icon != null)
                              Icon(
                                item.icon,
                                size: 24,
                                color: AppColors.color76,
                              ),
                            if (item.imageString.isNotEmpty)
                              Image.asset(
                                item.imageString,
                                width: 24,
                                height: 24,
                                color: AppColors.color76,
                              ),
                            if (item.imageString.isNotEmpty ||
                                item.icon != null)
                              SizedBox(
                                width: 10,
                              ),
                            AppText(
                              text: item.name,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: item.textColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
