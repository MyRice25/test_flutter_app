import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../constants/app_colors.dart';
import 'AppButton.dart';
import 'AppText.dart';

class DeleteBottomSheet extends StatefulWidget {
  DeleteBottomSheet({Key? key, required this.onTapDelete}) : super(key: key);
  Function() onTapDelete;

  @override
  State<DeleteBottomSheet> createState() => _DeleteBottomSheet();
}

class _DeleteBottomSheet extends State<DeleteBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24), topLeft: Radius.circular(24))),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                ),
                AppText(
                  text: "삭제할까요?",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 8,
                ),
                AppText(
                  text: "삭제하면 되돌릴 수 없어요",
                  fontSize: 16,
                  color: AppColors.color9d,
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            )),
            Row(
              children: [
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: AppButton(
                      text: "취소",
                      color: AppColors.colorf2f2f2,
                      margin: 0,
                      onTap: () {
                        Get.back();
                      }),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: AppButton(
                      text: "삭제",
                      color: Color(0xfff05858),
                      margin: 0,
                      textColor: AppColors.white,
                      onTap: () {
                        Get.back();
                        widget.onTapDelete();
                      }),
                ),
                SizedBox(
                  width: 24,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
          ],
        ));
  }
}
