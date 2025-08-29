import 'package:feed_app/app/core/constants/app_constants.dart';
import 'package:feed_app/app/core/injection/injection_container.dart' as di;
import 'package:feed_app/app/export.dart';

class FeedApp extends StatelessWidget {
  const FeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizer.init(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        BlocProvider(create: (context) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<BottomNavBloc>()),
        BlocProvider(create: (_) => di.sl<FeedBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: theme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
