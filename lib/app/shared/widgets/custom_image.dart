import 'package:cached_network_image/cached_network_image.dart';
import 'package:feed_app/app/export.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double borderRadius;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = 0.0,
  });

  bool get isNetworkImage => imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: isNetworkImage ? buildNetworkImage() : buildAssetImage(),
    );
  }

  Widget buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: fit),
          ),
        );
      },
      placeholder: (context, url) => Shimmer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }

  Widget buildAssetImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imageUrl), fit: fit),
      ),
    );
  }
}
