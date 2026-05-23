extension PasswordExtension on String {
  /// 영문과 숫자를 포함한 8자 이상 여부
  bool get isPasswordValid {
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegex.hasMatch(this);
  }
}
