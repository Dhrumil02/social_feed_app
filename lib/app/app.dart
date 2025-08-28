import 'package:feed_app/app/core/routes/app_router.dart';
import 'package:feed_app/app/export.dart';

class FeedApp extends StatelessWidget {
  const FeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizer.init(context);


    return MaterialApp.router(
      title: 'Flutter Feed App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
