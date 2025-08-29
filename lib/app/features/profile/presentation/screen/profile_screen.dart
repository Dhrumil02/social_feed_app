import 'package:feed_app/app/export.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          AppStrings.profile,
          style: context.headlineMedium.bold.copyWith(color: Colors.white),
        ),
        leading: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (ctx, state) {
            final theme = context.watch<ThemeCubit>().state;

            final isDark = theme.brightness == Brightness.dark;

            return IconButton(
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme(!isDark);
              },
              icon: Icon(isDark ? Icons.sunny : Icons.dark_mode),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          final userPosts = state.posts
              .where((post) => post.userId == currentUser?.uid)
              .toList();
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: AppSizes.s50,
                      backgroundColor: Colors.blue[100],
                      child: currentUser?.photoURL != null
                          ? CustomImage(imageUrl: currentUser!.photoURL)
                          : CustomText(
                              (currentUser?.email?[0] ?? 'U').toUpperCase(),
                              style: const TextStyle(
                                fontSize: AppSizes.s36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    AppSizes.vGap16,
                    CustomText(
                      currentUser?.email ?? AppStrings.unknownUser,
                      style: const TextStyle(
                        fontSize: AppSizes.s18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSizes.vGap24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatCard(
                          title: AppStrings.post,
                          value: userPosts.length.toString(),
                        ),
                        StatCard(
                          title: AppStrings.likes,
                          value: userPosts
                              .fold(0, (sum, post) => sum + post.likesCount)
                              .toString(),
                        ),
                        StatCard(
                          title: AppStrings.comments,
                          value: userPosts
                              .fold(0, (sum, post) => sum + post.commentsCount)
                              .toString(),
                        ),
                      ],
                    ),
                  ],
                ).padAll(AppSizes.s20),

                const Divider(),

                userPosts.isEmpty
                    ? Column(
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: AppSizes.s60,
                            color: Colors.grey,
                          ),
                          AppSizes.vGap16,
                          CustomText(
                            AppStrings.noPostYet,
                            style: context.bodyMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ).padAll(AppSizes.s40)
                    : Column(
                        children: userPosts.map((post) {
                          return PostCard(
                            post: post,
                            onEdit: () {
                              context.push(AppRoutes.editPost, extra: post);
                            },
                          );
                        }).toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(AppStrings.logout),
        content: CustomText(AppStrings.areYouSureYouWantToLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomText(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first
              await _performLogout(context);
            },
            child: CustomText(AppStrings.logout),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      final authService = sl<AuthenticationService>();
      final sharedPrefService = sl<SharedPreferenceService>();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await authService.signOut();

      await sharedPrefService.clearUserData();

      if (context.mounted) {
        Navigator.pop(context);

        context.go(AppRoutes.signIn);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
