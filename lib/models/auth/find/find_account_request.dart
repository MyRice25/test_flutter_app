/// 계정 혹은 비밀번호 찾기 요청
class FindAccountRequest {
  final String phoneNumber;
  final String verificationCode;

  const FindAccountRequest({
    required this.phoneNumber,
    required this.verificationCode,
  });

  static FindAccountRequest get initialState => const FindAccountRequest(
        phoneNumber: '',
        verificationCode: '',
      );

  FindAccountRequest copyWith({
    String? phoneNumber,
    String? verificationCode,
  }) =>
      FindAccountRequest(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        verificationCode: verificationCode ?? this.verificationCode,
      );
}
