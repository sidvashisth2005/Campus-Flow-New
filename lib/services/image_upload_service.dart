import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageUploadService {
  // TODO: Replace with your Cloudinary cloud name and unsigned upload preset
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String uploadPreset = 'YOUR_UNSIGNED_UPLOAD_PRESET';

  /// Uploads an image file to Cloudinary and returns the image URL.
  /// Throws an exception if upload fails.
  Future<String> uploadImage(File imageFile) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      return data['secure_url'];
    } else {
      final respStr = await response.stream.bytesToString();
      throw Exception('Image upload failed: ${response.statusCode} $respStr');
    }
  }
}

/// Usage:
/// final url = await ImageUploadService().uploadImage(file); 