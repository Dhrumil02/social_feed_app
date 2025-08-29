import 'package:feed_app/app/features/auth/presentation/screens/mobile_auth_screen.dart';
import 'package:feed_app/app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:feed_app/app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:feed_app/app/features/bottom_nav/presentation/screens/main_screen.dart';
import 'package:feed_app/app/features/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AppRoutes{
  static const initialPage = "/";
  static const signIn = "/signIn";
  static const signUp = "/signup";
  static const mobileAuth = "/mobile-auth";
  static const mainScreen = "/main-screen";
  static const forgetPassword = "/forget-password";
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.initialPage,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.initialPage,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.mainScreen,
        builder: (context, state) => const MainScreen(),
      ),GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.mobileAuth,
        builder: (context, state) => const MobileAuthScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}