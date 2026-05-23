import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Constants.dart';
import 'app_colors.dart';

class Utils {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  static final _storage =
      new FlutterSecureStorage(aOptions: _getAndroidOptions());

  // 오토 로그인 여부
  static Future<bool> isAutoLogin() async {
    String? isAutoLogin = await _storage.read(key: "isAutoLogin");
    if (isAutoLogin == null || isAutoLogin! == "false") {
      return false;
    } else {
      return true;
    }
  }

  static Future<File> imageToFile(ByteData bytes, int index) async {
    Directory cacheDir = await getApplicationDocumentsDirectory();

    Directory localDir = Directory(cacheDir.path + "/localCachedFiles");
    if (!(await localDir.exists())) {
      await localDir.create();
    }
    File file = new File(
        "${localDir.path}/image_${index}_${DateTime.now().millisecondsSinceEpoch}.png");
    await new FileImage(file).evict();
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  static String getSequenceStr(int drillSequenceCount) {
    if (drillSequenceCount < 1) {
      return "";
    }
    switch (drillSequenceCount) {
      case 1:
        return "IMPRESSIVE!";
      case 2:
        return "OUTSTANDING!";
      case 3:
        return "RAMPAGE!";
      case 4:
        return "DOMINATING!";
      case 5:
        return "UNSTOPPABLE!";
      case 6:
        return "GODLIKE!";
      default:
        return "UNREAL!";
    }
  }

  static int bytesToInteger(List<int> byteArray) {
    // Python 에서는 temp +="{},".format(int.from_bytes(ba[pos:pos+3],'big',signed=True)); //big 형식으로 처리
    // 해당
    // int 3자리 ex  7f ff ff -> 0111 1111  1111 1111  1111 1111    0으로 시작 하는 + 값
    // int 2자리 ex  fd c5    -> 1111 1101  1100 0101               1로 시작하기 때문에 0000 0010 0011 1010 + 1 값인 -571  - 값
    int value = 0;
    if (byteArray.length == 3) {
      value += byteArray[0] << 16;
      value += byteArray[1] << 8;
      value += byteArray[2];
      value = value.toSigned(24);
    } else if (byteArray.length == 2) {
      value += byteArray[0] << 8;
      value += byteArray[1];
      value = value.toSigned(16);
    } else if (byteArray.length == 6) {
      value += byteArray[0] << 40;
      value += byteArray[1] << 32;
      value += byteArray[2] << 24;
      value += byteArray[3] << 16;
      value += byteArray[4] << 8;
      value += byteArray[5];
      value = value.toSigned(48);
    }
    return value;
  }

  // 로딩 다이얼로그 위젯
  static void showLoading(BuildContext context) {
    Utils.removeKeyboard(context);
    showDialog(
        context: context,
        builder: (ctx) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SizedBox(
                width: Get.width * 0.1,
                height: Get.width * 0.1,
                child: CircularProgressIndicator(color: AppColors.appColor),
              ),
            ),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Get.back();
    Utils.removeKeyboard(context);
  }

  // 푸쉬 온오프
  static Future<bool> isSetAlram() async {
    String? alramValue = await _storage.read(key: "alramValue");

    if (alramValue == null || alramValue! == "false") {
      return false;
    } else {
      return true;
    }
  }

  static Future<String> getAutoEmail() async {
    String? autoEmail = await _storage.read(key: "autoEmail");
    return autoEmail ?? "";
  }

  static Future<String> getAutoSNSType() async {
    String? autoSnsType = await _storage.read(key: "autoSnsType");
    return autoSnsType ?? "";
  }

  static Future<String> getAutoToken() async {
    String? autoProvider = await _storage.read(key: "autoToken");
    return autoProvider ?? "";
  }

  static Future<String> getAutoPassword() async {
    String? autoProvider = await _storage.read(key: "autoPassword");
    return autoProvider ?? "";
  }

  static Future<void> releaseAutoLogin() async {
    await _storage.write(key: "autoEmail", value: "");
    await _storage.write(key: "autoSnsType", value: "");
    await _storage.write(key: "autoToken", value: "");
    await _storage.write(key: "autoPassword", value: "");
    await _storage.write(key: "isAutoLogin", value: "false");
  }

  // 자동로그인 셋팅
  static Future<void> setAutoLogin(
      String email, String password, String token, String snsType) async {
    await _storage.write(key: "autoEmail", value: email);
    await _storage.write(key: "autoPassword", value: password);
    await _storage.write(key: "autoSnsType", value: snsType);
    await _storage.write(key: "autoToken", value: token);
    await _storage.write(key: "isAutoLogin", value: "true");
  }

  static String getStringTime(String time) {
    DateTime dateTime = DateTime.parse(time).toLocal();
    DateTime now = DateTime.now();

    Duration duration = now.difference(dateTime);
    if (duration.inSeconds > 60) {
      if (duration.inMinutes > 60) {
        if (duration.inHours > 24) {
          if (duration.inDays > 30) {
            int days = duration.inDays;
            if (days > 365) {
              return "${(days / 365).toInt()}년 전";
            } else {
              return "${(days / 30).toInt()}달 전";
            }
          } else {
            return "${duration.inDays}일 전";
          }
        } else {
          return "${duration.inHours}시간 전";
        }
      } else {
        return "${duration.inMinutes}분 전";
      }
    } else {
      return "${duration.inSeconds}초 전";
    }
  }

  static String getDateTimeToString(DateTime day) {
    String result = DateFormat("yyyy-MM-dd").format(day);
    return result;
  }

  static String getDateString(String time) {
    DateTime dateTime = DateTime.parse(time).toLocal();
    DateFormat formatter = DateFormat('yyyy.MM.dd');
    String strToday = formatter.format(dateTime);
    return strToday;
  }

  static String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy.MM.dd');
    String strToday = formatter.format(now);
    return strToday;
  }

