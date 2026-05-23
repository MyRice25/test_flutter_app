import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../dio/dio_service.dart';
import '../secure_storage/secure_storage_service.dart';

abstract class AndroidChannelConstants {
  static const androidChannelId = 'high_importance_channel';
  static const androidChannelName = 'High Importance Notifications';
  static const androidChannelDesc = '기본 알림 채널';
}

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SecureStorageService _storage = SecureStorageService();

  // 로컬 알림
  final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  ///
  /// FCM 초기화 및 권한 요청
  ///
  Future<void> initialize() async {
    try {
      // 백그라운드 메시지 핸들러 등록
      // main runApp 이전에 호출해야 함
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // 로컬 알림 초기화
      await _initializeLocalNotifications();

      // iOS 알림 권한 요청
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false, // iOS에서 임시 권한 허용 여부
        sound: true,
      );

      log('알림 권한 상태: ${settings.authorizationStatus}');

      // iOS는 APNs 토큰이 준비될 때까지 대기
      if (Platform.isIOS) {
        // 포그라운드에서 알림 노출 설정
        await _messaging.setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );

        // APNs 토큰이 준비될 때까지 대기
        await _waitForApnsToken();
      }

      // FCM 토큰 동기화
      await _syncFcmToken();

      // FCM 토큰 갱신 리스너 등록
      _messaging.onTokenRefresh.listen((updatedToken) {
        log('FCM 토큰 갱신: $updatedToken');
        _syncFcmToken(updatedToken: updatedToken);
      });

      // 메시지 리스너 등록
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 앱 실행 시 메시지 처리
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // TODO: - 앱 실행 시 메시지 처리
      });
    } catch (e) {
      log('FCM 초기화 오류: $e');
    }
  }

  ///
  /// APNs 토큰이 준비될 때까지 대기
  ///
  Future<void> _waitForApnsToken() async {
    const maxRetries = 10;
    const retryInterval = Duration(milliseconds: 500);

    for (int i = 0; i < maxRetries; i++) {
      try {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          log('APNs 토큰 준비 완료');
          return;
        }
      } catch (e) {
        log('APNs 토큰 확인 시도 ${i + 1}/$maxRetries: $e');
      }

      if (i < maxRetries - 1) {
        await Future.delayed(retryInterval);
      }
    }
  }

  /// FCM 토큰 동기화(저장 + 서버로 전달)
  Future<void> _syncFcmToken({String? updatedToken}) async {
    try {
      // 업데이트된 토큰이 있으면 사용, 없으면 현재 토큰 가져오기
      final token = updatedToken ?? await _messaging.getToken();

      // 토큰이 없을 경우
      if (token == null) {
        log('FCM 토큰 없음');
        return;
      }

      // 토큰 저장 및 서버로 전달
      Future.wait([
        _storage.save(SecureStorageKey.fcmToken, token),
        _updateFcmToken(token),
      ]);
    } catch (e) {
      log('FCM 토큰 동기화 오류: $e');
    }
  }

  ///
  /// FCM 토큰 업데이트 (서버로 전달)
  ///
  Future<void> _updateFcmToken(String fcmToken) async {
    final accessToken = await _storage.get(SecureStorageKey.accessToken);
    if (accessToken == null) {
      log('액세스 토큰 없음 FCM 토큰 업데이트 중단');
      return;
    }
    try {
      final dioService = DioService();
      await dioService.put(
        path: 'user/my-fcm-token',
        data: {'fcmToken': fcmToken},
        tokenType: TokenType.access,
      );
      log('FCM 토큰 업데이트 완료');
    } catch (e) {
      log('FCM 토큰 업데이트 오류: $e');
    }
  }

  // --------------------Foreground 처리를 위한 로컬 알림--------------------------

  ///
  /// 로컬 알림 초기화
  ///
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    await _ensureAndroidNotificationsPermission();
  }

  ///
  /// 안드로이드 알림 권한 확인
  /// Android 13+ 부터 알림 권한을 런타임으로 허용받아야 함
  ///
  Future<void> _ensureAndroidNotificationsPermission() async {
    if (!Platform.isAndroid) return;

    /// 안드로이드 플러터 로컬 알림 플러그인
    final androidPlugin = _notificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    /// 알림 채널 생성
    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        AndroidChannelConstants.androidChannelId,
        AndroidChannelConstants.androidChannelName,
        description: AndroidChannelConstants.androidChannelDesc,
        importance: Importance.high,
        showBadge: true
      ),
    );
    await androidPlugin?.requestNotificationsPermission();
  }

  ///
  /// 로컬 알림 탭 처리
  ///
  void _onNotificationTapped(NotificationResponse response) {
    // 페이로드 파싱
    if (response.payload != null && response.payload!.isNotEmpty) {
      final Map<String, dynamic> payload = jsonDecode(response.payload!);
      // TODO: - 로컬 알림 탭 처리
    }
  }

  ///
  /// 포그라운드 메시지 처리
  ///
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    

    try {
      const androidDetails = AndroidNotificationDetails(
        AndroidChannelConstants.androidChannelId,
        AndroidChannelConstants.androidChannelName,
        channelDescription: AndroidChannelConstants.androidChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationPlugin.show(
        message.hashCode,
        message.notification?.title ?? '알림',
        message.notification?.body ?? '',
        notificationDetails,
        payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
      );
    } catch (e) {
      log('로컬 알림 표시 오류: $e');
    }
  }
}

// --------------------Background 처리--------------------------

///
/// 백그라운드 메시지 핸들러
///
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
