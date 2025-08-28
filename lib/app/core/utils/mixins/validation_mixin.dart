import 'package:feed_app/app/core/constants/app_strings.dart';

mixin ValidationMixin {
  String? validateEmail(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return AppStrings.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return AppStrings.passwordRequired;
    }
    if (value!.length < 6) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value?.trim().isEmpty ?? true) {
      return AppStrings.confirmPasswordRequired;
    }
    if (value != password) {
      return AppStrings.passwordMismatch;
    }
    return null;
  }

  String? validateRequired(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return AppStrings.required;
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return AppStrings.phoneRequired;
    }
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value!.trim())) {
      return AppStrings.invalidPhone;
    }
    return null;
  }
}
