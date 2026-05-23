class TermsAgreeRequest {
  final bool isAllTermsAgreed;
  final bool isPhoneVerificationServiceTermsAgreed;
  final bool isCarrierTermsAgreed;
  final bool isPersonalInfoConsentAgreed;
  final bool isUniqueIdInfoProcessingAgreed;

  const TermsAgreeRequest({
    required this.isAllTermsAgreed,
    required this.isPhoneVerificationServiceTermsAgreed,
    required this.isCarrierTermsAgreed,
    required this.isPersonalInfoConsentAgreed,
    required this.isUniqueIdInfoProcessingAgreed,
  });

  static TermsAgreeRequest get initialState => TermsAgreeRequest(
        isAllTermsAgreed: false,
        isPhoneVerificationServiceTermsAgreed: false,
        isCarrierTermsAgreed: false,
        isPersonalInfoConsentAgreed: false,
        isUniqueIdInfoProcessingAgreed: false,
      );

  TermsAgreeRequest copyWith({
    bool? isAllTermsAgreed,
    bool? isPhoneVerificationServiceTermsAgreed,
    bool? isCarrierTermsAgreed,
    bool? isPersonalInfoConsentAgreed,
    bool? isUniqueIdInfoProcessingAgreed,
  }) =>
      TermsAgreeRequest(
        isAllTermsAgreed: isAllTermsAgreed ?? this.isAllTermsAgreed,
        isPhoneVerificationServiceTermsAgreed:
            isPhoneVerificationServiceTermsAgreed ??
                this.isPhoneVerificationServiceTermsAgreed,
        isCarrierTermsAgreed: isCarrierTermsAgreed ?? this.isCarrierTermsAgreed,
        isPersonalInfoConsentAgreed:
            isPersonalInfoConsentAgreed ?? this.isPersonalInfoConsentAgreed,
        isUniqueIdInfoProcessingAgreed: isUniqueIdInfoProcessingAgreed ??
            this.isUniqueIdInfoProcessingAgreed,
      );
}
