
/// 
/// 두 자리 숫자 형식 변환
///
extension TwoDigitFormat on int {
  String get twoDigits => toString().padLeft(2, '0');
}
