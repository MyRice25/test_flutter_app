
import 'package:flutter/cupertino.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageUrls;

  const ImageSlider({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = width / 1.5; // 1.5:1 비율

    return SizedBox(
      width: width,
      height: height,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (_, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
              width: width,
              height: height,
            ),
          );
        },
      ),
    );
  }
}