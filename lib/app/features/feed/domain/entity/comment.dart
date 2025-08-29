class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userEmail;
  final String text;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userEmail,
    required this.text,
    required this.createdAt,
  });
}