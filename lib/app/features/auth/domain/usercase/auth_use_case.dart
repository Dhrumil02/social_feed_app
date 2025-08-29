import 'package:dartz/dartz.dart';
import 'package:feed_app/app/core/error/failures.dart';
import 'package:feed_app/app/features/auth/domain/entity/user_entity.dart';
import 'dart:io';

import 'package:feed_app/app/features/auth/domain/repository/auth_repository.dart';

class SignUpWithEmailUseCase {
  final AuthRepository repository;

  SignUpWithEmailUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
  }
}

class SignInWithEmailUseCase {
  final AuthRepository repository;

  SignInWithEmailUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

class SendOTPUseCase {
  final AuthRepository repository;

  SendOTPUseCase(this.repository);

  Future<Either<Failure, String>> call(String phoneNumber) async {
    return await repository.sendOTP(phoneNumber);
  }
}

class VerifyOTPUseCase {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String verificationId,
    required String smsCode,
    required String name,
  }) async {
    return await repository.verifyOTPAndSignIn(
      verificationId: verificationId,
      smsCode: smsCode,
      name: name,
    );
  }
}

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInWithGoogle();
  }
}

class SignInWithAppleUseCase {
  final AuthRepository repository;

  SignInWithAppleUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInWithApple();
  }
}

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}

class UpdateUserProfileUseCase {
  final AuthRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    String? bio,
    File? imageFile,
  }) async {
    return await repository.updateUserProfile(
      name: name,
      bio: bio,
      imageFile: imageFile,
    );
  }
}

class SendPasswordResetEmailUseCase {
  final AuthRepository repository;

  SendPasswordResetEmailUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.sendPasswordResetEmail(email);
  }
}

class IsUserLoggedInUseCase {
  final AuthRepository repository;

  IsUserLoggedInUseCase(this.repository);

  bool call() {
    return repository.isUserLoggedIn;
  }
}