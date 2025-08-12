import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';  // Temporarily disabled
import 'package:dio/dio.dart';

class ImageUploadService {
  static final ImagePicker _picker = ImagePicker();
  static final Dio _dio = Dio();

  /// Pick image from gallery or camera
  static Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
    int? imageQuality = 80,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Pick multiple images
  static Future<List<File>> pickMultipleImages({
    int? imageQuality = 80,
    double? maxWidth,
    double? maxHeight,
    int maxImages = 10,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      // Limit the number of selected images
      final limitedImages = images.take(maxImages).toList();

      return limitedImages.map((image) => File(image.path)).toList();
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      return [];
    }
  }

  /// Pick documents/files
  static Future<List<File>> pickFiles({
    List<String>? allowedExtensions,
    String? type, // Changed from FileType to String to avoid import
    bool allowMultiple = false,
  }) async {
    try {
      // TODO: Implement file picker when compatibility is resolved
      if (kDebugMode) {
        print('File picker temporarily disabled due to compatibility issues');
      }
      return [];
      /*
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
      );

      if (result != null) {
        return result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();
      }
      return [];
      */
    } catch (e) {
      debugPrint('Error picking files: $e');
      return [];
    }
  }

  /// Upload image to server
  static Future<String?> uploadImage(
    File imageFile, {
    String endpoint = '/api/upload/image',
    String fieldName = 'image',
    Map<String, dynamic>? additionalData,
    Function(int, int)? onProgress,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
        if (additionalData != null) ...additionalData,
      });

      Response response = await _dio.post(
        'https://api.homevz.co.ke$endpoint',
        data: formData,
        onSendProgress: onProgress,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            // Add authentication headers here if needed
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['url'] as String?;
      }
      return null;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  /// Upload multiple images
  static Future<List<String>> uploadMultipleImages(
    List<File> imageFiles, {
    String endpoint = '/api/upload/images',
    String fieldName = 'images',
    Map<String, dynamic>? additionalData,
    Function(int, int)? onProgress,
  }) async {
    try {
      List<MultipartFile> multipartFiles = [];

      for (File file in imageFiles) {
        multipartFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }

      FormData formData = FormData.fromMap({
        fieldName: multipartFiles,
        if (additionalData != null) ...additionalData,
      });

      Response response = await _dio.post(
        'https://api.homevz.co.ke$endpoint',
        data: formData,
        onSendProgress: onProgress,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        return List<String>.from(response.data['urls'] ?? []);
      }
      return [];
    } catch (e) {
      debugPrint('Error uploading multiple images: $e');
      return [];
    }
  }

  /// Get image source choice (camera or gallery)
  static Future<ImageSource?> showImageSourceDialog(
    BuildContext context,
  ) async {
    return await showDialog<ImageSource>(
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
              ],
            ),
          ),
    );
  }

  /// Validate image file
  static bool isValidImage(File file) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final fileName = file.path.toLowerCase();

    return validExtensions.any((ext) => fileName.endsWith(ext));
  }

  /// Get file size in MB
  static double getFileSizeInMB(File file) {
    int sizeInBytes = file.lengthSync();
    return sizeInBytes / (1024 * 1024);
  }

  /// Check if file size is within limit
  static bool isFileSizeValid(File file, {double maxSizeMB = 5.0}) {
    return getFileSizeInMB(file) <= maxSizeMB;
  }
}
