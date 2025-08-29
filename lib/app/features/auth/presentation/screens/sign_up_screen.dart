import 'dart:io';

import 'package:feed_app/app/core/constants/app_images.dart';
import 'package:feed_app/app/core/utils/extensions/text_extensions.dart';
import 'package:feed_app/app/core/utils/extensions/theme_extension.dart';
import 'package:feed_app/app/core/utils/helpers/app_helper.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/shared/widgets/custom_image.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUpWithEmail() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpWithEmailEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
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
          child: Padding(
            padding: Spacing.all(AppSizes.s24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                      AppStrings.createAccount,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AppSizes.vGap32,
                    CustomTextField(
                      controller: _nameController,
                      labelText: AppStrings.fullName,
                      keyboardType: TextInputType.name,
                      validator: validateRequired,
                    ),
                    AppSizes.vGap8,
                    CustomTextField(
                      controller: _emailController,
                      labelText: AppStrings.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    AppSizes.vGap8,
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
                    AppSizes.vGap8,
                    CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      obscureText: _obscureConfirmPassword,
                      validator: (value) => validateConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    AppSizes.vGap24,
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: AppStrings.createAccount,
                          onPressed: _signUpWithEmail,
                          isLoading: state is AuthLoading,
                          isEnabled:
                              _nameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty &&
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
                        text: AppStrings.continueWithApple,
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
                    TextButton(
                      onPressed: () => context.go(AppRoutes.signIn),
                      child:  CustomText(
                        'Already have an account? Sign In',
                        style: context.bodyMedium.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
