import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app_test/components/images/trillow_box.dart';

import '../../common/extensions/image_extension.dart';
import '../../constants/image_paths.dart' as ImagePaths;

enum ImageType { profile, other }

class CachedImage extends StatelessWidget {
  final String imageURL;
  final double width;
  final double height;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final BoxFit fit;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final double borderRadius;
  final BorderRadius? borderRadiusGeometry;
  final ImageType imageType;

  const CachedImage({
    super.key,
    required this.imageURL,
    required this.width,
    required this.height,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholderWidget,
    this.borderRadius = 4,
    this.borderRadiusGeometry,
    this.imageType = ImageType.other,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadiusGeometry ?? BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageURL,
        width: width,
        height: height,
        memCacheWidth: memCacheWidth ?? width.cacheSize(context),
        memCacheHeight: memCacheHeight ?? height.cacheSize(context),
        fit: fit,
        placeholder: (context, url) {
          if (placeholderWidget == null) {
            return _buildPlaceholderWidget(context);
          }

          return placeholderWidget!;
        },
        errorWidget: (context, url, error) {
          debugPrint('이미지 로드 오류: $error');
          return errorWidget ?? _buildErrorWidget(context);
        },
      ),
    );
  }

  ///
  /// 이미지 타입에 따른 플레이스홀더 위젯
  ///
  Widget _buildPlaceholderWidget(BuildContext context) {
    switch (imageType) {
      case ImageType.profile:
        return Image.asset(
          ImagePaths.defaultProfile,
          width: width,
          height: height,
        );
      case ImageType.other:
        return SkeletonBox(
          width: width,
          height: height,
          borderRadius: borderRadius,
        );
    }
  }

  ///
  /// 이미지 타입에 따른 오류 위젯
  ///
  Widget _buildErrorWidget(BuildContext context) {
    switch (imageType) {
      case ImageType.profile:
        return Image.asset(
          ImagePaths.defaultProfile,
          width: width,
          height: height,
        );
      case ImageType.other:
        return SkeletonBox(
          width: width,
          height: height,
          borderRadius: borderRadius,
        );
    }
  }
}
