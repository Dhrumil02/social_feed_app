
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: BackButton(onPressed: (){

        },),
        elevation: 0,
        actions: [
          BlocConsumer<FeedBloc, FeedState>(
            listener: (context, state) {
              if (state.postActionStatus == Status.success) {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post created successfully!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (state.postActionStatus == Status.failure) {
                print("FAILED ${state.errorMessage}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Failed to create post'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }

              setState(() {
                _isLoading = state.postActionStatus == Status.loading;
              });
            },
            builder: (context, state) {
              final canShare = _selectedImage != null &&
                  _captionController.text.trim().isNotEmpty &&
                  !_isLoading;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  onPressed: canShare ? _createPost : null,
                  style: TextButton.styleFrom(
                    backgroundColor: canShare ? Colors.blue : Colors.grey[300],
                    foregroundColor: canShare ? Colors.white : Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    'Share',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
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
            // Image selection area
            GestureDetector(
              onTap: _isLoading ? null : _pickImage,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedImage != null ? Colors.blue : Colors.grey[300]!,
                    width: _selectedImage != null ? 2 : 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _selectedImage != null
                    ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    if (!_isLoading)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: _pickImage,
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    if (_isLoading)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tap to add photo',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose from camera or gallery',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Caption input
            TextField(
              controller: _captionController,
              enabled: !_isLoading,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: 'Write a caption...',
                hintText: 'Share what\'s on your mind',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                alignLabelWithHint: true,
                counterStyle: TextStyle(color: Colors.grey[600]),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 24),

            // Post status indicator
            if (_selectedImage != null || _captionController.text.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedImage != null && _captionController.text.trim().isNotEmpty
                      ? Colors.green[50]
                      : Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedImage != null && _captionController.text.trim().isNotEmpty
                        ? Colors.green[200]!
                        : Colors.orange[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedImage != null && _captionController.text.trim().isNotEmpty
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      color: _selectedImage != null && _captionController.text.trim().isNotEmpty
                          ? Colors.green[700]
                          : Colors.orange[700],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedImage != null && _captionController.text.trim().isNotEmpty
                                ? 'Ready to share!'
                                : 'Complete your post',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _selectedImage != null && _captionController.text.trim().isNotEmpty
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStatusMessage(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }

  String _getStatusMessage() {
    if (_selectedImage == null && _captionController.text.trim().isEmpty) {
      return 'Add a photo and write a caption to share your post';
    } else if (_selectedImage == null) {
      return 'Add a photo to complete your post';
    } else if (_captionController.text.trim().isEmpty) {
      return 'Write a caption to complete your post';
    } else {
      return 'Your post is ready to be shared with everyone!';
    }
  }

  Future<void> _pickImage() async {
    if (_isLoading) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _ImageSourceButton(
                      icon: Icons.photo_camera,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _getImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ImageSourceButton(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _getImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _ImageSourceButton(
                    icon: Icons.delete_outline,
                    label: 'Remove Photo',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _createPost() {
    if (_selectedImage == null || _captionController.text.trim().isEmpty || _isLoading) {
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    context.read<FeedBloc>().add(
      CreatePost(
        caption: _captionController.text.trim(),
        imageFile: _selectedImage!,
      ),
    );
  }
}

// Helper Widgets

class _GuidelineItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isCompleted;

  const _GuidelineItem({
    required this.icon,
    required this.text,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : icon,
          color: isCompleted ? Colors.green : Colors.blue[600],
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isCompleted ? Colors.green[700] : Colors.blue[700],
              fontWeight: isCompleted ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ImageSourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Colors.blue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: buttonColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: buttonColor.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: buttonColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: buttonColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}