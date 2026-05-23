import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../dio/dio_service.dart';
import 'deep_link_type.dart';

class ShareService {
  /// 링크 공유
  static Future<void> shareLink({
    required BuildContext context,
    required int id,
    required DeepLinkType type,
    required String title,
  }) async {
    // 1. URL 생성
    final String baseURL = "${BaseURLs.deepLink}/codeShare";
    final Uri targetURI = Uri.parse(baseURL).replace(
      queryParameters: {
        'type': type.name,
        'id': id.toString(),
      },
    );

    // 2. 공유 메시지 구성
    final String message = "[$title]\n${targetURI.toString()}\n지금 우리 앱에서 확인해보세요!";

    // 3. iPad 대응을 위한 위치 계산
    final box = context.findRenderObject() as RenderBox?;
    final Rect? sharePositionOrigin =
        box != null ? box.localToGlobal(Offset.zero) & box.size : null;

    // 4. 공유 실행
    await SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: title,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}
