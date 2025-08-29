import 'package:feed_app/app/core/constants/app_images.dart';
import 'package:feed_app/app/core/utils/helpers/app_helper.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/shared/widgets/custom_image.dart';

class MobileAuthScreen extends StatefulWidget {
  const MobileAuthScreen({super.key});

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen>
    with ValidationMixin {
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
      context.read<AuthBloc>().add(
        VerifyOTPEvent(
          verificationId: verificationId!,
          smsCode: _otpController.text.trim(),
          name: _nameController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.go(AppRoutes.signIn),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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

            AppHelper.showToast('OTP sent to ${state.phoneNumber}');
          } else if (state is AuthAuthenticated) {
            context.go(AppRoutes.mainScreen);
          } else if (state is AuthError) {
            AppHelper.showToast(state.message);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: Spacing.all(AppSizes.s24),
            child: Column(
              children: [
                CustomImage(
                  imageUrl: AppImages.imgAppLogo,
                  height: AppSizes.s100,
                  width: AppSizes.s100,
                ),
                AppSizes.vGap16,
                CustomText(
                  AppStrings.enterMobileNumber,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSizes.vGap32,
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
                AppSizes.vGap24,
                if (!showOTPField)
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: AppStrings.sendOTP,
                        onPressed: _sendOTP,
                        isLoading: state is AuthLoading,
                        isEnabled: true,
                        backGroundColor: Theme.of(context).primaryColor,
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        borderColor: Theme.of(context).primaryColor,
                        borderRadius: AppSizes.s12,
                        textSize: AppSizes.s16,
                      );
                    },
                  ),
                if (showNameField) ...[
                  AppSizes.vGap16,
                  CustomTextField(
                    controller: _nameController,
                    labelText: AppStrings.fullName,
                    hintText: AppStrings.enterFullName,
                    keyboardType: TextInputType.name,
                    validator: validateRequired,
                    prefixIcon: const Icon(Icons.person),
                  ),
                ],
                if (showOTPField) ...[
                  AppSizes.vGap16,
                  Form(
                    key: _otpFormKey,
                    child: CustomTextField(
                      controller: _otpController,
                      labelText: AppStrings.sendOTP,
                      hintText: AppStrings.enterDigitOTP,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return AppStrings.otpIsRequired;
                        }
                        if (value!.length != 6) {
                          return AppStrings.otpMustBe6Digits;
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.security),
                      maxLength: 6,
                    ),
                  ),
                  AppSizes.vGap16,
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: AppStrings.verifyOTP,
                        onPressed: _verifyOTP,
                        isLoading: state is AuthLoading,
                        isEnabled:
                            _otpController.text.length == 6 &&
                            _nameController.text.isNotEmpty &&
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
                    child: const CustomText(AppStrings.changeMobileNumber),
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
