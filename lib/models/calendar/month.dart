import 'day.dart';

class Month {
  final DateTime date;
  final List<Day> dayList;

  const Month({required this.date, required this.dayList});
}