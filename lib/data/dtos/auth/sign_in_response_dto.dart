
import '../../dio/error/error_exception_type.dart';
import 'token_response_dto.dart';

class SignInResponseDTO {
  final UserAuthStatus status;
  final TokenResponseDTO? accessToken;
  final TokenResponseDTO? refreshToken;

  SignInResponseDTO({
    required this.status,
    required this.accessToken,
    required this.refreshToken,
  });

  factory SignInResponseDTO.fromJson(Map<String, dynamic> json) {
    final result = json['result'];

    final status = switch (result['role'] as String) {
      'SOCIAL_CONNECTED' => UserAuthStatus.signUpRequired,
      'NORMAL' => UserAuthStatus.registered,
      'TRAINER' => UserAuthStatus.trainer,
      'LEAVE' => UserAuthStatus.leave,
      'BANNED' => UserAuthStatus.banned,
      _ => throw ServerException('유효하지 않은 유저 상태입니다.'),
    };

    return SignInResponseDTO(
      status: status,
      accessToken: result['accessToken'] != null
          ? TokenResponseDTO.fromJson(result['accessToken'])
          : null,
      refreshToken: result['refreshToken'] != null
          ? TokenResponseDTO.fromJson(result['refreshToken'])
          : null,
    );
  }
}

///
/// 유저 상태
///
enum UserAuthStatus {
  signUpRequired, // 회원가입 필요
  registered, // 회원가입을 한 유저
  trainer, // 운동지도자 인증 완료
  leave, // 회원 탈퇴
  banned, // 회원 강퇴
}