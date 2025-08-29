import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_event.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_state.dart';
import 'package:feed_app/app/features/feed/presentation/screen/widgets/post_card.dart';

import 'edit_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  @override
  void initState() {
    context.read<FeedBloc>().add(LoadPosts());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FeedBloc>().add(LoadPosts());
        },
        child: BlocConsumer<FeedBloc, FeedState>(
          listener: (context, state) {
            if (state.status == Status.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'An error occurred'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == Status.loading && state.posts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.posts.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No posts yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create your first post!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return PostCard(
                  post: post,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPostScreen(post: post),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}