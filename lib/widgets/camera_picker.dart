import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:lakasir/utils/auth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import MediaType from http_parser package

typedef MyCallback = void Function(String?);

class CameraPicker extends StatefulWidget {
  const CameraPicker({super.key, required this.onImageSelected});
  final MyCallback onImageSelected;

  @override
  State<CameraPicker> createState() => _CameraPickerState();
}

class _CameraPickerState extends State<CameraPicker> {
  XFile? _image;
  final ImagePicker imagePicker = ImagePicker();

  Future<String> _uploadImage(File? selectedImage) async {
    if (selectedImage == null) {
      // Handle case when no image is selected
      throw Exception('No image selected');
    }

    final url = Uri.parse('${await getDomain()}/temp/upload');
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer ${await getToken()}',
    });

    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      selectedImage.path,
      contentType: MediaType('image', 'jpeg'), // Adjust the content type based on your image format
    ));

    // Send the request
    final response = await request.send();

    // Check the response
    if (response.statusCode == 200) {
      // Image uploaded successfully
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody)['data']['url'];
    } else {
      // Handle error
      throw Exception('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<void> _pickImage() async {
    try {
      XFile? selected = await imagePicker.pickImage(
        source: ImageSource.camera,
      );
      setState(() {
        _image = selected;
      });
      String url = await _uploadImage(File(selected!.path));
      widget.onImageSelected(url);
    } catch (e) {
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
