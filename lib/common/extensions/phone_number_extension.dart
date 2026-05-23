

extension PhoneNumberExtension on String {
  /// 휴대폰 번호에 하이픈을 추가
  /// 예: "01012345678" -> "010-1234-5678"
  String get formattedPhoneNumber {
    if (length != 11) return this;

    return '${substring(0, 3)}-${substring(3, 7)}-${substring(7, 11)}';
  }
}
