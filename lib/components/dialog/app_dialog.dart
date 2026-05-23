import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../AppText.dart';

class AppDialog extends Dialog {
  const AppDialog({
    super.key,
    this.isDoubleButton = false, // 버튼을 분할 형식으로 표시할지 여부
    this.subTitle, // 부제목 텍스트
    this.onBottomBtnClicked, // 왼쪽 버튼 클릭 콜백
    this.bottomBtnText, // 왼쪽 버튼 텍스트
    this.bottomBtnColor = const Color(0xFFF5F6F8),
    this.topBtnColor = const Color(0xFF000000),
    this.image,
    this.midContent,
    required this.topBtnText, // 오른쪽 버튼 텍스트
    required this.onTopBtnClicked, // 오른쪽 버튼 클릭 콜백
    required this.title, // 제목 텍스트
  });

  /// 단일 버튼 형식의 다이얼로그 생성자
  factory AppDialog.singleBtn({
    required String title,
    required VoidCallback onBtnClicked,
    String? subTitle,
    Color? btnColor,
    String? midContent,
    required String btnContent,
    Image? image,
  }) =>
      AppDialog(
        title: title,
        subTitle: subTitle,
        onTopBtnClicked: onBtnClicked,
        topBtnText: btnContent,
        midContent: midContent,
        topBtnColor: btnColor ?? const Color(0xFF000000),
        image: image,
      );

  /// 분할 버튼 형식의 다이얼로그 생성자
  factory AppDialog.doubleBtn({
    required String title,
    String? subTitle,
    required String topBtnContent,
    required String bottomBtnContent,
    Color? bottomBtnColor,
    Color? topBtnColor,
    required VoidCallback onTopBtnClicked,
    required VoidCallback onBottomBtnClicked,
    Image? image,
  }) =>
      AppDialog(
        isDoubleButton: true,
        title: title,
        subTitle: subTitle,
        onTopBtnClicked: onTopBtnClicked,
        onBottomBtnClicked: onBottomBtnClicked,
        bottomBtnText: bottomBtnContent,
        topBtnText: topBtnContent,
        bottomBtnColor: bottomBtnColor ?? const Color(0xFFF5F6F8),
        topBtnColor: topBtnColor ?? const Color(0xFF000000),
        image: image,
      );

  final bool isDoubleButton;
  final String title;
  final VoidCallback onTopBtnClicked;
  final VoidCallback? onBottomBtnClicked;
  final String? topBtnText;
  final String? bottomBtnText;
  final String? subTitle;
  final Color bottomBtnColor;
  final Color topBtnColor;
  final Image? image;
  final String? midContent;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(minHeight: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(163, 163, 179, 0.07),
              blurRadius: 65,
              offset: Offset(0, 5),
            ),
            BoxShadow(
              color: Color.fromRGBO(163, 163, 179, 0.07),
              blurRadius: 20,
              offset: Offset(0, 5.86471),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (image != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 20),
                child: image!,
              ),
            ],

            /// Title
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppText(
                text: title,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                textAlign: TextAlign.center,
              ),
            ),

            /// Sub Title
            if (subTitle != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AppText(
                  text: subTitle!,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.gray500,
                  textAlign: TextAlign.center,
                ),
              ),

            if (midContent != null)
              Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: AppText(
                      text: midContent!,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: AppColors.gray600,
                    ),
                  )),

            // Buttons
            const SizedBox(height: 10),
            _buildButton(
              text: topBtnText!,
              onTapped: onTopBtnClicked,
              color: topBtnColor,
              textColor: const Color(0xFFFFFFFF),
            ),
            const SizedBox(height: 8),
            if (isDoubleButton) ...[
              _buildButton(
                text: bottomBtnText!,
                onTapped: onBottomBtnClicked ?? () {},
                color: bottomBtnColor,
                textColor: AppColors.gray400,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onTapped,
    required Color textColor,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTapped,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: AppText(
            text: text,
            fontSize: 18,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
