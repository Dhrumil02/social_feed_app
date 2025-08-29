import 'package:bloc/bloc.dart';
import 'package:feed_app/app/core/injection/injection_container.dart';
import 'package:feed_app/app/features/feed/domain/entity/comment.dart';
import 'package:feed_app/app/features/feed/domain/entity/post.dart';
import 'package:feed_app/app/features/feed/domain/usercase/comment_usecases.dart';
import 'package:feed_app/app/features/feed/domain/usercase/post_usecase.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_event.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final CreatePostUseCase _createPostUseCase;
  final GetPostsUseCase _getPostsUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final LikePostUseCase _likePostUseCase;
  final UnlikePostUseCase _unlikePostUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;
  final FirebaseAuth _auth = sl<FirebaseAuth>();

  FeedBloc({
    required CreatePostUseCase createPostUseCase,
    required GetPostsUseCase getPostsUseCase,
    required UpdatePostUseCase updatePostUseCase,
    required DeletePostUseCase deletePostUseCase,
    required LikePostUseCase likePostUseCase,
    required UnlikePostUseCase unlikePostUseCase,
    required AddCommentUseCase addCommentUseCase,
    required GetCommentsUseCase getCommentsUseCase,
    required DeleteCommentUseCase deleteCommentUseCase,
  }) : _createPostUseCase = createPostUseCase,
       _getPostsUseCase = getPostsUseCase,
       _updatePostUseCase = updatePostUseCase,
       _deletePostUseCase = deletePostUseCase,
       _likePostUseCase = likePostUseCase,
       _unlikePostUseCase = unlikePostUseCase,
       _addCommentUseCase = addCommentUseCase,
       _getCommentsUseCase = getCommentsUseCase,
       _deleteCommentUseCase = deleteCommentUseCase,
       super(const FeedState()) {
    on<LoadPosts>(_onLoadPosts);
    on<CreatePost>(_onCreatePost);
    on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);
    on<LikePost>(_onLikePost);
    on<UnlikePost>(_onUnlikePost);
    on<LoadComments>(_onLoadComments);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<FeedState> emit) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final posts = await _getPostsUseCase();
      emit(state.copyWith(status: Status.success, posts: posts));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<FeedState> emit) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    emit(state.copyWith(postActionStatus: Status.loading));

    try {
      final post = await _createPostUseCase(
        caption: event.caption,
        imageFile: event.imageFile,
        userId: currentUser.uid,
        userEmail: currentUser.email ?? '',
      );

      final updatedPosts = [post, ...state.posts];
      emit(
        state.copyWith(postActionStatus: Status.success, posts: updatedPosts),
      );
    } catch (e) {
      emit(
        state.copyWith(
          postActionStatus: Status.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdatePost(UpdatePost event, Emitter<FeedState> emit) async {
    emit(state.copyWith(postActionStatus: Status.loading));

    try {
      final updatedPost = await _updatePostUseCase(
        postId: event.postId,
        caption: event.caption,
        newImageFile: event.newImageFile,
      );

      final updatedPosts = state.posts.map((post) {
        return post.id == event.postId ? updatedPost : post;
      }).toList();

      emit(
        state.copyWith(
          postActionStatus: Status.success,
          posts: updatedPosts,
          updatedPost: updatedPost,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          postActionStatus: Status.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<FeedState> emit) async {
    try {
      await _deletePostUseCase(event.postId);

      final updatedPosts = state.posts
          .where((post) => post.id != event.postId)
          .toList();
      final updatedComments = Map<String, List<Comment>>.from(state.comments);
      updatedComments.remove(event.postId);

      emit(state.copyWith(posts: updatedPosts, comments: updatedComments));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onLikePost(LikePost event, Emitter<FeedState> emit) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final updatedPost = await _likePostUseCase(event.postId, currentUser.uid);

      final updatedPosts = state.posts.map((post) {
        return post.id == event.postId ? updatedPost : post;
      }).toList();

      emit(state.copyWith(posts: updatedPosts));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onUnlikePost(UnlikePost event, Emitter<FeedState> emit) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final updatedPost = await _unlikePostUseCase(
        event.postId,
        currentUser.uid,
      );

      final updatedPosts = state.posts.map((post) {
        return post.id == event.postId ? updatedPost : post;
      }).toList();

      emit(state.copyWith(posts: updatedPosts));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final comments = await _getCommentsUseCase(event.postId);

      final updatedComments = Map<String, List<Comment>>.from(state.comments);
      updatedComments[event.postId] = comments;

      emit(state.copyWith(comments: updatedComments));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onAddComment(AddComment event, Emitter<FeedState> emit) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final comment = await _addCommentUseCase(
        postId: event.postId,
        text: event.text,
        userId: currentUser.uid,
        userEmail: currentUser.email ?? '',
      );

      final updatedComments = Map<String, List<Comment>>.from(state.comments);
      final postComments = List<Comment>.from(
        updatedComments[event.postId] ?? [],
      );
      postComments.add(comment);
      updatedComments[event.postId] = postComments;

      final updatedPosts = state.posts.map((post) {
        if (post.id == event.postId) {
          return Post(
            id: post.id,
            userId: post.userId,
            userEmail: post.userEmail,
            imageUrl: post.imageUrl,
            caption: post.caption,
            createdAt: post.createdAt,
            updatedAt: post.updatedAt,
            likesCount: post.likesCount,
            commentsCount: post.commentsCount + 1,
            likedBy: post.likedBy,
          );
        }
        return post;
      }).toList();

      emit(state.copyWith(comments: updatedComments, posts: updatedPosts));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<FeedState> emit,
  ) async {
    try {
      await _deleteCommentUseCase(event.commentId);

      final updatedComments = Map<String, List<Comment>>.from(state.comments);
      String? postId;

      for (final data in updatedComments.entries) {
        final commentIndex = data.value.indexWhere(
          (c) => c.id == event.commentId,
        );
        if (commentIndex != -1) {
          postId = data.key;
          final postComments = List<Comment>.from(data.value);
          postComments.removeAt(commentIndex);
          updatedComments[data.key] = postComments;
          break;
        }
      }

      List<Post> updatedPosts = state.posts;
      if (postId != null) {
        updatedPosts = state.posts.map((post) {
          if (post.id == postId) {
            return Post(
              id: post.id,
              userId: post.userId,
              userEmail: post.userEmail,
              imageUrl: post.imageUrl,
              caption: post.caption,
              createdAt: post.createdAt,
              updatedAt: post.updatedAt,
              likesCount: post.likesCount,
              commentsCount: post.commentsCount - 1,
              likedBy: post.likedBy,
            );
          }
          return post;
        }).toList();
      }

      emit(state.copyWith(comments: updatedComments, posts: updatedPosts));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
