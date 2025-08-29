import 'dart:io';

import 'package:feed_app/app/core/utils/extensions/widget_extensions.dart';
import 'package:feed_app/app/core/utils/helpers/app_helper.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/features/feed/domain/entity/post.dart';
import 'package:feed_app/app/features/feed/presentation/bloc/feed_event.dart';
import 'package:image_picker/image_picker.dart';

class EditPostScreen extends StatefulWidget {
  final Post post;

  const EditPostScreen({super.key, required this.post});

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
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        title: CustomText(AppStrings.editPost),
        actions: [
          BlocConsumer<FeedBloc, FeedState>(
            listener: (context, state) {
              if (state.postActionStatus == Status.success) {
                context.pop();
                AppHelper.showToast(AppStrings.postUpdatedSuccessFully);
              } else if (state.postActionStatus == Status.failure) {
                AppHelper.showToast(
                  state.errorMessage ?? 'Failed to update post',
                );
              }

              setState(() {
                _isLoading = state.postActionStatus == Status.loading;
              });
            },
            builder: (context, state) {
              return TextButton(
                onPressed:
                    (_captionController.text.trim().isNotEmpty && !_isLoading)
                    ? _updatePost
                    : null,
                child: _isLoading
                    ? SizedBox(
                        width: AppSizes.s16,
                        height: AppSizes.s16,
                        child: CircularProgressIndicator(
                          strokeWidth: AppSizes.s2,
                        ),
                      )
                    : CustomText(AppStrings.save),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: AppSizes.s300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _newImage != null
                          ? Image.file(_newImage!, fit: BoxFit.cover)
                          : Image.network(
                              widget.post.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.error));
                              },
                            ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: Spacing.all(8),
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

            AppSizes.vGap24,

            TextField(
              controller: _captionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: AppStrings.caption,
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              onChanged: (_) => setState(() {}),
            ),

            AppSizes.vGap16,

          ],
        ),
      ).padAll(AppSizes.s16),
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
              title: CustomText(AppStrings.camera),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: CustomText(AppStrings.gallery),
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
      AppHelper.showToast('Failed to pick image: $e');
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
