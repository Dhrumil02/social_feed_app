
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpWithEmailEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SendOTPEvent extends AuthEvent {
  final String phoneNumber;

  const SendOTPEvent({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOTPEvent extends AuthEvent {
  final String verificationId;
  final String smsCode;
  final String name;

  const VerifyOTPEvent({
    required this.verificationId,
    required this.smsCode,
    required this.name,
  });

  @override
  List<Object> get props => [verificationId, smsCode, name];
}

class SignInWithGoogleEvent extends AuthEvent {
  const SignInWithGoogleEvent();
}

class SignInWithAppleEvent extends AuthEvent {
  const SignInWithAppleEvent();
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

class GetCurrentUserEvent extends AuthEvent {
  const GetCurrentUserEvent();
}

class UpdateUserProfileEvent extends AuthEvent {
  final String name;
  final String? bio;
  final File? imageFile;

  const UpdateUserProfileEvent({
    required this.name,
    this.bio,
    this.imageFile,
  });

  @override
  List<Object?> get props => [name, bio, imageFile];
}

class SendPasswordResetEmailEvent extends AuthEvent {
  final String email;

  const SendPasswordResetEmailEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}