import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:lakasir/utils/colors.dart';

typedef MyCallback = void Function(String?);

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({
    super.key,
    required this.onImageSelected,
    this.source = image_picker.ImageSource.camera,
    this.maxSize = 1000000,
    this.usingDynamicSource = false,
    this.defaultImage = '',
    this.usingLocalImage = false,
    this.maxWidth,
    this.maxHeight,
  });
  final bool usingLocalImage;
  final MyCallback onImageSelected;
  final image_picker.ImageSource source;
  final int? maxSize;
  final int? maxWidth;
  final int? maxHeight;
  final bool usingDynamicSource;
  final String defaultImage;

  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  image_picker.XFile? _image;
  final image_picker.ImagePicker imagePicker = image_picker.ImagePicker();
  image_picker.ImageSource? dynamicSource;

  Future<String> _saveAndCompressImageLocally(String filePath) async {
    try {
      final File imageFile = File(filePath);
      final bytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) return filePath; // fallback to original path

      // Resize if width > 512 pixels for better offline performance
      img.Image processedImage = image;
      if (image.width > 512) {
        final int newHeight = (image.height * 512 / image.width).round();
        processedImage = img.copyResize(image, width: 512, height: newHeight);
      }

      // Encode as JPEG with quality 70 for compression
      final compressedBytes = img.encodeJpg(processedImage, quality: 70);

      // Save to app documents directory
      final dir = await getApplicationDocumentsDirectory();
      final String fileName =
          'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savedPath = '${dir.path}/$fileName';
      final File savedFile = File(savedPath);
      await savedFile.writeAsBytes(compressedBytes);

      return savedPath;
    } catch (e) {
      debugPrint('Error saving image locally: $e');
      return filePath; // fallback to original path
    }
  }

  Future<void> _pickImage() async {
    try {
      image_picker.XFile? selected = await imagePicker.pickImage(
        source: dynamicSource!,
        imageQuality: 50,
      );

      if (selected == null) {
        return;
      }

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: selected.path,
        maxWidth: widget.maxWidth,
        maxHeight: widget.maxHeight,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) {
        return;
      }

      setState(() {
        _image = image_picker.XFile(croppedFile.path);
      });

      // Save and compress image locally for offline use
      String localPath = await _saveAndCompressImageLocally(croppedFile.path);
      widget.onImageSelected(localPath);
    } catch (e) {
      Get.rawSnackbar(
        title: 'Error',
        message: e.toString(),
        backgroundColor: error,
      );
      debugPrint(e.toString());
    }
  }

  void getImageSource() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20),
      title: 'global_select_image_source'.tr,
      content: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text('global_camera'.tr),
            onTap: () {
              setState(() {
                dynamicSource = image_picker.ImageSource.camera;
              });
              _pickImage();
              Get.back();
            },
          ),
          ListTile(
            title: Text('global_gallery'.tr),
            leading: const Icon(Icons.photo),
            onTap: () {
              setState(() {
                dynamicSource = image_picker.ImageSource.gallery;
              });
              _pickImage();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (widget.usingDynamicSource) {
            getImageSource();
          } else {
            setState(() {
              dynamicSource = widget.source;
            });
            _pickImage();
          }
        },
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(_image!.path),
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.fitHeight,
                  ),
                )
              : widget.defaultImage != ''
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _buildImage(widget.defaultImage),
                    )
                  : SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    // Check if it's a local file path
    if (imageUrl.startsWith('/') || imageUrl.startsWith('file://')) {
      return Image.file(
        File(imageUrl.replaceAll('file://', '')),
        width: 50.0,
        height: 50.0,
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/no-image-100.png',
            fit: BoxFit.cover,
          );
        },
      );
    }
    // Network image
    return Image.network(
      imageUrl,
      width: 50.0,
      height: 50.0,
      fit: BoxFit.fitHeight,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/no-image-100.png',
          fit: BoxFit.cover,
        );
      },
    );
  }
}