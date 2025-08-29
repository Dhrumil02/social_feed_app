import 'package:feed_app/app/core/utils/extensions/date_extensions.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/features/feed/domain/entity/post.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_event.dart';
import 'package:feed_app/app/shared/widgets/custom_image.dart';

import 'comment_bottom_sheet.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PostCard({super.key, required this.post, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner = currentUser?.uid == post.userId;
    final isLiked =
        currentUser != null && post.likedBy.contains(currentUser.uid);

    return Card(
      margin: Spacing.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: CustomText(post.userEmail[0].toUpperCase()),
            ),
            title: CustomText(post.userEmail),
            subtitle: CustomText(post.createdAt.timeAgo),
            trailing: isOwner
                ? PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit?.call();
                      } else if (value == 'delete') {
                        _showDeleteDialog(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: CustomText('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: CustomText('Delete'),
                      ),
                    ],
                  )
                : null,
          ),

          AspectRatio(
            aspectRatio: 1.0,
            child: CustomImage(imageUrl: post.imageUrl),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (isLiked) {
                    context.read<FeedBloc>().add(UnlikePost(post.id));
                  } else {
                    context.read<FeedBloc>().add(LikePost(post.id));
                  }
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showCommentsBottomSheet(context);
                },
                icon: const Icon(Icons.comment_outlined),
              ),
            ],
          ),

          if (post.likesCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
              child: CustomText(
                '${post.likesCount} ${post.likesCount == 1 ? 'like' : 'likes'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

          Padding(
            padding: Spacing.all(AppSizes.s16),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: post.userEmail,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: post.caption),
                ],
              ),
            ),
          ),

          if (post.commentsCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
              child: GestureDetector(
                onTap: () => _showCommentsBottomSheet(context),
                child: CustomText(
                  'View all ${post.commentsCount} comments',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: AppSizes.s14,
                  ),
                ),
              ),
            ),

          AppSizes.vGap8,
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomText('Delete Post'),
        content: const CustomText('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FeedBloc>().add(DeletePost(post.id));
            },
            child: const CustomText('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    context.read<FeedBloc>().add(LoadComments(post.id));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommentsBottomSheet(postId: post.id),
    );
  }
}
