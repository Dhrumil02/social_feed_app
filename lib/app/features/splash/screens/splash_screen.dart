import 'package:feed_app/app/core/constants/app_images.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/shared/widgets/custom_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomImage(
        imageUrl: AppImages.imgSplash,
        height: AppSizer.screenHeight,
        width: AppSizer.screenWidth,
        fit: BoxFit.cover,
      ),
    );
  }
}
