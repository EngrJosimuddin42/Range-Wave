import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../color/app_colors.dart';

/// ===============================
/// IMAGE UPLOADER WIDGET
/// ===============================
class ImageUploaderVOne extends StatefulWidget {
  final double height;
  final String? defaultImage;
  final String? currentImage;
  final bool enable;
  final bool loading;
  final bool showBorder;
  final void Function(File)? onImageSelected;
  final File? selectedImage;

  const ImageUploaderVOne({
    super.key,
    this.enable = true,
    this.defaultImage,
    this.currentImage,
    this.onImageSelected,
    this.height = 120,
    this.loading = false,
    this.showBorder = false,
    this.selectedImage,
  });

  @override
  State<ImageUploaderVOne> createState() => _ImageUploaderVOneState();
}

class _ImageUploaderVOneState extends State<ImageUploaderVOne> {
  File? _imageFile;
  Uint8List? _imageData;

  /// pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? file = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (file == null) return;

      final imgFile = File(file.path);
      final bytes = await imgFile.readAsBytes();

      setState(() {
        _imageFile = imgFile;
        _imageData = bytes;
      });

      widget.onImageSelected?.call(imgFile);
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  /// bottom sheet (camera / gallery)
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.blueish,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant ImageUploaderVOne oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedImage != null) {
      widget.selectedImage!.readAsBytes().then((bytes) {
        setState(() {
          _imageFile = widget.selectedImage;
          _imageData = bytes;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.height,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (!widget.enable || widget.loading) return;
              _showPickerOptions();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffEFEEF9),
                border: widget.showBorder
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.height / 2),
                child: _imageData != null
                    ? Image.memory(_imageData!, fit: BoxFit.cover)
                    : widget.currentImage != null
                    ? SvgPicture.asset(widget.currentImage!, fit: BoxFit.cover)
                    : Center(
                        child: widget.defaultImage != null && widget.defaultImage!.isNotEmpty
                            ? SvgPicture.asset(
                                widget.defaultImage!,
                                width: widget.height * .6,
                                height: widget.height * .6,
                                color: Colors.grey,
                                errorBuilder: (_, __, ___) {
                                  return const Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.grey,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.grey,
                              ),
                      ),
              ),
            ),
          ),

          /// loading overlay
          if (widget.loading)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.3),
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),

          /// edit icon
          if (widget.enable)
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  if (!widget.loading) _showPickerOptions();
                },
                child: Container(
                  width: widget.height * .28,
                  height: widget.height * .28,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
