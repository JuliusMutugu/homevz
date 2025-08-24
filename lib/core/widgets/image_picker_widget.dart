import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_upload_service.dart';

class ImagePickerWidget extends StatefulWidget {
  final List<File> initialImages;
  final int maxImages;
  final double itemHeight;
  final bool allowMultiple;
  final Function(List<File>) onImagesChanged;
  final String? title;
  final String? subtitle;

  const ImagePickerWidget({
    super.key,
    this.initialImages = const [],
    this.maxImages = 10,
    this.itemHeight = 120,
    this.allowMultiple = true,
    required this.onImagesChanged,
    this.title,
    this.subtitle,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<File> _selectedImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedImages = List.from(widget.initialImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
        ],
        if (widget.subtitle != null) ...[
          Text(
            widget.subtitle!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
        ],
        _buildImageSection(),
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (_selectedImages.isEmpty) ...[
            _buildEmptyState(),
          ] else ...[
            _buildImageGrid(),
            const SizedBox(height: 16),
          ],
          if (_selectedImages.length < widget.maxImages) ...[
            _buildAddImageButton(),
          ],
          if (_isLoading) ...[
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 40,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photos',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to select from camera or gallery',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          _selectedImages.asMap().entries.map((entry) {
            final index = entry.key;
            final image = entry.value;
            return _buildImageItem(image, index);
          }).toList(),
    );
  }

  Widget _buildImageItem(File image, int index) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return OutlinedButton.icon(
      onPressed: _showImageSourceDialog,
      icon: const Icon(Icons.add),
      label: Text(
        widget.allowMultiple
            ? 'Add More Photos (${_selectedImages.length}/${widget.maxImages})'
            : 'Add Photo',
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    final source = await showDialog<dynamic>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                if (widget.allowMultiple &&
                    _selectedImages.length < widget.maxImages)
                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined),
                    title: const Text('Multiple from Gallery'),
                    onTap: () => Navigator.pop(context, 'multiple'),
                  ),
              ],
            ),
          ),
    );

    if (source != null) {
      if (source is String && source == 'multiple') {
        await _pickMultipleImages();
      } else if (source is ImageSource) {
        await _pickSingleImage(source);
      }
    }
  }

  Future<void> _pickSingleImage(ImageSource source) async {
    setState(() => _isLoading = true);

    try {
      final file = await ImageUploadService.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (file != null) {
        if (ImageUploadService.isValidImage(file)) {
          if (ImageUploadService.isFileSizeValid(file, maxSizeMB: 5.0)) {
            if (widget.allowMultiple) {
              setState(() {
                _selectedImages.add(file);
              });
            } else {
              setState(() {
                _selectedImages = [file];
              });
            }
            widget.onImagesChanged(_selectedImages);
          } else {
            _showErrorSnackBar('Image size should be less than 5MB');
          }
        } else {
          _showErrorSnackBar('Please select a valid image file');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickMultipleImages() async {
    setState(() => _isLoading = true);

    try {
      final remainingSlots = widget.maxImages - _selectedImages.length;
      final files = await ImageUploadService.pickMultipleImages(
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
        maxImages: remainingSlots,
      );

      if (files.isNotEmpty) {
        final validFiles = <File>[];

        for (final file in files) {
          if (ImageUploadService.isValidImage(file)) {
            if (ImageUploadService.isFileSizeValid(file, maxSizeMB: 5.0)) {
              validFiles.add(file);
            } else {
              _showErrorSnackBar('Some images were skipped (size > 5MB)');
            }
          } else {
            _showErrorSnackBar('Some invalid image files were skipped');
          }
        }

        if (validFiles.isNotEmpty) {
          setState(() {
            _selectedImages.addAll(validFiles);
          });
          widget.onImagesChanged(_selectedImages);
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick images: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesChanged(_selectedImages);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

class ProfileImagePicker extends StatefulWidget {
  final File? initialImage;
  final String? initialImageUrl;
  final Function(File?) onImageChanged;
  final double size;

  const ProfileImagePicker({
    super.key,
    this.initialImage,
    this.initialImageUrl,
    required this.onImageChanged,
    this.size = 120,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Stack(
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ClipOval(
                      child:
                          _selectedImage != null
                              ? Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: widget.size,
                                height: widget.size,
                              )
                              : widget.initialImageUrl != null &&
                                  widget.initialImageUrl!.isNotEmpty
                              ? Image.network(
                                widget.initialImageUrl!,
                                fit: BoxFit.cover,
                                width: widget.size,
                                height: widget.size,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        _buildPlaceholder(),
                              )
                              : _buildPlaceholder(),
                    ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Icon(Icons.person, size: widget.size * 0.6, color: Colors.grey);
  }

  Future<void> _showImageSourceDialog() async {
    final source = await ImageUploadService.showImageSourceDialog(context);
    if (source != null) {
      await _pickImage(source);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);

    try {
      final file = await ImageUploadService.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (file != null) {
        if (ImageUploadService.isValidImage(file)) {
          if (ImageUploadService.isFileSizeValid(file, maxSizeMB: 3.0)) {
            setState(() {
              _selectedImage = file;
            });
            widget.onImageChanged(file);
          } else {
            _showErrorSnackBar('Image size should be less than 3MB');
          }
        } else {
          _showErrorSnackBar('Please select a valid image file');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
