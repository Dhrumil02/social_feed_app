import 'dart:io';

import 'package:feed_app/app/core/utils/extensions/text_extensions.dart';
import 'package:feed_app/app/core/utils/extensions/theme_extension.dart';
import 'package:feed_app/app/core/utils/extensions/widget_extensions.dart';
import 'package:feed_app/app/core/utils/helpers/app_helper.dart';
import 'package:feed_app/app/export.dart';
import 'package:feed_app/app/features/feed/presentation/screen/widgets/image_source_button.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/feed_event.dart';

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
        title: const CustomText(AppStrings.createPost),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        elevation: 0,
        actions: [
          BlocConsumer<FeedBloc, FeedState>(
            listener: (context, state) {
              if (state.postActionStatus == Status.success) {
                context.pop();
                AppHelper.showToast(AppStrings.postUpdatedSuccessFully);
              } else if (state.postActionStatus == Status.failure) {
                AppHelper.showToast(
                  state.errorMessage ?? 'Failed to create post',
                );
              }

              setState(() {
                _isLoading = state.postActionStatus == Status.loading;
              });
            },
            builder: (context, state) {
              final canShare =
                  _selectedImage != null &&
                  _captionController.text.trim().isNotEmpty &&
                  !_isLoading;

              return Padding(
                padding: Spacing.only(right: AppSizes.s8),
                child: TextButton(
                  onPressed: canShare ? _createPost : null,
                  style: TextButton.styleFrom(
                    backgroundColor: canShare ? Colors.blue : Colors.grey[300],
                    foregroundColor: canShare ? Colors.white : Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s16,
                      vertical: AppSizes.s8,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: AppSizes.s16,
                          height: AppSizes.s16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : CustomText(
                          AppStrings.share,
                          style: context.bodyMedium.bold,
                        ),
                ),
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
              onTap: _isLoading ? null : _pickImage,
              child: Container(
                height: AppSizes.s300,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(AppSizes.s16),
                  border: Border.all(
                    color: _selectedImage != null
                        ? Colors.blue
                        : Colors.grey[300]!,
                    width: _selectedImage != null ? 2 : 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _selectedImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.s14),
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
                                borderRadius: BorderRadius.circular(
                                  AppSizes.s14,
                                ),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
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
                          AppSizes.vGap16,
                          CustomText(
                            AppStrings.tapToAddPhoto,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          AppSizes.vGap8,
                          CustomText(
                            AppStrings.chooseFromGallery,
                            style: TextStyle(
                              fontSize: AppSizes.s14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            AppSizes.vGap24,

            TextField(
              controller: _captionController,
              enabled: !_isLoading,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: AppStrings.writeCaption,
                hintText: 'Share what\'s on your mind',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                alignLabelWithHint: true,
                counterStyle: TextStyle(color: Colors.grey[600]),
              ),
              onChanged: (_) => setState(() {}),
            ),

            AppSizes.vGap24,

            if (_selectedImage != null || _captionController.text.isNotEmpty)
              Container(
                padding: Spacing.all(AppSizes.s12),
                decoration: BoxDecoration(
                  color:
                      _selectedImage != null &&
                          _captionController.text.trim().isNotEmpty
                      ? Colors.green[50]
                      : Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        _selectedImage != null &&
                            _captionController.text.trim().isNotEmpty
                        ? Colors.green[200]!
                        : Colors.orange[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedImage != null &&
                              _captionController.text.trim().isNotEmpty
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      color:
                          _selectedImage != null &&
                              _captionController.text.trim().isNotEmpty
                          ? Colors.green[700]
                          : Colors.orange[700],
                    ),
                    AppSizes.vGap8,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            _selectedImage != null &&
                                    _captionController.text.trim().isNotEmpty
                                ? 'Ready to share!'
                                : 'Complete your post',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.s14,
                              color:
                                  _selectedImage != null &&
                                      _captionController.text.trim().isNotEmpty
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                            ),
                          ),
                          AppSizes.vGap16,
                          CustomText(
                            _getStatusMessage(),
                            style: context.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            AppSizes.vGap16,
          ],
        ).padAll(AppSizes.s16),
      ),
    );
  }

  String _getStatusMessage() {
    if (_selectedImage == null && _captionController.text.trim().isEmpty) {
      return AppStrings.addAPhotoANdWriteCaption;
    } else if (_selectedImage == null) {
      return AppStrings.addPhotoToCompletePost;
    } else if (_captionController.text.trim().isEmpty) {
      return AppStrings.writeCaptionToCompleteYourPost;
    } else {
      return AppStrings.postIsReady;
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
          padding: Spacing.all(AppSizes.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.s40,
                height: AppSizes.s4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppSizes.vGap20,
              CustomText(
                AppStrings.selectImage,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              AppSizes.vGap20,
              Row(
                children: [
                  Expanded(
                    child: ImageSourceButton(
                      icon: Icons.photo_camera,
                      label: AppStrings.camera,
                      onTap: () {
                        Navigator.pop(context);
                        _getImage(ImageSource.camera);
                      },
                    ),
                  ),
                  AppSizes.hGap16,
                  Expanded(
                    child: ImageSourceButton(
                      icon: Icons.photo_library,
                      label: AppStrings.gallery,
                      onTap: () {
                        Navigator.pop(context);
                        _getImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              if (_selectedImage != null) ...[
                AppSizes.vGap16,
                SizedBox(
                  width: double.infinity,
                  child: ImageSourceButton(
                    icon: Icons.delete_outline,
                    label: AppStrings.removePhoto,
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
              AppSizes.vGap16,
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
      AppHelper.showToast('Failed to pick image: ${e.toString()}');
    }
  }

  void _createPost() {
    if (_selectedImage == null ||
        _captionController.text.trim().isEmpty ||
        _isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<FeedBloc>().add(
      CreatePost(
        caption: _captionController.text.trim(),
        imageFile: _selectedImage!,
      ),
    );
  }
}
