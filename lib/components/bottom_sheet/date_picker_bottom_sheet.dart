import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../common/services/dialog/dialog_service.dart';
import '../../constants/StringConstants.dart';
import '../../constants/app_colors.dart';
import '../../constants/image_paths.dart';
import '../../models/date/date_range.dart';
import '../AppButton.dart';
import '../AppText.dart';
import '../dialog/app_dialog.dart';
import '../view/gap.dart';
// 기존 프로젝트 컴포넌트 임포트 (경로 유지)

class DatePickerBottomSheet extends StatefulWidget {
  const DatePickerBottomSheet({
    super.key,
    required this.initialDateRange,
    required this.onDateRangeSelected,
  });

  final DateRange initialDateRange;
  final Function(DateRange) onDateRangeSelected;

  /// 바텀 시트 표시
  static void show(
    BuildContext context, {
    required DateRange dateRange,
    required Function(DateRange) onDateRangeSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DatePickerBottomSheet(
        initialDateRange: dateRange,
        onDateRangeSelected: (dateRange) {
          onDateRangeSelected(dateRange);
        },
      ),
    );
  }

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  // 캘린더 상태 변수
  late DateTime _focusedDay;

  /// 선택된 기간
  DateRange _dateRange = DateRange.now;

  @override
  void initState() {
    super.initState();
    // 외부 파라미터로 초기화
    _dateRange = widget.initialDateRange;
    _focusedDay = widget.initialDateRange.start;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildCalendarView(),
            ),
            const Gap(height: 24),
            _buildSubmitButton(),
            const Gap(height: 24),
          ],
        ),
      ),
    );
  }

  // 헤더 영역
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: '기간 선택',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.close, size: 24, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  ///
  /// 캘린더
  ///
  Widget _buildCalendarView() {
    return TableCalendar(
      locale: 'ko_KR',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: StringConstants.AppFont,
        ),
        leftChevronIcon: Image.asset(
          ImagePaths.arrowLeft,
          width: 20,
          height: 20,
        ),
        rightChevronIcon: Image.asset(
          ImagePaths.arrowRight,
          width: 20,
          height: 20,
        ),
      ),
      daysOfWeekHeight: 40,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: StringConstants.AppFont,
          color: AppColors.gray400,
        ),
        weekendStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: StringConstants.AppFont,
          color: AppColors.gray400,
        ),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: StringConstants.AppFont,
        ),
        weekendTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: StringConstants.AppFont,
        ),
        // 오늘 날짜 표시 커스텀
        todayDecoration: BoxDecoration(
          color: AppColors.systemBlue,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: StringConstants.AppFont,
          color: AppColors.white,
        ),
        // 시작 날짜 범위 디자인
        rangeStartDecoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        // 종료 날짜 범위 디자인
        rangeEndDecoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        // 날짜 범위 사이 디자인
        withinRangeDecoration: BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.rectangle,
        ),
        rangeHighlightColor: AppColors.secondary,
      ),
      rangeStartDay: _dateRange.start,
      rangeEndDay: _dateRange.end,
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _dateRange = _dateRange.copyWith(start: start, end: end);
          _focusedDay = focusedDay;
        });
      },
    );
  }

  // 선택 완료 버튼
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AppButton(
        text: '선택 완료',
        margin: 0,
        height: 50,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        // 2. 선택된 기간 반환
        onTap: () {
          // 유효성 체크
          if (!_dateRange.isValid) {
            DialogService.show(
              dialog: AppDialog.singleBtn(
                title: '선택 불가',
                subTitle: '시작 날짜는 종료 날짜보다 이전이어야 합니다.',
                btnContent: '확인',
                onBtnClicked: () {
                  Get.back();
                },
              ),
            );
            return;
          }

          widget.onDateRangeSelected(_dateRange);
          Get.back();
        },
      ),
    );
  }
}
