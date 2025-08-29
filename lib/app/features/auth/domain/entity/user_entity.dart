import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? phone;
  final String? name;
  final String? bio;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.uid,
    this.email,
    this.phone,
    this.name,
    this.bio,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    phone,
    name,
    bio,
    imageUrl,
    createdAt,
    updatedAt,
  ];
}