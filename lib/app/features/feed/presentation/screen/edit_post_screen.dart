import 'dart:io';

import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/features/feed/domain/entity/post.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_event.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_state.dart';
import 'package:feed_app/app/features/feed/presentation/screen/widgets/post_card.dart';
import 'package:image_picker/image_picker.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;

  const EditPostScreen({
    super.key,
    required this.post,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _captionController;
  final _imagePicker = ImagePicker();
  File? _newImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.post.caption);
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        actions: [
          BlocConsumer<FeedBloc, FeedState>(
            listener: (context, state) {
              if (state.postActionStatus == Status.success) {
                GoRouter.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state.postActionStatus == Status.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Failed to update post'),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              setState(() {
                _isLoading = state.postActionStatus == Status.loading;
              });
            },
            builder: (context, state) {
              return TextButton(
                onPressed: (_captionController.text.trim().isNotEmpty && !_isLoading)
                    ? _updatePost
                    : null,
                child: _isLoading
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Save'),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current/New Image
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _newImage != null
                          ? Image.file(_newImage!, fit: BoxFit.cover)
                          : Image.network(
                        widget.post.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Caption input
            TextField(
              controller: _captionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Caption',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 16),

            // Show if image will be updated
            if (_newImage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'New image selected. It will replace the current image.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _newImage = null;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _newImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updatePost() {
    if (_captionController.text.trim().isEmpty) return;

    context.read<FeedBloc>().add(
      UpdatePost(
        postId: widget.post.id,
        caption: _captionController.text.trim(),
        newImageFile: _newImage,
      ),
    );
  }
}