class Post {
  final String id;
  final String userId;
  final String userEmail;
  final String imageUrl;
  final String caption;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;
  final List<String> likedBy;

  const Post({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.likedBy,
  });
}
