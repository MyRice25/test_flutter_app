import 'package:intl/intl.dart';

const List<String> _koreanWeekdays = [
  '월요일',
  '화요일',
  '수요일',
  '목요일',
  '금요일',
  '토요일',
  '일요일',
];

extension StringDateFormat on String {
  /// 문자열을 yyyy.MM.dd 형식으로 변환
  String toYYYYMMDD() {
    final date = DateTime.parse(this);
    return DateFormat('yyyy.MM.dd').format(date);
  }

  /// 문자열을 yyyy.MM.dd HH:mm 형식으로 변환
  String toYYYYMMDDHHMM() {
    final date = DateTime.parse(this);
    return DateFormat('yyyy.MM.dd HH:mm').format(date);
  }

  /// 문자열을 원하는 포맷의 문자열로 변환합니다.
  ///
  /// [format] - 날짜 포맷 (기본값: 'yyyy년 MM월 dd일')
  ///
  String toFormat([String format = 'yyyy년 MM월 dd일']) {
    final date = DateTime.parse(this);
    return DateFormat(format).format(date);
  }

  ///
  /// 마지막 기록 날짜 포맷팅
  ///
  String toLastRecordDateFormat() {
    try {
      final date = DateTime.parse(this);
      final now = DateTime.now();
      final isToday =
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;

      final hour = date.hour;
      final period = hour < 12 ? '오전' : '오후';
      final displayHour = hour <= 12 ? hour : hour - 12;

      if (isToday) {
        return '오늘 $period $displayHour시 기록';
      } else {
        return '${date.month}월 ${date.day}일 $period $displayHour시 기록';
      }
    } catch (e) {
      return this;
    }
  }

  ///
  /// DateTime을 요일 문자열로 변환
  ///
  String toWeekdayFormat() {
    try {
      final weekday = DateTime.parse(this).weekday;
      return _koreanWeekdays[weekday - 1];
    } catch (e) {
      return '요일 오류';
    }
  }

  /// 문자열을 yyyy년 MM월 dd일 요일 형식으로 변환
  String toKoreanFullDateWithWeekday() {
    try {
      final date = DateFormat('yyyy-MM-dd').parseStrict(this);
      final formattedDate = DateFormat('yyyy년 MM월 dd일').format(date);
      final weekday = _koreanWeekdays[date.weekday - 1];
      return '$formattedDate $weekday';
    } catch (e) {
      return '날짜 형식 오류';
    }
  }

  /// 문자열을 MM/dd 요일 오전/오후 h:mm 형식으로 변환
  /// 예: 2025-10-20T14:30:00 -> 10/20 토요일 오후 2:30
  String toMonthDayKoreanWeekdayWithMeridiem() {
    try {
      final dateTime = DateTime.parse(this);
      final monthDay = DateFormat('MM/dd').format(dateTime);
      final weekday = _koreanWeekdays[dateTime.weekday - 1];

      final isPm = dateTime.hour >= 12;
      final hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final meridiem = isPm ? '오후' : '오전';

      return '$monthDay $weekday $meridiem $hour12:$minute';
    } catch (e) {
      return '날짜 형식 오류';
    }
  }
}
