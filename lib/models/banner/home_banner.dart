class HomeBanner {
  final int id;
  final String imageURL;
  final String linkURL;

  const HomeBanner({
    required this.id,
    required this.imageURL,
    required this.linkURL,
  });

  static List<HomeBanner> get homeBanners => [
        HomeBanner(
          id: 1,
          imageURL: 'https://via.placeholder.com/150',
          linkURL: 'https://www.google.com',
        ),
        HomeBanner(
          id: 2,
          imageURL: 'https://via.placeholder.com/150',
          linkURL: 'https://www.google.com',
        ),
        HomeBanner(
          id: 3,
          imageURL: 'https://via.placeholder.com/150',
          linkURL: 'https://www.google.com',
        ),
      ];
}
