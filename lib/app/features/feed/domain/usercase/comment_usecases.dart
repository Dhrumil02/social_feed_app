import 'package:feed_app/app/features/feed/domain/entity/comment.dart';
import 'package:feed_app/app/features/feed/domain/repository/feed_repository.dart';

class AddCommentUseCase {
  final FeedRepository repository;

  AddCommentUseCase(this.repository);

  Future<Comment> call({
    required String postId,
    required String text,
    required String userId,
    required String userEmail,
  }) async {
    if (text.trim().isEmpty) {
      throw Exception('comment cannot be empty');
    }

    return await repository.addComment(
      postId: postId,
      text: text.trim(),
      userId: userId,
      userEmail: userEmail,
    );
  }
}

class GetCommentsUseCase {
  final FeedRepository repository;

  GetCommentsUseCase(this.repository);

  Future<List<Comment>> call(String postId) async {
    return await repository.getComments(postId);
  }
}

class DeleteCommentUseCase {
  final FeedRepository repository;

  DeleteCommentUseCase(this.repository);

  Future<void> call(String commentId) async {
    return await repository.deleteComment(commentId);
  }
}
