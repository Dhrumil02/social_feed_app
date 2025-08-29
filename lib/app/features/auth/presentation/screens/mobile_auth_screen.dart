
import 'package:feed_app/app/core/constants/app_strings.dart';
import 'package:feed_app/app/core/routes/app_router.dart';
import 'package:feed_app/app/export.dart';

class MobileAuthScreen extends StatefulWidget {
  const MobileAuthScreen({super.key});

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> with ValidationMixin {
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();

  String? verificationId;
  bool showOTPField = false;
  bool showNameField = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _sendOTP() {
    if (_phoneFormKey.currentState!.validate()) {
      String phoneNumber = _mobileController.text.trim();
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+91$phoneNumber';
      }
      context.read<AuthBloc>().add(SendOTPEvent(phoneNumber: phoneNumber));
    }
  }

  void _verifyOTP() {
    if (_otpFormKey.currentState!.validate() && verificationId != null) {
      context.read<AuthBloc>().add(VerifyOTPEvent(
        verificationId: verificationId!,
        smsCode: _otpController.text.trim(),
        name: _nameController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OTPSent) {
            setState(() {
              verificationId = state.verificationId;
              showOTPField = true;
              showNameField = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('OTP sent to ${state.phoneNumber}'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthAuthenticated) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Your Phone Number',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _phoneFormKey,
                  child: CustomTextField(
                    controller: _mobileController,
                    labelText: AppStrings.mobileNumber,
                    hintText: AppStrings.enterMobileNumber,
                    keyboardType: TextInputType.phone,
                    validator: validatePhone,
                    enabled: !showOTPField,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),
                if (!showOTPField)
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Send OTP',
                        onPressed: _sendOTP,
                        isLoading: state is AuthLoading,
                        isEnabled: true,
                        backGroundColor: Theme.of(context).primaryColor,
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        borderColor: Theme.of(context).primaryColor,
                        borderRadius: 12,
                        textSize: 16,
                      );
                    },
                  ),
                if (showNameField) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    keyboardType: TextInputType.name,
                    validator: validateRequired,
                    prefixIcon: const Icon(Icons.person),
                  ),
                ],
                if (showOTPField) ...[
                  const SizedBox(height: 16),
                  Form(
                    key: _otpFormKey,
                    child: CustomTextField(
                      controller: _otpController,
                      labelText: 'OTP',
                      hintText: 'Enter 6-digit OTP',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'OTP is required';
                        }
                        if (value!.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.security),
                      maxLength: 6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Verify OTP',
                        onPressed: _verifyOTP,
                        isLoading: state is AuthLoading,
                        isEnabled: _otpController.text.length == 6 &&
                            _nameController.text.isNotEmpty &&
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
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showOTPField = false;
                        showNameField = false;
                        verificationId = null;
                        _otpController.clear();
                        _nameController.clear();
                      });
                    },
                    child: const Text('Change Phone Number'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}