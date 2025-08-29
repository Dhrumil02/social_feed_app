
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_app/app/core/injection/injection_container.dart';
import 'package:feed_app/app/features/feed/data/models/comment_model.dart';
import 'package:feed_app/app/features/feed/data/models/post_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FeedRemoteDataSource {
  Future<PostModel> createPost(PostModel post, File imageFile);
  Future<List<PostModel>> getPosts();
  Future<PostModel> updatePost(PostModel post, File? newImageFile);
  Future<void> deletePost(String postId);
  Future<PostModel> likePost(String postId, String userId);
  Future<PostModel> unlikePost(String postId, String userId);
  Future<CommentModel> addComment(CommentModel comment);
  Future<List<CommentModel>> getComments(String postId);
  Future<void> deleteComment(String commentId);
}


class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final FirebaseFirestore _firestore = sl<FirebaseFirestore>();
  final FirebaseStorage _storage = sl<FirebaseStorage>();

  static const String postsCollection = 'posts';
  static const String commentsCollection = 'comments';

  @override
  Future<PostModel> createPost(PostModel post, File imageFile) async {
    try {
      final imageUrl = await _uploadPostImage(imageFile, post.userId);

      final postWithImage = PostModel(
        id: post.id,
        userId: post.userId,
        userEmail: post.userEmail,
        imageUrl: imageUrl,
        caption: post.caption,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        likesCount: 0,
        commentsCount: 0,
        likedBy: [],
      );

      await _firestore
          .collection(postsCollection)
          .doc(post.id)
          .set(postWithImage.toJson());

      return postWithImage;
    } catch (e) {
      throw Exception('createPost: $e');
    }
  }

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final querySnapshot = await _firestore
          .collection(postsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('getPosts: $e');
    }
  }

  @override
  Future<PostModel> updatePost(PostModel post, File? newImageFile) async {
    try {
      String imageUrl = post.imageUrl;

      if (newImageFile != null) {
        imageUrl = await _uploadPostImage(newImageFile, post.userId);
      }

      final updatedPost = post.copyWith(
        imageUrl: imageUrl,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(postsCollection)
          .doc(post.id)
          .update(updatedPost.toJson());

      return updatedPost;
    } catch (e) {
      throw Exception('updatePost: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {

      await _firestore.collection(postsCollection).doc(postId).delete();


      final commentsQuery = await _firestore
          .collection(commentsCollection)
          .where('postId', isEqualTo: postId)
          .get();

      final batch = _firestore.batch();
      for (final doc in commentsQuery.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('deletePost: $e');
    }
  }

  @override
  Future<PostModel> likePost(String postId, String userId) async {
    try {
      final data = _firestore.collection(postsCollection).doc(postId);

      return await _firestore.runTransaction<PostModel>((transaction) async {
        final snapshot = await transaction.get(data);
        final post = PostModel.fromJson(snapshot.data()!);

        final updatedLikedBy = List<String>.from(post.likedBy);
        if (!updatedLikedBy.contains(userId)) {
          updatedLikedBy.add(userId);
        }

        final updatedPost = post.copyWith(
          likedBy: updatedLikedBy,
          likesCount: updatedLikedBy.length,
        );

        transaction.update(data, updatedPost.toJson());
        return updatedPost;
      });
    } catch (e) {
      throw Exception('likePost: $e');
    }
  }

  @override
  Future<PostModel> unlikePost(String postId, String userId) async {
    try {
      final data = _firestore.collection(postsCollection).doc(postId);

      return await _firestore.runTransaction<PostModel>((transaction) async {
        final snapshot = await transaction.get(data);
        final post = PostModel.fromJson(snapshot.data()!);

        final updatedLikedBy = List<String>.from(post.likedBy);
        updatedLikedBy.remove(userId);

        final updatedPost = post.copyWith(
          likedBy: updatedLikedBy,
          likesCount: updatedLikedBy.length,
        );

        transaction.update(data, updatedPost.toJson());
        return updatedPost;
      });
    } catch (e) {
      throw Exception('unlikePost: $e');
    }
  }

  @override
  Future<CommentModel> addComment(CommentModel comment) async {
    try {

      await _firestore
          .collection(commentsCollection)
          .doc(comment.id)
          .set(comment.toJson());

      final postData = _firestore.collection(postsCollection).doc(comment.postId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postData);
        final post = PostModel.fromJson(snapshot.data()!);

        transaction.update(postData, {
          'commentsCount': post.commentsCount + 1,
        });
      });

      return comment;
    } catch (e) {
      throw Exception('addComment: $e');
    }
  }

  @override
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final querySnapshot = await _firestore
          .collection(commentsCollection)
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {

      final commentDoc = await _firestore
          .collection(commentsCollection)
          .doc(commentId)
          .get();

      if (!commentDoc.exists) return;

      final comment = CommentModel.fromJson(commentDoc.data()!);

      await _firestore.collection(commentsCollection).doc(commentId).delete();

      final postData = _firestore.collection(postsCollection).doc(comment.postId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postData);
        final post = PostModel.fromJson(snapshot.data()!);

        transaction.update(postData, {
          'commentsCount': post.commentsCount - 1,
        });
      });
    } catch (e) {
      throw Exception('deleteComment $e');
    }
  }

  Future<String> _uploadPostImage(File imageFile, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imageData = _storage
          .ref()
          .child('post_images')
          .child('${userId}_$timestamp.jpg');

      await imageData.putFile(imageFile);
      return await imageData.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
