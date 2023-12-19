import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPicker extends StatefulWidget {
  const CameraPicker({super.key});

  @override
  State<CameraPicker> createState() => _CameraPickerState();
}

class _CameraPickerState extends State<CameraPicker> {
  XFile? _image;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      XFile? selected = await imagePicker.pickImage(
        source: ImageSource.camera,
      );
      setState(() {
        _image = selected;
      });
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
