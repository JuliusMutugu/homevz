import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageDisplayWidget extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableZoom;
  final VoidCallback? onTap;

  const ImageDisplayWidget({
    Key? key,
    this.imageUrl,
    this.imageFile,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.enableZoom = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return _buildFileImage();
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return _buildNetworkImage();
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildFileImage() {
    return GestureDetector(
      onTap: enableZoom ? () => _showFullImage() : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: FileImage(imageFile!),
            fit: fit,
            onError:
                (error, stackTrace) =>
                    debugPrint('Error loading file image: $error'),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage() {
    return GestureDetector(
      onTap: enableZoom ? () => _showFullImage() : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl!,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildPlaceholder();
            },
            errorBuilder: (context, error, stackTrace) {
              return errorWidget ?? _buildErrorWidget();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.image, color: Colors.grey, size: 40),
          ),
        );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.error_outline, color: Colors.red, size: 40),
      ),
    );
  }

  void _showFullImage() {
    if (imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty)) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder:
              (context) =>
                  FullImageViewer(imageUrl: imageUrl, imageFile: imageFile),
        ),
      );
    }
  }
}

class ImageGalleryWidget extends StatelessWidget {
  final List<String> imageUrls;
  final List<File> imageFiles;
  final double itemHeight;
  final bool enableZoom;
  final Function(int)? onImageTap;
  final Function(int)? onImageRemove;

  const ImageGalleryWidget({
    Key? key,
    this.imageUrls = const [],
    this.imageFiles = const [],
    this.itemHeight = 120,
    this.enableZoom = true,
    this.onImageTap,
    this.onImageRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalImages = imageUrls.length + imageFiles.length;

    if (totalImages == 0) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalImages,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      index < imageFiles.length
                          ? ImageDisplayWidget(
                            imageFile: imageFiles[index],
                            width: itemHeight,
                            height: itemHeight,
                            enableZoom: enableZoom,
                            onTap: () => onImageTap?.call(index),
                          )
                          : ImageDisplayWidget(
                            imageUrl: imageUrls[index - imageFiles.length],
                            width: itemHeight,
                            height: itemHeight,
                            enableZoom: enableZoom,
                            onTap: () => onImageTap?.call(index),
                          ),
                ),
                if (onImageRemove != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => onImageRemove?.call(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FullImageViewer extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final List<String>? imageUrls;
  final List<File>? imageFiles;
  final int initialIndex;

  const FullImageViewer({
    Key? key,
    this.imageUrl,
    this.imageFile,
    this.imageUrls,
    this.imageFiles,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalImages = (imageUrls?.length ?? 0) + (imageFiles?.length ?? 0);

    if (totalImages > 1 ||
        (imageUrls != null && imageUrls!.isNotEmpty) ||
        (imageFiles != null && imageFiles!.isNotEmpty)) {
      return _buildGalleryView(context);
    } else {
      return _buildSingleImageView(context);
    }
  }

  Widget _buildSingleImageView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: PhotoView(
          imageProvider:
              imageFile != null
                  ? FileImage(imageFile!) as ImageProvider
                  : NetworkImage(imageUrl!),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
        ),
      ),
    );
  }

  Widget _buildGalleryView(BuildContext context) {
    final totalImages = (imageUrls?.length ?? 0) + (imageFiles?.length ?? 0);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${initialIndex + 1} of $totalImages',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: totalImages,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          ImageProvider imageProvider;

          if (imageFiles != null && index < imageFiles!.length) {
            imageProvider = FileImage(imageFiles![index]);
          } else if (imageUrls != null) {
            final urlIndex = index - (imageFiles?.length ?? 0);
            imageProvider = NetworkImage(imageUrls![urlIndex]);
          } else {
            imageProvider = const AssetImage('assets/images/placeholder.png');
          }

          return PhotoViewGalleryPageOptions(
            imageProvider: imageProvider,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
          );
        },
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}

// Global navigator key for accessing context from static methods
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
