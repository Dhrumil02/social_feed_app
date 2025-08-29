import 'package:feed_app/app/core/utils/extensions/theme_extension.dart';
import 'package:feed_app/app/core/utils/extensions/widget_extensions.dart';
import 'package:feed_app/app/core/utils/helpers/app_helper.dart';
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
        title: CustomText(AppStrings.feed),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FeedBloc>().add(LoadPosts());
        },
        child: BlocConsumer<FeedBloc, FeedState>(
          listener: (context, state) {
            if (state.status == Status.failure) {
              AppHelper.showToast(state.errorMessage ?? 'An error occurred');

            }
          },
          builder: (context, state) {
            if (state.status == Status.loading && state.posts.isEmpty) {
              return const CircularProgressIndicator().center;
            }

            if (state.posts.isEmpty) {
              return  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  AppSizes.vGap16,
                  CustomText(
                    AppStrings.noPostYet,
                    style: context.bodyLarge.copyWith(color: Colors.grey),
                  ),
                  AppSizes.vGap8,
                  CustomText(
                    'Create your first post!',
                    style: TextStyle(
                      fontSize: AppSizes.s14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ).center;
            }

            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return PostCard(
                  post: post,
                  onEdit: () {
                    context.go(AppRoutes.editPost,extra: post);
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