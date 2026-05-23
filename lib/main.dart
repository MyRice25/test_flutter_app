import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_test/common/services/navigation/route_stack_observer.dart';
import 'package:flutter_app_test/screens/splash/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'common/services/app_size/app_size.dart';
import 'constants/StringConstants.dart';
import 'data/services/fcm/fcm_service.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // KakaoSdk.init(nativeAppKey: "2ea12f3dfdfaeea6d8227a429a9b6ead");

  // FCM 초기화
  final FcmService fcmService = FcmService();
  await fcmService.initialize();

  await initializeDateFormatting('ko_KR', null);

  // MeetingManager 사전 등록 (lazy initialization)
  // Get.lazyPut<MateManager>(() => MateManager(), fenix: true);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // iOS: 밝은 배경에 어두운 콘텐츠
      statusBarBrightness: Platform.isIOS ? Brightness.light : Brightness.dark,
      // Android: 밝은 배경에 어두운 아이콘
      statusBarIconBrightness:
          Platform.isIOS ? Brightness.dark : Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void _initLoadingIndicator() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.transparent
      ..boxShadow = []
      ..indicatorColor = const Color(0xFF17B179)
      ..maskType = EasyLoadingMaskType.black
      ..maskColor = Colors.transparent
      ..textColor = Colors.white
      ..dismissOnTap = false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _initLoadingIndicator();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기
      },
      child: GetMaterialApp(
        title: 'Trillow',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [RouteStackObserver.instance],
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          brightness: Platform.isIOS ? Brightness.dark : Brightness.light,
        ),
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          fontFamily: StringConstants.AppFont,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
        builder: EasyLoading.init(builder: (context, child) {
          AppSize.init(context);

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        }),
        home: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
          child: SplashScreen(),
        ),
      ),
    );
  }
}
