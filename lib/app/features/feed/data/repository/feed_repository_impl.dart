import 'dart:io';

import 'package:feed_app/app/features/feed/data/datasource/feed_local_datasource.dart';
import 'package:feed_app/app/features/feed/data/datasource/feed_remote_datasource.dart';
import 'package:feed_app/app/features/feed/data/models/comment_model.dart';
import 'package:feed_app/app/features/feed/data/models/post_model.dart';
import 'package:feed_app/app/features/feed/domain/entity/comment.dart';
import 'package:feed_app/app/features/feed/domain/entity/post.dart';
import 'package:feed_app/app/features/feed/domain/repository/feed_repository.dart';
import 'package:uuid/uuid.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;
  final FeedLocalDataSource localDataSource;

  FeedRepositoryImpl({required this.remoteDataSource,required this.localDataSource});

  @override
  Future<Post> createPost({
    required String caption,
    required File imageFile,
    required String userId,
    required String userEmail,
  }) async {
    final postId = const Uuid().v4();
    final now = DateTime.now();

    final post = PostModel(
      id: postId,
      userId: userId,
      userEmail: userEmail,
      imageUrl: '',
      caption: caption,
      createdAt: now,
      updatedAt: now,
      likesCount: 0,
      commentsCount: 0,
      likedBy: [],
    );

    return await remoteDataSource.createPost(post, imageFile);
  }

  @override
  Future<List<Post>> getPosts() async {
    try {
      final posts = await remoteDataSource.getPosts();
      await localDataSource.cachePosts(posts);
      return posts;
    } catch (e) {
      return await localDataSource.getCachedPosts();
    }
  }

  @override
  Future<Post> updatePost({
    required String postId,
    String? caption,
    File? newImageFile,
  }) async {
    final posts = await remoteDataSource.getPosts();
    final currentPost = posts.firstWhere((p) => p.id == postId);

    final updatedPost = currentPost.copyWith(
      caption: caption ?? currentPost.caption,
      updatedAt: DateTime.now(),
    );

    return await remoteDataSource.updatePost(updatedPost, newImageFile);
  }

  @override
  Future<void> deletePost(String postId) async {
    await remoteDataSource.deletePost(postId);
  }

  @override
  Future<Post> likePost(String postId, String userId) async {
    return await remoteDataSource.likePost(postId, userId);
  }

  @override
  Future<Post> unlikePost(String postId, String userId) async {
    return await remoteDataSource.unlikePost(postId, userId);
  }

  @override
  Future<Comment> addComment({
    required String postId,
    required String text,
    required String userId,
    required String userEmail,
  }) async {
    final commentId = const Uuid().v4();

    final comment = CommentModel(
      id: commentId,
      postId: postId,
      userId: userId,
      userEmail: userEmail,
      text: text,
      createdAt: DateTime.now(),
    );

    return await remoteDataSource.addComment(comment);
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
    try {
      final comments = await remoteDataSource.getComments(postId);
      await localDataSource.cacheComments(postId, comments.cast<CommentModel>());
      return comments;
    } catch (e) {
      return await localDataSource.getCachedComments(postId);
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await remoteDataSource.deleteComment(commentId);
  }
}
