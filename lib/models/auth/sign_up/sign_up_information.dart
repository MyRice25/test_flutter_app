import 'dart:io';
import '../../gender/gender.dart';

/// 로그인 방식
enum SignInType {
  kakao(queryValue: 'KAKAO', displayName: '카카오'),
  apple(queryValue: 'APPLE', displayName: '애플'),
  phone(queryValue: null, displayName: 'SMS'),
  unknown(queryValue: null, displayName: '');

  final String? queryValue;
  final String displayName;
  const SignInType({required this.queryValue, required this.displayName});
}

class SignUpInformation {
  final SignInType? provider; // OAuth 제공사 (KAKAO, APPLE) SMS는 null
  final String? providerEmail; // OAuth 제공사 이메일
  final String phoneNumber; // 가입하고자하는 전화번호
  final String name;
  final String birthDate;
  final String nickname;
  final String address;
  final String detailAddress;
  final Gender gender;
  final List<TermAgreement> termList;

  SignUpInformation({
    this.provider,
    this.providerEmail,
    required this.phoneNumber,
    required this.name,
    required this.birthDate,
    required this.nickname,
    required this.address,
    required this.detailAddress,
    required this.gender,
    required this.termList,
  });

  static SignUpInformation baseData = SignUpInformation(
    provider: null,
    providerEmail: null,
    phoneNumber: '',
    name: '',
    birthDate: '',
    nickname: '',
    address: '',
    detailAddress: '',
    gender: Gender.male,
    termList: TermAgreement.baseList(),
  );

  SignUpInformation copyWith({
    SignInType? provider,
    String? providerEmail,
    String? phoneNumber,
    String? name,
    String? birthDate,
    String? nickname,
    String? address,
    String? detailAddress,
    Gender? gender,
    List<TermAgreement>? termList,
  }) {
    return SignUpInformation(
      provider: provider ?? this.provider,
      providerEmail: providerEmail ?? this.providerEmail,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      nickname: nickname ?? this.nickname,
      address: address ?? this.address,
      detailAddress: detailAddress ?? this.detailAddress,
      gender: gender ?? this.gender,
      termList: termList ?? this.termList,
    );
  }

  Map<String, dynamic> toJson() {
    // 약관 동의 여부
    final isMarketingAgreement =
        termList.firstWhere((e) => e.type == TermAgreeType.marketing).isAgreed;
    final isSmsAndCallEnabled =
        termList.firstWhere((e) => e.type == TermAgreeType.sms).isAgreed;
    final isPushEnabled =
        termList.firstWhere((e) => e.type == TermAgreeType.push).isAgreed;

    return {
      'provider': provider?.queryValue,
      'providerEmail': providerEmail,
      'phoneNumber': phoneNumber,
      'name': name,
      'birthday': birthDate,
      'nickname': nickname,
      'address': address,
      'detailAddress': detailAddress,
      'gender': gender.queryValue,
      'isMarketingAgreement': isMarketingAgreement,
      'isSmsAndCallEnabled': isSmsAndCallEnabled,
      'isNotificationEnabled': isPushEnabled,
    };
  }

  @override
  String toString() {
    return 'SignUpInformation(provider: $provider, providerEmail: $providerEmail, phoneNumber: $phoneNumber, name: $name, birthDate: $birthDate, nickname: $nickname, address: $address, detailAddress: $detailAddress, gender: $gender, termList: $termList)';
  }
}

enum TermAgreeType {
  service,
  privacy,
  marketing,
  push,
  sms,
}

class TermAgreement {
  final String title;
  final bool isAgreed;
  final TermAgreeType type;
  final bool isRequired; // 필수인지

  TermAgreement({
    required this.title,
    required this.isAgreed,
    required this.type,
    required this.isRequired,
  });

  TermAgreement copyWith({
    bool? isAgreed,
  }) {
    return TermAgreement(
      title: title,
      isAgreed: isAgreed ?? this.isAgreed,
      type: type,
      isRequired: isRequired,
    );
  }

  static List<TermAgreement> baseList() {
    return [
      TermAgreement(
        title: '서비스 이용 약관(필수)',
        isAgreed: false,
        type: TermAgreeType.service,
        isRequired: true,
      ),
      TermAgreement(
        title: '개인정보처리방침(필수)',
        isAgreed: false,
        type: TermAgreeType.privacy,
        isRequired: true,
      ),
      TermAgreement(
        title: '마케팅 정보 수신 동의(선택)',
        isAgreed: false,
        type: TermAgreeType.marketing,
        isRequired: false,
      ),
      TermAgreement(
        title: '문자수신 및 전화수신 여부(선택)',
        isAgreed: false,
        type: TermAgreeType.sms,
        isRequired: false,
      ),
      TermAgreement(
        title: '앱 푸시 알림 설정(선택)',
        isAgreed: false,
        type: TermAgreeType.push,
        isRequired: false,
      ),
    ];
  }
}
