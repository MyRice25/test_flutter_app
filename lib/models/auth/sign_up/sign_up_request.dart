/// 회원가입 요청
class SignUpRequest {
  final String name;
  final String birthDate; // 생년월일
  final String phoneNumber;
  final String verificationCode;

  final String email;
  final String password;
  final String passwordConfirm;

  const SignUpRequest({
    required this.name,
    required this.birthDate,
    required this.phoneNumber,
    required this.verificationCode,
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });

  static SignUpRequest get initialState => const SignUpRequest(
        name: '',
        birthDate: '',
        phoneNumber: '',
        verificationCode: '',
        email: '',
        password: '',
        passwordConfirm: '',
      );

  SignUpRequest copyWith({
    String? name,
    String? birthDate,
    String? phoneNumber,
    String? verificationCode,
    String? email,
    String? password,
    String? passwordConfirm,
  }) =>
      SignUpRequest(
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        verificationCode: verificationCode ?? this.verificationCode,
        email: email ?? this.email,
        password: password ?? this.password,
        passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      );
}
