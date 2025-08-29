import 'package:dartz/dartz.dart';
import 'package:feed_app/app/core/error/failures.dart';
import 'package:feed_app/app/core/network/network_info.dart';
import 'package:feed_app/app/core/services/authentication_service.dart';
import 'package:feed_app/app/core/services/firebase_database_service.dart';
import 'package:feed_app/app/core/services/shared_preference_service.dart';
import 'package:feed_app/app/features/auth/data/models/user_model.dart';
import 'package:feed_app/app/features/auth/domain/entity/user_entity.dart';
import 'package:feed_app/app/features/auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';

class AuthRepositoryImpl implements AuthRepository {
  final AuthenticationService authService;
  final FirebaseDatabaseService databaseService;
  final SharedPreferenceService sharedPrefService;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.authService,
    required this.databaseService,
    required this.sharedPrefService,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userCredential = await authService.signUpWithEmailAndPassword(
          email,
          password,
        );

        final now = DateTime.now();
        final userModel = UserModel(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
          createdAt: now,
          updatedAt: now,
        );

        await databaseService.createUser(userModel);
        await sharedPrefService.setIsLoggedIn(true);
        await sharedPrefService.setUserUid(userModel.uid);

        return Right(userModel);
      } on FirebaseAuthException catch (e) {
        return Left(AuthFailure(message: e.message ?? 'Authentication failed'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userCredential = await authService.signInWithEmailAndPassword(
          email,
          password,
        );

        final userModel = await databaseService.getUser(userCredential.user!.uid);

        if (userModel != null) {
          await sharedPrefService.setIsLoggedIn(true);
          await sharedPrefService.setUserUid(userModel.uid);
          return Right(userModel);
        } else {
          return const Left(ServerFailure(message: 'User data not found'));
        }
      } on FirebaseAuthException catch (e) {
        return Left(AuthFailure(message: e.message ?? 'Authentication failed'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOTP(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        String? verificationId;

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            throw e;
          },
          codeSent: (String vId, int? resendToken) {
            verificationId = vId;
          },
          codeAutoRetrievalTimeout: (String vId) {
            verificationId = vId;
          },
        );

        if (verificationId != null) {
          return Right(verificationId!);
        } else {
          return const Left(AuthFailure(message: 'Failed to send OTP'));
        }
      } on FirebaseAuthException catch (e) {
        return Left(AuthFailure(message: e.message ?? 'Failed to send OTP'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOTPAndSignIn({
    required String verificationId,
    required String smsCode,
    required String name,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userCredential = await authService.verifyOTP(verificationId, smsCode);

        UserModel? existingUser = await databaseService.getUser(userCredential.user!.uid);

        if (existingUser == null) {
          final now = DateTime.now();
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            phone: userCredential.user!.phoneNumber,
            name: name,
            createdAt: now,
            updatedAt: now,
          );

          await databaseService.createUser(userModel);
          existingUser = userModel;
        }

        await sharedPrefService.setIsLoggedIn(true);
        await sharedPrefService.setUserUid(existingUser.uid);

        return Right(existingUser);
      } on FirebaseAuthException catch (e) {
        return Left(AuthFailure(message: e.message ?? 'OTP verification failed'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final userCredential = await authService.signInWithGoogle();

        UserModel? existingUser = await databaseService.getUser(userCredential.user!.uid);

        if (existingUser == null) {
          final now = DateTime.now();
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email,
            name: userCredential.user!.displayName ?? '',
            imageUrl: userCredential.user!.photoURL,
            createdAt: now,
            updatedAt: now,
          );

          await databaseService.createUser(userModel);
          existingUser = userModel;
        }

        await sharedPrefService.setIsLoggedIn(true);
        await sharedPrefService.setUserUid(existingUser.uid);

        return Right(existingUser);
      } on FirebaseAuthException catch (e) {
        return Left(AuthFailure(message: e.message ?? 'Google sign in failed'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    if (await networkInfo.isConnected) {
      try {
        final userCredential = await authService.signInWithApple();

        UserModel? existingUser = await databaseService.getUser(userCredential.user!.uid);

        if (existingUser == null) {
          final now = DateTime.now();
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email,
            name: userCredential.user!.displayName ?? '',
            createdAt: now,
            updatedAt: now,
          );

          await databaseService.createUser(userModel);
          existingUser = userModel;
        }

        await sharedPrefService.setIsLoggedIn(true);
        await sharedPrefService.setUserUid(existingUser.uid);

        return Right(existingUser);
      } on FirebaseAuthException catch (e) {
        return Left(AuthFailure(message: e.message ?? 'Apple sign in failed'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authService.signOut();
      await sharedPrefService.clearUserData();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final currentUser = authService.currentUser;
        if (currentUser != null) {
          final userModel = await databaseService.getUser(currentUser.uid);
          if (userModel != null) {
            return Right(userModel);
          }
        }
        return const Left(AuthFailure(message: 'User not found'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String name,
    String? bio,
    File? imageFile,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final currentUser = authService.currentUser;
        if (currentUser != null) {
          final existingUser = await databaseService.getUser(currentUser.uid);
          if (existingUser != null) {
            String? imageUrl = existingUser.imageUrl;

            if (imageFile != null) {
              imageUrl = await databaseService.uploadImage(imageFile, currentUser.uid);
            }

            final updatedUser = existingUser.copyWith(
              name: name,
              bio: bio,
              imageUrl: imageUrl,
              updatedAt: DateTime.now(),
            );

            await databaseService.updateUser(updatedUser);
            return Right(updatedUser);
          }
        }
        return const Left(AuthFailure(message: 'User not found'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await authService.sendPasswordResetEmail(email);
        return const Right(null);
      } on FirebaseAuthException catch (e) {
        return Left(AuthFailure(message: e.message ?? 'Failed to send reset email'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  bool get isUserLoggedIn => sharedPrefService.getIsLoggedIn();
}