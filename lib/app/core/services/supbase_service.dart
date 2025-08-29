import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../injection/injection_container.dart' show sl;

class SupabaseService {
  static final SupabaseClient _client = sl<SupabaseClient>();

  static const String _postImagesBucket = 'post_images';
  static const String _userImagesBucket = 'user_images';


  static Future<void> initializeBuckets() async {
    try {
      await createBucket(_postImagesBucket);
      await createBucket(_userImagesBucket);
      print('initializeBuckets: success');
    } catch (e) {
      print('initializeBuckets: $e');
    }
  }

  static Future<void> createBucket(String bucketName) async {
    try {
      final buckets = await _client.storage.listBuckets();
      final bucketExists = buckets.any((bucket) => bucket.name == bucketName);

      if (!bucketExists) {
        await _client.storage.createBucket(
          bucketName,
          BucketOptions(
            public: true,
            allowedMimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
            fileSizeLimit: (5 * 1024 * 1024).toString(),
          ),
        );
      }
    } catch (e) {
      print('createBucket: $bucketName: $e');
    }
  }

  static Future<String> uploadPostImage(File imageFile, String userId) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExtension = path.extension(imageFile.path).toLowerCase();
      final fileName = '${userId}_${const Uuid().v4()}$fileExtension';

      await _client.storage
          .from(_postImagesBucket)
          .uploadBinary(fileName, bytes);

      final publicUrl = _client.storage
          .from(_postImagesBucket)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('uploadPostImage: $e');
    }
  }

  static Future<String> uploadUserImage(File imageFile, String userId) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExtension = path.extension(imageFile.path).toLowerCase();
      final fileName = '$userId$fileExtension';

      try {
        await _client.storage
            .from(_userImagesBucket)
            .remove([fileName]);
      } catch (e) {

      }

      await _client.storage
          .from(_userImagesBucket)
          .uploadBinary(fileName, bytes);

      final publicUrl = _client.storage
          .from(_userImagesBucket)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('uploadUserImage: $e');
    }
  }

  static Future<void> deletePostImage(String imageUrl) async {
    try {
      final fileName = getFileName(imageUrl);
      if (fileName != null) {
        await _client.storage
            .from(_postImagesBucket)
            .remove([fileName]);
      }
    } catch (e) {
      print('deletePostImage: $e');
    }
  }

  static Future<void> deleteUserImage(String imageUrl) async {
    try {
      final fileName = getFileName(imageUrl);
      if (fileName != null) {
        await _client.storage
            .from(_userImagesBucket)
            .remove([fileName]);
      }
    } catch (e) {
      print('deleteUserImage: $e');
    }
  }

  static String? getFileName(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      return segments.isNotEmpty ? segments.last : null;
    } catch (e) {
      return null;
    }
  }
}
