import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../AppText.dart';
import '../badges/app_badge.dart';
import 'deleteable_image_item.dart';

/// 현재 이미지 편집 리스트에서 보여줄 이미지 타입이 파일인지 URL인지 구분
enum ImageEditType {
  file,
  url,
}

/// 추가한 이미지 리스트와 삭제 버튼을 제공하는 뷰
class ImageEditView extends StatelessWidget {
  const ImageEditView({
    super.key,
    required this.title,
    required this.onPickerBtnTapped,
    required this.onDeleteBtnTapped,
    required this.editType,
    this.pickerButtonColor = const Color(0xFFE8F7F2),
    this.pickerButtonTextColor = const Color(0xFF17B179),
    this.imageFileList = const [],
    this.imageUrlList = const [],
  });

  final String title;
  final Color pickerButtonColor;
  final Color pickerButtonTextColor;
  final ImageEditType editType;
  final VoidCallback onPickerBtnTapped;
  final Function(int index) onDeleteBtnTapped;
  final List<File> imageFileList;
  final List<String> imageUrlList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: title,
              fontSize: 18,
            ),
            GestureDetector(
              onTap: onPickerBtnTapped,
              child: AppBadge(
                text: '사진 선택',
                backgroundColor: pickerButtonColor,
                textColor: pickerButtonTextColor,
                borderRadius: 8,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 100,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: editType == ImageEditType.file
                ? imageFileList.length
                : imageUrlList.length,
            itemBuilder: (context, index) {
              // 이미지 타입에 따라 이미지 파일 또는 이미지 URL을 사용
              switch (editType) {
                case ImageEditType.file:
                  if (imageFileList.length <= index) {
                    return const SizedBox.shrink();
                  }

                  final File imageFile = imageFileList[index];

                  return DeleteableImageItem(
                    image: imageFile,
                    onDeleteTapped: () => onDeleteBtnTapped(index),
                  );
                case ImageEditType.url:
                  if (imageUrlList.length <= index) {
                    return const SizedBox.shrink();
                  }

                  final String imageUrl = imageUrlList[index];

                  return DeleteableImageItem(
                    imageURL: imageUrl,
                    onDeleteTapped: () => onDeleteBtnTapped(index),
                  );
              }
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }
}
