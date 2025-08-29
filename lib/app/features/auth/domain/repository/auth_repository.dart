import 'package:dartz/dartz.dart';
import 'package:feed_app/app/core/error/failures.dart';
import 'package:feed_app/app/features/auth/domain/entity/user_entity.dart';
import 'dart:io';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> sendOTP(String phoneNumber);

  Future<Either<Failure, UserEntity>> verifyOTPAndSignIn({
    required String verificationId,
    required String smsCode,
    required String name,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, UserEntity>> signInWithApple();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String name,
    String? bio,
    File? imageFile,
  });

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  bool get isUserLoggedIn;
}