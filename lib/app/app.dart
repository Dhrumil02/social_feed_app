import 'package:feed_app/app/core/routes/app_router.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/shared/theme/cubit/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feed_app/app/core/injection/injection_container.dart' as di;

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/bottom_nav/presentation/bloc/bottom_nav_bloc.dart';

class FeedApp extends StatelessWidget {
  const FeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizer.init(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<ThemeCubit>(),
        ),

        BlocProvider(create: (_) => di.sl<BottomNavBloc>() ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp.router(
            title: 'Feed App',
            debugShowCheckedModeBanner: false,
            theme: theme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