  static String getBeforeday(int before) {
    DateTime today = DateTime.now();
    DateFormat formatter = DateFormat('MM.dd');
    String strBefore = formatter.format(today.subtract(Duration(days: before)));
    return strBefore;
  }

  static String getMinSecString(int duration) {
    int min = (duration / 60).toInt();
    int sec = duration % 60;

    if (min >= 60) {
      int hour = (min / 60).toInt();
      min = min % 60;
      return "${hour.toString().padLeft(2, "0")}:${min.toString().padLeft(2, "0")}:${sec.toString().padLeft(2, "0")}";
    }

    return "${min.toString().padLeft(2, "0")}:${sec.toString().padLeft(2, "0")}";
  }

  static String getMinSecStringKR(int duration) {
    int min = (duration / 60).toInt();
    int sec = duration % 60;

    if (min >= 60) {
      int hour = (min / 60).toInt();
      min = min % 60;
      return "${hour.toString().padLeft(2, "0")}시간 ${min.toString().padLeft(2, "0")}분 ${sec.toString().padLeft(2, "0")}초";
    }

    return "${min.toString().padLeft(2, "0")}분 ${sec.toString().padLeft(2, "0")}초";
  }

  static String getMinSecStringEng(int duration) {
    int min = (duration / 60).toInt();

    if (min >= 60) {
      int hour = (min / 60).toInt();
      min = min % 60;
      return "${hour.toString()}H ${min.toString()}M";
    }

    return "${min.toString()}M";
  }

  static String toPrice(int price) {
    final formatCurrency = NumberFormat.simpleCurrency(
        locale: "ko_KR", name: "", decimalDigits: 0);

    return formatCurrency.format(price);
  }

  static String parseVersionFromYaml(String yamlVersion) {
    return yamlVersion.split('+')[0];
  }

  static Future<File> getAudioFileFromAssets(
      String path, String filename) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$filename');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  static void removeKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).unfocus();
  }

  static Future<String> saveImageFile(Uint8List image, String name) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    Directory directory = Directory("$dir/image/");
    if (!(await directory.exists())) {
      await directory.create();
    }
    File file = File("${directory.path}$name.png");

    await file.writeAsBytes(image);

    return file.path;
  }

  static Future<void> launchSafeUrl(String input) async {
    if (input.trim().isEmpty) return;

    final cleanedUrl = _normalizeUrl(input);
    final uri = Uri.tryParse(cleanedUrl);

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw '유효하지 않은 URL: $input';
    }
  }

  static String _normalizeUrl(String url) {
    final trimmed = url.trim();
    final lower = trimmed.toLowerCase();

    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return trimmed;
    } else {
      return 'https://$trimmed';
    }
  }
}
