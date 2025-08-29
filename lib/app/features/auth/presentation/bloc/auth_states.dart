part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class OTPSent extends AuthState {
  final String verificationId;
  final String phoneNumber;

  const OTPSent({
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [verificationId, phoneNumber];
}

class PasswordResetEmailSent extends AuthState {
  final String email;

  const PasswordResetEmailSent({required this.email});

  @override
  List<Object> get props => [email];
}

class UserProfileUpdated extends AuthState {
  final UserEntity user;

  const UserProfileUpdated({required this.user});

  @override
  List<Object> get props => [user];
}