import 'dart:io';

import 'package:feed_app/app/features/feed/domain/entity/post.dart';
import 'package:feed_app/app/features/feed/domain/repository/feed_repository.dart';

class CreatePostUseCase {
  final FeedRepository repository;

  CreatePostUseCase(this.repository);

  Future<Post> call({
    required String caption,
    required File imageFile,
    required String userId,
    required String userEmail,
  }) async {
    if (caption.trim().isEmpty) {
      throw Exception('Caption cannot be empty');
    }

    return await repository.createPost(
      caption: caption.trim(),
      imageFile: imageFile,
      userId: userId,
      userEmail: userEmail,
    );
  }
}

class GetPostsUseCase {
  final FeedRepository repository;

  GetPostsUseCase(this.repository);

  Future<List<Post>> call() async {
    return await repository.getPosts();
  }
}

class DeletePostUseCase {
  final FeedRepository repository;

  DeletePostUseCase(this.repository);

  Future<void> call(String postId) async {
    return await repository.deletePost(postId);
  }
}

class LikePostUseCase {
  final FeedRepository repository;

  LikePostUseCase(this.repository);

  Future<Post> call(String postId, String userId) async {
    return await repository.likePost(postId, userId);
  }
}

class UnlikePostUseCase {
  final FeedRepository repository;

  UnlikePostUseCase(this.repository);

  Future<Post> call(String postId, String userId) async {
    return await repository.unlikePost(postId, userId);
  }
}

class UpdatePostUseCase {
  final FeedRepository repository;

  UpdatePostUseCase(this.repository);

  Future<Post> call({
    required String postId,
    String? caption,
    File? newImageFile,
  }) async {
    if (caption != null && caption.trim().isEmpty) {
      throw Exception('Caption cannot be empty');
    }

    return await repository.updatePost(
      postId: postId,
      caption: caption?.trim(),
      newImageFile: newImageFile,
    );
  }
}
