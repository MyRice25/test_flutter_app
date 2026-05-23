import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageKey {
  fcmToken(value: 'FCM_TOKEN'),
  accessToken(value: 'ACCESS_TOKEN'),
  refreshToken(value: 'REFRESH_TOKEN');

  const SecureStorageKey({required this.value});
  final String value;
}

/// 저장소 서비스
class SecureStorageService {
  static final SecureStorageService instance = SecureStorageService._internal();

  late final FlutterSecureStorage _storage;

  factory SecureStorageService() => instance;

  SecureStorageService._internal() {
    _storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  /// 안드로이드 보안 옵션
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  /// iOS 보안 옵션
  IOSOptions _getIOSOptions() => const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock, // 첫 번째 잠금 해제 시 접근 가능
      );

  /// 저장
  Future<void> save(SecureStorageKey key, String value) async {
    log('저장 $key : $value');
    await _storage.write(key: key.value, value: value);
  }

  /// 조회
  Future<String?> get(SecureStorageKey key) async {
    final result = await _storage.read(key: key.value);
    log('조회 $key : $result');
    return result;
  }

  /// 삭제
  Future<void> delete(SecureStorageKey key) async {
    log('삭제 $key');
    await _storage.delete(key: key.value);
  }

  /// 전체 삭제
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
