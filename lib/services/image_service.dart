import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static Future<String> saveImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = File('${directory.path}/$fileName');

    if (await savedImage.exists()) {
      await savedImage.delete();
    }

    await imageFile.copy(savedImage.path);
    return savedImage.path;
  }

  static Future<void> deleteImage(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
