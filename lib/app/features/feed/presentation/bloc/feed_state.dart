import 'package:equatable/equatable.dart';
import 'package:feed_app/app/features/feed/domain/entity/comment.dart';
import 'package:feed_app/app/features/feed/domain/entity/post.dart';

enum Status { initial, loading, success, failure }

class FeedState extends Equatable {
  final Status status;
  final List<Post> posts;
  final Map<String, List<Comment>> comments;
  final Status postActionStatus;
  final String? errorMessage;
  final Post? updatedPost;

  const FeedState({
    this.status = Status.initial,
    this.posts = const [],
    this.comments = const {},
    this.postActionStatus = Status.initial,
    this.errorMessage,
    this.updatedPost,
  });

  FeedState copyWith({
    Status? status,
    List<Post>? posts,
    Map<String, List<Comment>>? comments,
    Status? postActionStatus,
    String? errorMessage,
    Post? updatedPost,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
      postActionStatus: postActionStatus ?? this.postActionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedPost: updatedPost ?? this.updatedPost,
    );
  }

  @override
  List<Object?> get props => [
    status,
    posts,
    comments,
    postActionStatus,
    errorMessage,
    updatedPost,
  ];
}
