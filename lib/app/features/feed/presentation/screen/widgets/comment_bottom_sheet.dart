import 'package:feed_app/app/core/utils/extensions/date_extensions.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/features/feed/domain/entity/comment.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_event.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),


          Expanded(
            child: BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                final comments = state.comments[widget.postId] ?? [];

                if (comments.isEmpty) {
                  return const Center(
                    child: Text('No comments yet'),
                  );
                }
                print("comment list ${comments.length}");

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _CommentItem(
                      comment: comment,
                      onDelete: () {
                        context.read<FeedBloc>().add(DeleteComment(comment.id));
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Add comment
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addComment,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    context.read<FeedBloc>().add(
      AddComment(
        postId: widget.postId,
        text: _commentController.text.trim(),
      ),
    );

    _commentController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class _CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onDelete;

  const _CommentItem({
    required this.comment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner = currentUser?.uid == comment.userId;

    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        child: Text(comment.userEmail[0].toUpperCase()),
      ),
      title: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: comment.userEmail,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ' '),
            TextSpan(text: comment.text),
          ],
        ),
      ),
      subtitle: Text(
          comment.createdAt.timeAgo,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: isOwner
          ? IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Comment'),
              content: const Text('Are you sure you want to delete this comment?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.delete, size: 18),
      )
          : null,
    );
  }
}