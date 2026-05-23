import 'dart:developer';

import 'package:intl/intl.dart';

import 'number_padding.dart';
import 'string_dateformat.dart';

extension DateTimeExtension on DateTime {
  /// DateTime을 원하는 포맷의 문자열로 변환합니다.
  ///
  /// [format] - 날짜 포맷 (기본값: 'yyyy.MM')
  ///
  String toStringFormat([String format = 'yyyy.MM']) {
    return DateFormat(format).format(this);
  }

  /// DateTime을 년 문자열로 변환합니다.
  ///
  /// 예시: `DateTime.now().toYear()` -> "2024"
  String toYear() {
    return DateFormat('yyyy').format(this);
  }

  /// DateTime을 월 문자열로 변환합니다.
  ///
  /// 예시: `DateTime.now().toMonth()` -> "01"
  String toMonth() {
    return DateFormat('MM').format(this);
  }
}

extension StringDateExtension on String {
  ///
  /// 문자열을 다른 날짜 형식의 문자열로 변환
  ///
  String toYYYYMMDD() {
    try {
      final DateTime date = DateTime.parse(this);
      return DateFormat('yyyy.MM.dd').format(date);
    } catch (e) {
      log('날짜 형식이 잘못되었습니다. 올바른 형식: YYYY-MM-DD');
      return '';
    }
  }

  ///
  /// 오늘 날짜일 경우: "오전/오후 hh:mm" 형식으로 변환
  /// 오늘 날짜가 아닐 경우: "yyyy.MM.dd" 형식으로 변환
  ///
  String toChatTimeFormat() {
    try {
      // UTC 시간으로 파싱
      final utcDateTime = DateTime.parse('${this}Z');

      // 한국 시간으로 변환
      final koreanTime = utcDateTime.add(const Duration(hours: 9));
      final now = DateTime.now();

      // 오늘 날짜인지 확인 (년, 월, 일만 비교)
      final isToday = koreanTime.year == now.year &&
          koreanTime.month == now.month &&
          koreanTime.day == now.day;

      if (isToday) {
        // 오늘인 경우 => "오전/오후 hh:mm" 형식
        final hour = koreanTime.hour;
        final minute = koreanTime.minute;

        final period = hour < 12 ? '오전' : '오후';
        final displayHour = hour % 12 == 0 ? 12 : hour % 12;

        return '$period ${displayHour.toTwoDigit}:${minute.toTwoDigit}';
      } else {
        // 오늘 아닌 경우 => "yyyy.MM.dd" 형식
        return DateFormat('yyyy.MM.dd').format(koreanTime);
      }
    } catch (e) {
      return '시간 오류';
    }
  }

  ///
  /// 게시물 시간 포맷
  ///
  String toFeedTimeFormat() {
    try {
      // UTC 시간으로 파싱
      final utcDateTime = DateTime.parse('${this}');

      // 한국 시간으로 변환
      final DateTime koreanTime = utcDateTime.add(const Duration(hours: 9));

      // 현재 시각과의 차이 계산
      final DateTime now = DateTime.now();
      final Duration diff = now.difference(koreanTime);

      print("시간 비교");
      print(now);
      print(koreanTime);
      print(diff);

      // 0분 미만이면 "방금"
      if (diff.inMinutes <= 0) return '방금';

      print("시간 체크");

      // 1~59분
      if (diff.inMinutes < 60) return '${diff.inMinutes}분';

      // 1~23시간
      if (diff.inHours < 24) return '${diff.inHours}시간';

      // 1~6일
      if (diff.inDays < 7) return '${diff.inDays}일';

      // 1~4주 (30일 미만인 경우 주 단위로 표시)
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}주';

      // 1~11달 (365일 미만인 경우 달 단위로 표시)
      if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}달';

      // 1년 이상
      return '${(diff.inDays / 365).floor()}년';
    } catch (e) {
      // 파싱 실패
      return toYYYYMMDDHHMM();
    }
  }
}
