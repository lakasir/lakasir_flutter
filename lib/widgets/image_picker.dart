import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'dart:convert';
import 'package:lakasir/utils/auth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:lakasir/utils/colors.dart'; // Import MediaType from http_parser package

typedef MyCallback = void Function(String?);

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({
    super.key,
    required this.onImageSelected,
    this.source = image_picker.ImageSource.camera,
    this.maxSize = 1000000,
  });
  final MyCallback onImageSelected;
  final image_picker.ImageSource source;
  final int? maxSize;

  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  image_picker.XFile? _image;
  final image_picker.ImagePicker imagePicker = image_picker.ImagePicker();

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
        source: widget.source,
      );
      setState(() {
        _image = selected;
      });
      String url = await _uploadImage(File(selected!.path));
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _pickImage();
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: _image != null
              ? Image.file(
                  File(_image!.path),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.fitHeight,
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
