import 'dart:io';

import 'package:feed_app/app/features/feed/domain/entity/comment.dart';
import 'package:feed_app/app/features/feed/domain/entity/post.dart';

abstract class FeedRepository {
  Future<Post> createPost({
    required String caption,
    required File imageFile,
    required String userId,
    required String userEmail,
  });

  Future<List<Post>> getPosts();

  Future<Post> updatePost({
    required String postId,
    String? caption,
    File? newImageFile,
  });

  Future<void> deletePost(String postId);

  Future<Post> likePost(String postId, String userId);

  Future<Post> unlikePost(String postId, String userId);

  Future<Comment> addComment({
    required String postId,
    required String text,
    required String userId,
    required String userEmail,
  });

  Future<List<Comment>> getComments(String postId);

  Future<void> deleteComment(String commentId);
}