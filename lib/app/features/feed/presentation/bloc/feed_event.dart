import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadPosts extends FeedEvent {}

class CreatePost extends FeedEvent {
  final String caption;
  final File imageFile;

  const CreatePost({required this.caption, required this.imageFile});

  @override
  List<Object> get props => [caption, imageFile];
}

class UpdatePost extends FeedEvent {
  final String postId;
  final String? caption;
  final File? newImageFile;

  const UpdatePost({required this.postId, this.caption, this.newImageFile});

  @override
  List<Object?> get props => [postId, caption, newImageFile];
}

class DeletePost extends FeedEvent {
  final String postId;

  const DeletePost(this.postId);

  @override
  List<Object> get props => [postId];
}

class LikePost extends FeedEvent {
  final String postId;

  const LikePost(this.postId);

  @override
  List<Object> get props => [postId];
}

class UnlikePost extends FeedEvent {
  final String postId;

  const UnlikePost(this.postId);

  @override
  List<Object> get props => [postId];
}

class LoadComments extends FeedEvent {
  final String postId;

  const LoadComments(this.postId);

  @override
  List<Object> get props => [postId];
}

class AddComment extends FeedEvent {
  final String postId;
  final String text;

  const AddComment({required this.postId, required this.text});

  @override
  List<Object> get props => [postId, text];
}

class DeleteComment extends FeedEvent {
  final String commentId;

  const DeleteComment(this.commentId);

  @override
  List<Object> get props => [commentId];
}
