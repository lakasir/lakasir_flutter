import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:lakasir/models/uploaded_file.dart';
import 'package:lakasir/utils/auth.dart';

class UploadService {
  Future<UploadedFile> uploadImage(File image) async {
    final url = Uri.parse('${await getDomain()}/temp/upload');
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer ${await getToken()}',
    });

    final ext = image.path.split('.').last.toLowerCase();
    const subtypeMap = {
      'png': 'png',
      'jpg': 'jpeg',
      'jpeg': 'jpeg',
      'gif': 'gif',
      'webp': 'webp',
      'bmp': 'bmp',
    };
    final subtype = subtypeMap[ext] ?? 'jpeg';
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType('image', subtype),
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return UploadedFile.fromJson(jsonDecode(responseBody)['data']);
    } else {
      throw Exception(
          'Failed to upload image. Status code: ${response.statusCode}');
    }
  }
}