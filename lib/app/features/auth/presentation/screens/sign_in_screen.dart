import 'package:feed_app/app/core/constants/app_strings.dart';
import 'package:feed_app/app/core/routes/app_router.dart';
import 'package:feed_app/app/core/utils/helpers/app_helper.dart';
import 'package:feed_app/app/core/utils/mixins/validation_mixin.dart';
import 'package:feed_app/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:feed_app/app/shared/widgets/custom_button.dart';
import 'package:feed_app/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

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
      context.read<AuthBloc>().add(SignInWithEmailEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.mainScreen);
          } else if (state is AuthError) {

            print("${state.message}");

            AppHelper.showToast(state.message);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _emailController,
                    labelText: AppStrings.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
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
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: AppStrings.signIn,
                        onPressed: _signInWithEmail,
                        isLoading: state is AuthLoading,
                        isEnabled: !_emailController.text.isEmpty &&
                            !_passwordController.text.isEmpty &&
                            !(state is AuthLoading),
                        backGroundColor: Theme.of(context).primaryColor,
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        borderColor: Theme.of(context).primaryColor,
                        borderRadius: 12,
                        textSize: 16,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Continue with Google',
                    onPressed: _signInWithGoogle,
                    isEnabled: true,
                    backGroundColor: Colors.white,
                    fontColor: Colors.black87,
                    fontWeight: FontWeight.w600,
                    borderColor: Colors.grey.shade300,
                    borderRadius: 12,
                    textSize: 16,
                  ),
                  if(Platform.isIOS)     const SizedBox(height: 12),
                  if(Platform.isIOS)  CustomButton(
                    text: 'Continue with Apple',
                    onPressed: _signInWithApple,
                    isEnabled: true,
                    backGroundColor: Colors.black,
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w600,
                    borderColor: Colors.black,
                    borderRadius: 12,
                    textSize: 16,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => context.go(AppRoutes.signUp),
                        child: const Text('Create Account'),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.mobileAuth),
                        child: const Text('Phone Login'),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.forgetPassword),
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}