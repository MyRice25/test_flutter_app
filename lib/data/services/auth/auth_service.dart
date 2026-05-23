import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


import '../../../models/auth/sign_up/sign_up_information.dart';
import '../../dio/dio_service.dart';
import '../../dio/error/error_exception_type.dart';
import '../../dtos/auth/sign_in_response_dto.dart';
import '../../dtos/auth/sign_up_response_dto.dart';
import '../secure_storage/secure_storage_service.dart';

class AuthService {
  final DioService _dioService = DioService();
  final SecureStorageService _storage = SecureStorageService();

  ///
  /// 구글 로그인 진행
  ///
  Future<SignInResponseDTO> signInWithGoogle() async {
    // 1. 구글 인스턴스 생성
    final GoogleSignIn googleInstance = GoogleSignIn(
      scopes: ['email', 'profile'],
    );

    // 2. 구글 로그인 진행
    final GoogleSignInAccount? googleUser = await googleInstance.signIn();

    // 만약 사용자가 구글 로그인을 취소했을 경우 (구글 로그인 실패)
    if (googleUser == null) {
      throw ServerException('구글 로그인 취소');
    }

    // 3. 인증 정보 가져오기
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // 4. 인증 정보 확인
    if (googleAuth.accessToken == null) {
      throw ServerException('토큰 발급 실패');
    }

    // 5. 로그인 요청
    final response = await _dioService.post(
      path: 'user/social/login',
      data: {
        'token': googleAuth.accessToken!,
        'provider': 'GOOGLE',
        'os': Platform.isAndroid ? "GOOGLE" : "APPLE",
      },
    );

    // 5. 로그인 응답 처리
    final responseDTO = SignInResponseDTO.fromJson(response);
    return responseDTO;
  }

  ///
  /// 애플 로그인
  ///
  Future<SignInResponseDTO> signInWithApple() async {
    // 1. 애플 로그인 진행
    final AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);

    // 2. SNS 로그인 요청
    final response = await _dioService.post(
      path: 'user/social/login',
      data: {
        'token': credential.authorizationCode,
        'provider': 'APPLE',
        'os': Platform.isAndroid ? "GOOGLE" : "APPLE",
      },
    );

    // 3. 로그인 응답 처리
    final responseDTO = SignInResponseDTO.fromJson(response);

    // 토큰이 있으면 저장
    if (responseDTO.accessToken != null && responseDTO.refreshToken != null) {
      await saveToken(
        accessToken: responseDTO.accessToken!.value,
        refreshToken: responseDTO.refreshToken!.value,
      );
    }

    return responseDTO;
  }

  ///
  /// 카카오 로그인 진행
  ///
  Future<SignInResponseDTO> signInWithKakao() async {
    try {
      var token = await kakaoLogin();

      // 5. 로그인 요청
      final response = await _dioService.post(
        path: 'user/social/login',
        data: {
          'token': token.accessToken,
          'provider': 'KAKAO',
          'os': Platform.isAndroid ? "GOOGLE" : "APPLE",
        },
      );

      // 5. 로그인 응답 처리
      final responseDTO = SignInResponseDTO.fromJson(response);
      return responseDTO;
    } catch (e) {
      throw ServerException('카카오 로그인 실패');
    }
  }

  Future<OAuthToken> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        return await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        //
        // https://devtalk.kakao.com/t/flutter-ios/121119
        await Future.delayed(const Duration(seconds: 1));
        return await UserApi.instance.loginWithKakaoAccount();
      }
    } else {
      return await UserApi.instance.loginWithKakaoAccount();
    }
  }

  ///
  /// 토큰 저장
  ///
  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.save(
        SecureStorageKey.accessToken,
        accessToken,
      ),
      _storage.save(
        SecureStorageKey.refreshToken,
        refreshToken,
      ),
    ]);
  }

  ///
  /// 액세스 토큰 저장
  ///
  Future<void> saveAccessToken({
    required String accessToken,
  }) async {
    await _storage.save(
      SecureStorageKey.accessToken,
      accessToken,
    );
  }

  ///
  /// 회원가입
  ///
  Future<void> signUp({
    required SignUpInformation information,
  }) async {
    final response = await _dioService.patch(
      path: 'user/sign-up',
      data: information.toJson(),
      tokenType: TokenType.access,
    );
    final responseDTO = SignUpResponseDTO.fromJson(response);

    // 토큰 저장
    await saveToken(
      accessToken: responseDTO.accessToken.value,
      refreshToken: responseDTO.refreshToken.value,
    );
  }

  ///
  /// 로그인 여부 확인
  ///
  Future<bool> isSignIn() async {
    var accessToken = await _storage.get(SecureStorageKey.accessToken);
    return accessToken != null && accessToken.isNotEmpty;
  }

  ///
  /// 토큰 삭제 (로그아웃)
  ///
  Future<void> deleteToken() async {
    await Future.wait([
      _storage.delete(SecureStorageKey.accessToken),
      _storage.delete(SecureStorageKey.refreshToken),
    ]);
  }
}
