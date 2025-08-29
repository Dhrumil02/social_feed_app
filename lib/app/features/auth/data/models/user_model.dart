import 'package:feed_app/app/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.email,
    super.phone,
    super.name,
    super.bio,
    super.imageUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'],
      phone: json['phone'],
      name: json['name'],
      bio: json['bio'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'name': name,
      'bio': bio,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? phone,
    String? name,
    String? bio,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}