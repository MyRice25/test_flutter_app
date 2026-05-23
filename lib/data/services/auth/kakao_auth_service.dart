import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/services.dart';

import '../../dio/dio_service.dart';
import '../../dtos/auth/sign_in_response_dto.dart';
import '../secure_storage/secure_storage_service.dart';

class KakaoAuthService {
  final DioService _dio = DioService();
  final UserApi _serviceInstance = UserApi.instance;
  final SecureStorageService _storage = SecureStorageService();

  // 카카오 로그인 (카카오톡 -> 카카오계정 순서로 시도)
  Future<SignInResponseDTO?> signIn() async {
    // 카카오톡 설치 여부 확인
    if (await isKakaoTalkInstalled()) {
      return await _signInWithKakaoTalk();
    } else {
      return await _signInWithKakaoAccount();
    }
  }

  // 카카오톡으로 로그인
  Future<SignInResponseDTO?> _signInWithKakaoTalk() async {
    log('카카오톡으로 로그인 시도');

    // 1. 카카오톡으로 로그인
    OAuthToken token = await _serviceInstance.loginWithKakaoTalk();
    log('카카오톡으로 로그인 성공: ${token.accessToken}');

    // 2. SNS 로그인 요청
    final response = await _dio.post(
      path: 'user/login-social',
      data: {
        'token': token.accessToken,
        'provider': 'KAKAO',
        'os': Platform.isAndroid ? 'GOOGLE' : 'APPLE',
      },
    );
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

  // 카카오계정으로 로그인
  Future<SignInResponseDTO?> _signInWithKakaoAccount() async {
    log('카카오계정으로 로그인 시도');

    OAuthToken token = await _serviceInstance.loginWithKakaoAccount();
    log('카카오계정으로 로그인 성공: ${token.accessToken}');

    // 2. SNS 로그인 요청
    final response = await _dio.post(
      path: 'user/login-social',
      data: {
        'token': token.accessToken,
        'provider': 'KAKAO',
        'os': Platform.isAndroid ? 'GOOGLE' : 'APPLE',
      },
    );
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
  /// 토큰 저장
  ///
  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    Future.wait([
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
}
