enum Gender {
  male(displayText: "남자", queryValue: "MALE"),
  female(displayText: "여자", queryValue: "FEMALE"),
  none(displayText: "미지정", queryValue: "UNSPECIFIED");

  final String displayText;
  final String queryValue;

  const Gender({
    required this.displayText,
    required this.queryValue,
  });
}