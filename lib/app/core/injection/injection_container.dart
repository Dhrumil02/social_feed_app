import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feed_app/app/core/services/authentication_service.dart';
import 'package:feed_app/app/core/services/firebase_database_service.dart';
import 'package:feed_app/app/core/services/shared_preference_service.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:feed_app/app/features/auth/domain/repository/auth_repository.dart';
import 'package:feed_app/app/features/auth/domain/usercase/auth_use_case.dart';
import 'package:feed_app/app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:feed_app/app/features/bottom_nav/presentation/bloc/bottom_nav_bloc.dart';
import 'package:feed_app/app/features/feed/data/datasource/feed_remote_datasource.dart';
import 'package:feed_app/app/features/feed/data/repository/feed_repository_impl.dart';
import 'package:feed_app/app/features/feed/domain/repository/feed_repository.dart';
import 'package:feed_app/app/features/feed/domain/usercase/comment_usecases.dart';
import 'package:feed_app/app/features/feed/domain/usercase/post_usecase.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:feed_app/app/shared/theme/cubit/theme_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../network/network_info.dart';

final sl = GetIt.instance;

GlobalKey<NavigatorState> get navigatorKey =>
    sl.get<GlobalKey<NavigatorState>>();

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  await Hive.openBox('feedApp');
  sl.registerLazySingleton(() => GlobalKey<NavigatorState>());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Hive.box('feedApp'));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton<BottomNavBloc>(() => BottomNavBloc());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  sl.registerLazySingleton(() => SharedPreferenceService());
  sl.registerLazySingleton(() => AuthenticationService());
  sl.registerLazySingleton(() => FirebaseDatabaseService());

  /*
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl(), sl(), sl(), sl()),
  );
*/


  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authService: sl(),
      databaseService: sl(),
      networkInfo: sl(),
      sharedPrefService: sl(),
    ),
  );

  sl.registerFactory(
        () => FeedBloc(
      createPostUseCase: sl(),
      getPostsUseCase: sl(),
      updatePostUseCase: sl(),
      deletePostUseCase: sl(),
      likePostUseCase: sl(),
      unlikePostUseCase: sl(),
      addCommentUseCase: sl(),
      getCommentsUseCase: sl(),
      deleteCommentUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => SignUpWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => SendOTPUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOTPUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithAppleUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmailUseCase(sl()));
  sl.registerLazySingleton(() => IsUserLoggedInUseCase(sl()));
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => LikePostUseCase(sl()));
  sl.registerLazySingleton(() => UnlikePostUseCase(sl()));
  sl.registerLazySingleton(() => AddCommentUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(sl()));




  sl.registerLazySingleton<FeedRepository>(
        () => FeedRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );


  sl.registerLazySingleton<FeedRemoteDataSource>(
        () => FeedRemoteDataSourceImpl(),
  );



  sl.registerFactory(
    () => AuthBloc(
      signUpWithEmailUseCase: sl(),
      signInWithEmailUseCase: sl(),
      sendOTPUseCase: sl(),
      verifyOTPUseCase: sl(),
      signInWithGoogleUseCase: sl(),
      signInWithAppleUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      updateUserProfileUseCase: sl(),
      sendPasswordResetEmailUseCase: sl(),
      isUserLoggedInUseCase: sl(),
    ),
  );
}
