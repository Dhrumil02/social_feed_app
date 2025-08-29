import 'package:feed_app/app/export.dart';

abstract class FeedLocalDataSource {
  Future<void> cachePosts(List<PostModel> posts);

  Future<List<PostModel>> getCachedPosts();

  Future<void> cacheComments(String postId, List<CommentModel> comments);

  Future<List<CommentModel>> getCachedComments(String postId);

  Future<void> clearCache();
}

class FeedLocalDataSourceImpl implements FeedLocalDataSource {
  final Map<String, List<PostModel>> _postsCache = {};
  final Map<String, List<CommentModel>> _commentsCache = {};

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    _postsCache['posts'] = posts;
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    return _postsCache['posts'] ?? [];
  }

  @override
  Future<void> cacheComments(String postId, List<CommentModel> comments) async {
    _commentsCache[postId] = comments;
  }

  @override
  Future<List<CommentModel>> getCachedComments(String postId) async {
    return _commentsCache[postId] ?? [];
  }

  @override
  Future<void> clearCache() async {
    _postsCache.clear();
    _commentsCache.clear();
  }
}
