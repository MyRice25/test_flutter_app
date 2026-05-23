enum DeepLinkType {
  none(linkName: ''),
  codeShare(linkName: 'codeShare'); // 코드 공유

  final String linkName;

  const DeepLinkType({
    required this.linkName,
  });

  factory DeepLinkType.fromLinkName(String? linkName) {
    if (linkName == null) {
      return DeepLinkType.none;
    }

    return DeepLinkType.values.firstWhere(
      (type) => type.linkName == linkName,
      orElse: () => DeepLinkType.none,
    );
  }
}
