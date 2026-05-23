import 'package:flutter/material.dart';

import '../AppButton.dart';
import '../AppText.dart';
import '../AppTextField.dart';

/// 신고 바텀 시트
class ReportBottomSheet extends StatefulWidget {
  final Function(String reason) onReportBtnTapped;

  const ReportBottomSheet({
    super.key,
    required this.onReportBtnTapped,
  });

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  String _reason = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 600), // 최대 높이 제한
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 34,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF767676),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),
              AppText(
                text: '신고하기',
                fontSize: 20,
              ),
              const SizedBox(height: 8),
              AppText(
                text: '신고 사유를 입력해주세요',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              const SizedBox(height: 8),
              AppTextField(
                onChanged: (text) => setState(() => _reason = text),
                height: 157,
                fillColor: Colors.white,
                hintText: '신고 사유를 입력해주세요',
                maxLines: 8,
                keyBoardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: AppText(
                  text: '${_reason.length} / 50',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: '취소',
                      textColor: Colors.black,
                      color: Colors.grey[100],
                      fontWeight: FontWeight.w400,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      text: '신고',
                      textColor: Colors.white,
                      color: const Color(0xFFF05859),
                      fontWeight: FontWeight.w400,
                      onTap: () {
                        widget.onReportBtnTapped(_reason);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
