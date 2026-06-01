import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';

typedef MyCallback = void Function(dynamic);
typedef MyLocalCallback = void Function(String?);

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({
    super.key,
    this.onImageSelected,
    this.source = image_picker.ImageSource.camera,
    this.maxSize = 1000000,
    this.usingDynamicSource = false,
    this.defaultImage = '',
    this.usingLocalImage = false,
    this.maxWidth,
    this.maxHeight,
    this.onLocalImageSelected,
    this.onUploadComplete,
  })  : assert(
          !usingLocalImage || onLocalImageSelected != null,
          'onLocalImageSelected is required when usingLocalImage is true',
        ),
        assert(
          usingLocalImage || onImageSelected != null,
          'onImageSelected is required when usingLocalImage is false',
        );
  final bool usingLocalImage;
  final MyCallback? onImageSelected;
  final MyLocalCallback? onLocalImageSelected;
  final Function(String path)? onUploadComplete;
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
      if (image == null) return filePath;

      img.Image processedImage = image;
      if (image.width > 512) {
        final int newHeight = (image.height * 512 / image.width).round();
        processedImage = img.copyResize(image, width: 512, height: newHeight);
      }

      final compressedBytes = img.encodeJpg(processedImage, quality: 70);

      final dir = await getApplicationDocumentsDirectory();
      final String fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savedPath = '${dir.path}/$fileName';
      final File savedFile = File(savedPath);
      await savedFile.writeAsBytes(compressedBytes);

      return savedPath;
    } catch (e) {
      debugPrint('Error saving image locally: $e');
      return filePath;
    }
  }

  Future<void> _pickImage() async {
    try {
      image_picker.XFile? selected = await imagePicker.pickImage(
        source: dynamicSource!,
        imageQuality: 50,
      );

      if (selected == null) return;

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
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [CropAspectRatioPreset.square],
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) return;

      if (widget.maxSize != null) {
        final fileSize = await File(croppedFile.path).length();
        if (fileSize > widget.maxSize!) {
          show('image_too_large'.tr, color: error);
          return;
        }
      }

      setState(() {
        _image = image_picker.XFile(croppedFile.path);
      });

      final String localPath = await _saveAndCompressImageLocally(croppedFile.path);

      if (widget.usingLocalImage) {
        widget.onLocalImageSelected?.call(localPath);
        return;
      }

      widget.onImageSelected?.call(localPath);
      widget.onUploadComplete?.call(localPath);
    } catch (e) {
      show(e.toString(), color: error);
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
              setState(() => dynamicSource = image_picker.ImageSource.camera);
              _pickImage();
              Get.back();
            },
          ),
          ListTile(
            title: Text('global_gallery'.tr),
            leading: const Icon(Icons.photo),
            onTap: () {
              setState(() => dynamicSource = image_picker.ImageSource.gallery);
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
            setState(() => dynamicSource = widget.source);
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
              : widget.defaultImage.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _buildImage(widget.defaultImage),
                    )
                  : SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.camera_alt, color: Colors.grey[800]),
                    ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('/') || imageUrl.startsWith('file://')) {
      return Image.file(
        File(imageUrl.replaceAll('file://', '')),
        width: 50.0,
        height: 50.0,
        fit: BoxFit.fitHeight,
        errorBuilder: (_, __, ___) => Image.asset('assets/no-image-100.png', fit: BoxFit.cover),
      );
    }
    return Image.network(
      imageUrl,
      width: 50.0,
      height: 50.0,
      fit: BoxFit.fitHeight,
      errorBuilder: (_, __, ___) => Image.asset('assets/no-image-100.png', fit: BoxFit.cover),
    );
  }
}