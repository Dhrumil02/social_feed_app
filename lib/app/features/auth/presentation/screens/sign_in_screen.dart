import 'dart:io';

import 'package:feed_app/app/core/constants/app_images.dart';
import 'package:feed_app/app/core/utils/extensions/widget_extensions.dart';
import 'package:feed_app/app/core/utils/helpers/app_helper.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/shared/widgets/custom_image.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmail() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInWithEmailEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _signInWithGoogle() {
    context.read<AuthBloc>().add(const SignInWithGoogleEvent());
  }

  void _signInWithApple() {
    context.read<AuthBloc>().add(const SignInWithAppleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.mainScreen);
          } else if (state is AuthError) {
            AppHelper.showToast(state.message);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImage(
                    imageUrl: AppImages.imgAppLogo,
                    height: AppSizes.s100,
                    width: AppSizes.s100,
                  ),
                  AppSizes.vGap16,
                  CustomText(
                    AppStrings.welcomeBack,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.vGap32,
                  CustomTextField(
                    controller: _emailController,
                    labelText: AppStrings.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                  AppSizes.vGap12,
                  CustomTextField(
                    controller: _passwordController,
                    labelText: AppStrings.password,
                    obscureText: _obscurePassword,
                    validator: validatePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),

                  AppSizes.vGap24,
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: AppStrings.signIn,
                        onPressed: _signInWithEmail,
                        isLoading: state is AuthLoading,
                        isEnabled:
                        state is! AuthLoading,
                        backGroundColor: Theme.of(context).primaryColor,
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        borderColor: Theme.of(context).primaryColor,
                        borderRadius: AppSizes.s12,
                        textSize: AppSizes.s16,
                      );
                    },
                  ),
                  AppSizes.vGap16,
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s16,
                        ),
                        child: CustomText(
                          'OR',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  AppSizes.vGap16,
                  CustomIconTextButton(
                    iconRight: true,
                    svgIcon: AppImages.icGoogle,
                    text: AppStrings.continueWithGoogle,
                    onPressed: _signInWithGoogle,
                    isEnabled: true,
                    backGroundColor: Colors.white,
                    fontColor: Colors.black87,
                    fontWeight: FontWeight.w600,
                    borderColor: Colors.grey.shade300,
                    borderRadius: AppSizes.s12,
                    textSize: AppSizes.s16,
                  ),
                  if (Platform.isIOS) AppSizes.vGap12,
                  if (Platform.isIOS)
                    CustomIconTextButton(
                      iconRight: true,
                      svgIcon: AppImages.icApple,
                      text: AppStrings.continueWithGoogle,
                      onPressed: _signInWithApple,
                      isEnabled: true,
                      backGroundColor: Colors.black,
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      borderColor: Colors.black,
                      borderRadius: AppSizes.s12,
                      textSize: AppSizes.s16,
                    ),
                  AppSizes.vGap24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => context.go(AppRoutes.signUp),
                        child: const CustomText(AppStrings.createAccount),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.mobileAuth),
                        child: const CustomText(AppStrings.loginWithMobile),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ).padAll(AppSizes.s24),
        ),
      ),
    );
  }
}
