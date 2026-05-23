class SignInRequest {
  final String email;
  final String password;

  const SignInRequest({
    required this.email,
    required this.password,
  });

  static SignInRequest get initialState => const SignInRequest(
        email: '',
        password: '',
      );

  SignInRequest copyWith({
    String? email,
    String? password,
  }) {
    return SignInRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
