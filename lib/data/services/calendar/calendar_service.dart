import 'package:flutter/material.dart';

import '../../../models/calendar/day.dart';
import '../../../models/calendar/month.dart';

///
/// 캘린더 서비스
/// 캘린더 시작 날짜와 종료 날짜를 기반으로 Day 리스트를 반환
///
class CalendarService {
  /// 캘린더 시작 날짜 => 오늘
  final DateTime _startDate = DateTime.now();

  /// 캘린더 종료 날짜 => 2050년 12월 31일
  final DateTime _endDate = DateTime(2050, 12, 31);

  /// startDate부터 endDate까지의 전체 월 수
  int get totalMonthCount {
    final startYear = _startDate.year;
    final startMonth = _startDate.month;
    final endYear = _endDate.year;
    final endMonth = _endDate.month;

    return (endYear - startYear) * 12 + (endMonth - startMonth) + 1;
  }

  // ///
  // /// 특정 날짜에 대한 DayList 계산
  // ///
  // List<Day> getDayList(DateTime focusedDay) {
  //   // 해당 월의 날짜 범위를 기반으로 Day 리스트를 계산
  //   final range = _daysInMonth(focusedDay);
  //   final days = _calculateDays(range.start, range.end, focusedDay);
  //   return days;
  // }

  ///
  /// 캘린더 월 리스트 계산
  ///
  List<Month> getMonthList() {
    // 현재 월
    DateTime current = DateTime(_startDate.year, _startDate.month);

    // 캘린더 종료 날짜
    final DateTime end = DateTime(_endDate.year, _endDate.month + 1);

    // 캘린더 월 리스트
    final List<Month> monthList = [];

    // 캘린더 시작 날짜부터 종료 날짜까지 반복
    while (current.isBefore(end)) {
      // 현재 월에 해당하는 포커싱 날짜
      final focusedDay = DateTime(current.year, current.month);

      // 해당 월의 날짜 범위를 계산
      final range = _daysInMonth(focusedDay);

      // 범위 내의 Day 리스트를 계산
      final days = _calculateDays(range.start, range.end, focusedDay);

      // 해당 월 정보 저장
      monthList.add(Month(date: focusedDay, dayList: days));

      // 다음 월로 이동
      current = DateTime(current.year, current.month + 1);
    }

    return monthList;
  }

  ///
  /// 특정 월을 기준으로 캘린더에 표시할 날짜 범위를 계산하는 함수
  /// 해당 월의 모든 날짜 + 앞뒤 빈 공간을 채우는 이전/다음 월의 날짜들을 포함
  ///
  DateTimeRange _daysInMonth(DateTime focusedDay) {
    // 1. 해당 월의 첫 번째 날 (예: 2025년 3월 1일)
    final first = _firstDayOfMonth(focusedDay);

    // 4. 해당 월의 마지막 날 계산 (예: 3월 31일)
    final last = _lastDayOfMonth(focusedDay);

    return DateTimeRange(start: first, end: last);
  }

  ///
  /// 해당 월의 날짜 범위를 기반으로 Day 리스트를 계산하는 메서드
  ///
  List<Day> _calculateDays(DateTime first, DateTime last, DateTime focusedDay) {
    final dayCount = last.difference(first).inDays + 1;
    final now = DateTime.now();

    // 날짜 범위 내의 날짜 개수만큼 반복하며 Day 객체 생성
    return List.generate(dayCount, (index) {
      // 날짜 계산
      final day = DateTime.utc(first.year, first.month, first.day + index);

      // 날짜 상태 계산
      var state = DayCellState.basic;

      // 일요일 또는 토요일 여부 확인
      if (_isSunday(day)) {
        state = DayCellState.sunday;
      } else if (_isSaturday(day)) {
        state = DayCellState.saturday;
      }

      // 오늘 날짜 여부 확인
      final isToday =
          now.year == day.year && now.month == day.month && now.day == day.day;

      if (isToday) {
        state = DayCellState.today;
      }

      return Day(date: day, state: state);
    });
  }

  ///
  /// 월의 첫 번째 날을 계산하는 메서드
  ///
  DateTime _firstDayOfMonth(DateTime month) {
    return DateTime.utc(month.year, month.month);
  }

  ///
  /// 요일 번호 반환 (일요일: 1, 월요일: 2, 화요일: 3, 수요일: 4, 목요일: 5, 금요일: 6, 토요일: 7)
  ///
  int getWeekdayNumber(StartingDayOfWeek weekday) {
    return StartingDayOfWeek.values.indexOf(weekday) + 1;
  }

  ///
  /// 월의 마지막 날을 계산하는 메서드
  ///
  DateTime _lastDayOfMonth(DateTime month) {
    // 월이 12월이면 다음 해의 1월
    // 월이 12월이 아니면 다음 달의 1일
    final date = month.month < 12
        ? DateTime.utc(month.year, month.month + 1)
        : DateTime.utc(month.year + 1);

    // -1 해주면 마지막 날이 계산됨
    return date.subtract(const Duration(days: 1));
  }

  ///
  /// 일요일 여부 확인
  ///
  bool _isSunday(DateTime day) {
    return day.weekday == DateTime.sunday;
  }

  ///
  /// 토요일 여부 확인
  ///
  bool _isSaturday(DateTime day) {
    return day.weekday == DateTime.saturday;
  }
}
