import 'package:feed_app/app/core/routes/app_router.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_state.dart';
import 'package:feed_app/app/features/feed/presentation/screen/widgets/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          (currentUser?.email?[0] ?? 'U').toUpperCase(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentUser?.email ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatCard(
                            title: 'Posts',
                            value: userPosts.length.toString(),
                          ),
                          _StatCard(
                            title: 'Likes',
                            value: userPosts
                                .fold(0, (sum, post) => sum + post.likesCount)
                                .toString(),
                          ),
                          _StatCard(
                            title: 'Comments',
                            value: userPosts
                                .fold(0, (sum, post) => sum + post.commentsCount)
                                .toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // User's Posts
                if (userPosts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No posts yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: userPosts.map((post) {
                      return PostCard(
                        post: post,
                        onEdit: () {
                          context.go(AppRoutes.editPost,extra: post);

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
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {

              FirebaseAuth.instance.signOut();
              
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}