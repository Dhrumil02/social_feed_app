import 'package:feed_app/app/core/routes/app_router.dart';
import 'package:feed_app/app/core/utils/mixins/validation_mixin.dart';
import 'package:feed_app/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:feed_app/app/shared/widgets/custom_button.dart';
import 'package:feed_app/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


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
      context.read<AuthBloc>().add(SignUpWithEmailEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      keyboardType: TextInputType.name,
                      validator: validateRequired,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
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
                    const SizedBox(height: 24),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Create Account',
                          onPressed: _signUpWithEmail,
                          isLoading: state is AuthLoading,
                          isEnabled: _nameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty &&
                              state is! AuthLoading,
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
                    const SizedBox(height: 12),
                    CustomButton(
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
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Already have an account? Sign In'),
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