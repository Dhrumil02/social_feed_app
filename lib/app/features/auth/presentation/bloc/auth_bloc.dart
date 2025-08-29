import 'package:feed_app/app/export.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:feed_app/app/features/auth/domain/entity/user_entity.dart';
import 'package:feed_app/app/features/auth/domain/usercase/auth_use_case.dart';

part 'auth_events.dart';
part 'auth_states.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {


  final SignUpWithEmailUseCase signUpWithEmailUseCase;
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SendOTPUseCase sendOTPUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithAppleUseCase signInWithAppleUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  final IsUserLoggedInUseCase isUserLoggedInUseCase;

  AuthBloc({
    required this.signUpWithEmailUseCase,
    required this.signInWithEmailUseCase,
    required this.sendOTPUseCase,
    required this.verifyOTPUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithAppleUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateUserProfileUseCase,
    required this.sendPasswordResetEmailUseCase,
    required this.isUserLoggedInUseCase,
  }) : super(const AuthInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SendOTPEvent>(_onSendOTP);
    on<VerifyOTPEvent>(_onVerifyOTP);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithAppleEvent>(_onSignInWithApple);
    on<SignOutEvent>(_onSignOut);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<SendPasswordResetEmailEvent>(_onSendPasswordResetEmail);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  void _onSignUpWithEmail(
      SignUpWithEmailEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signUpWithEmailUseCase(
      email: event.email,
      password: event.password,
      name: event.name,
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void _onSignInWithEmail(
      SignInWithEmailEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signInWithEmailUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void _onSendOTP(
      SendOTPEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await sendOTPUseCase(event.phoneNumber);

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (verificationId) => emit(OTPSent(
        verificationId: verificationId,
        phoneNumber: event.phoneNumber,
      )),
    );
  }

  void _onVerifyOTP(
      VerifyOTPEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await verifyOTPUseCase(
      verificationId: event.verificationId,
      smsCode: event.smsCode,
      name: event.name,
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void _onSignInWithGoogle(
      SignInWithGoogleEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signInWithGoogleUseCase();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void _onSignInWithApple(
      SignInWithAppleEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signInWithAppleUseCase();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void _onSignOut(
      SignOutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signOutUseCase();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (_) => emit(const AuthUnauthenticated()),
    );
  }

  void _onGetCurrentUser(
      GetCurrentUserEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await getCurrentUserUseCase();

    result.fold(
          (failure) => emit(const AuthUnauthenticated()),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void _onUpdateUserProfile(
      UpdateUserProfileEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await updateUserProfileUseCase(
      name: event.name,
      bio: event.bio,
      imageFile: event.imageFile,
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(UserProfileUpdated(user: user)),
    );
  }

  void _onSendPasswordResetEmail(
      SendPasswordResetEmailEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await sendPasswordResetEmailUseCase(event.email);

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (_) => emit(PasswordResetEmailSent(email: event.email)),
    );
  }

  void _onCheckAuthStatus(
      CheckAuthStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    final isLoggedIn = isUserLoggedInUseCase();

    if (isLoggedIn) {
      final result = await getCurrentUserUseCase();
      result.fold(
            (failure) => emit(const AuthUnauthenticated()),
            (user) => emit(AuthAuthenticated(user: user)),
      );
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}