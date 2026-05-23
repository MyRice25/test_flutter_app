class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({required this.start, required this.end});

  DateRange copyWith({DateTime? start, DateTime? end}) {
    return DateRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  static DateRange now = DateRange(start: DateTime.now(), end: DateTime.now());

  @override
  String toString() => '$start ~ $end';

  /// 유효성
  bool get isValid {
    return start.isBefore(end);
  }
}
