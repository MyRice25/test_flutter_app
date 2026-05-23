/// 달력 시작 요일
enum StartingDayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class Day {
  final DateTime date;
  final DayCellState state;

  const Day({required this.date, required this.state});

  @override
  String toString() {
    return 'Day(day: ${date.day})';
  }

  static Day today = Day(
    date: DateTime.now(),
    state: DayCellState.today,
  );
}

enum DayCellState { basic, sunday, saturday, today }
