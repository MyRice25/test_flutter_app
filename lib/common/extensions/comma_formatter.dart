import 'package:intl/intl.dart';


extension CommaPointStringFormatter on String {
  /// 포인트 콤마 형식
  String get withComma {
    try {
      final int pointValue = int.parse(this);
      final NumberFormat formatter = NumberFormat('#,###');
      return formatter.format(pointValue);
    } catch (e) {
      return this;
    }
  }
}

extension CommaPointIntFormatter on int {
  /// 포인트 콤마 형식
  String get withComma {
    try {
      final NumberFormat formatter = NumberFormat('#,###');
      return formatter.format(this);
    } catch (e) {
      return toString();
    }
  }
}