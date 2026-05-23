import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'StringConstants.dart';
import 'app_colors.dart';
import 'image_paths.dart';

// 이미지 WIDGET 유틸
class ImageUtils {
  // 프로필 이미지 위젯
  static Widget ProfileImage(String src, double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(width / 2),
      child: CachedNetworkImage(
          imageUrl: src,
          placeholder: (context, url) => SizedBox(
                child: Center(
                    child:
                        CircularProgressIndicator(color: AppColors.appColor)),
                height: 10.0,
                width: 10.0,
              ),
          errorWidget: (context, url, error) => Image.asset(
                defaultProfile,
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
          width: width,
          height: height,
          fit: BoxFit.cover),
    );
  }

  static Widget ProfileImageFile(File file, double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(width / 2),
      child: Image.file(file, width: width, height: height, fit: BoxFit.fill),
    );
  }

  // 네트워크 이미지 위젯
  static Widget setNetworkImage(
      String src, double width, double height, double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
          imageUrl: src,
          placeholder: (context, url) => SizedBox(
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.appColor,
                )),
                height: 20.0,
                width: 20.0,
              ),
          errorWidget: (context, url, error) => Container(),
          width: width,
          height: height,
          fit: BoxFit.cover),
    );
  }

  static Widget setNetworkImageFitWidth(String src, double width) {
    return CachedNetworkImage(
        imageUrl: src,
        placeholder: (context, url) => SizedBox(
              child: Center(
                  child: CircularProgressIndicator(
                color: AppColors.appColor,
              )),
              height: 10.0,
              width: 10.0,
            ),
        errorWidget: (context, url, error) => Container(),
        width: width,
        fit: BoxFit.cover);
  }

  // 에셋 이미지 위젯
  static Widget setImage(String src, double width, double height) {
    return Image.asset(src, width: width, height: height, fit: BoxFit.cover);
  }

  // 에셋 이미지 위젯
  static Widget setImageWithWidth(String src, double width) {
    return Image.asset(src, width: width, fit: BoxFit.fitHeight);
  }

  // 에셋 이미지 위젯
  static Widget setImageWithHeight(String src, double height) {
    return Image.asset(src, height: height, fit: BoxFit.cover);
  }
}
