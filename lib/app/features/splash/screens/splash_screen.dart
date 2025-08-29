import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_app/app/core/constants/app_images.dart';
import 'package:feed_app/app/core/injection/injection_container.dart';
import 'package:feed_app/app/core/routes/app_router.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/shared/widgets/custom_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      context.read<AuthBloc>().add(const CheckAuthStatusEvent());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.go(AppRoutes.mainScreen);
              }
            });
          } else if (state is AuthUnauthenticated) {

            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.go(AppRoutes.signIn);
              }
            });
          }
        },
        child: CustomImage(
          imageUrl: AppImages.imgSplash,
          height: AppSizer.screenHeight,
          width: AppSizer.screenWidth,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
