import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/features/feed/data/datasource/feed_local_datasource.dart';

final sl = GetIt.instance;

GlobalKey<NavigatorState> get navigatorKey =>
    sl.get<GlobalKey<NavigatorState>>();

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  await Hive.openBox('feedApp');
  sl.registerLazySingleton(() => GlobalKey<NavigatorState>());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
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
  sl.registerLazySingleton<FeedLocalDataSource>(
        () => FeedLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<FeedRepository>(
    () => FeedRepositoryImpl(remoteDataSource: sl(),localDataSource: sl()),
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
