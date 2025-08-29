import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_app/app/features/feed/domain/entity/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    required super.userEmail,
    required super.imageUrl,
    required super.caption,
    required super.createdAt,
    required super.updatedAt,
    required super.likesCount,
    required super.commentsCount,
    required super.likedBy,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userEmail: json['userEmail'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      caption: json['caption'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'imageUrl': imageUrl,
      'caption': caption,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'likedBy': likedBy,
    };
  }

  PostModel copyWith({
    String? id,
    String? userId,
    String? userEmail,
    String? imageUrl,
    String? caption,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
    List<String>? likedBy,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}