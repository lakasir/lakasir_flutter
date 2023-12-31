import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'dart:convert';
import 'package:lakasir/utils/auth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
  });
  final MyCallback onImageSelected;
  final image_picker.ImageSource source;
  final int? maxSize;
  final bool usingDynamicSource;
  final String defaultImage;

  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  image_picker.XFile? _image;
  final image_picker.ImagePicker imagePicker = image_picker.ImagePicker();
  image_picker.ImageSource? dynamicSource;

  Future<String> _uploadImage(File? selectedImage) async {
    if (selectedImage == null) {
      throw Exception('No image selected');
    }

    if (selectedImage.lengthSync() > widget.maxSize!) {
      throw Exception('Image size is too large');
    }

    final url = Uri.parse('${await getDomain()}/temp/upload');
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer ${await getToken()}',
    });

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      selectedImage.path,
      contentType: MediaType('png', 'jpeg'),
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      return jsonDecode(responseBody)['data']['url'];
    } else {
      throw Exception(
          'Failed to upload image. Status code: ${response.statusCode}');
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
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
        ],
      );
      setState(() {
        _image = image_picker.XFile(croppedFile!.path);
      });
      String url = await _uploadImage(File(croppedFile!.path));
      widget.onImageSelected(url);
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
      title: 'Select Image Source',
      content: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              setState(() {
                dynamicSource = image_picker.ImageSource.camera;
              });
              _pickImage();
              Get.back();
            },
          ),
          ListTile(
            title: const Text('Gallery'),
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
                      child: Image.network(
                        widget.defaultImage,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.fitHeight,
                      ),
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
}
