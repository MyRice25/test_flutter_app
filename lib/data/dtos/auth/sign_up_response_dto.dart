import 'token_response_dto.dart';


class SignUpResponseDTO {
  final TokenResponseDTO accessToken;
  final TokenResponseDTO refreshToken;
  final String name;

  SignUpResponseDTO({
    required this.accessToken,
    required this.refreshToken,
    required this.name,
  });

  factory SignUpResponseDTO.fromJson(Map<String, dynamic> json) {
    final result = json['result'];
    return SignUpResponseDTO(
      accessToken: TokenResponseDTO.fromJson(result['accessToken']),
      refreshToken: TokenResponseDTO.fromJson(result['refreshToken']),
      name: result['name'],
    );
  }
}



// UserSignUpResDto{
// accessToken*	{
// description:	
// access 토큰 정보

// value*	string
// 토큰 value

// expiredAt*	string
// 토큰 만료 날짜

// }
// refreshToken*	{
// description:	
// refresh 토큰 정보

// value*	string
// 토큰 value

// expiredAt*	string
// 토큰 만료 날짜

// }
// name*	string
// 이름

// }