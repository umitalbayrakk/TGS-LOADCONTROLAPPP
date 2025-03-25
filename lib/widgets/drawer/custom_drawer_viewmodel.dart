import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawerViewModel {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  File? get image => _image;

  // Sharred ile Kaydedilen resmin ölçülmesi.
  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString('profile_image_path');
    if (savedImagePath != null && File(savedImagePath).existsSync()) {
      _image = File(savedImagePath);
    }
  }

  // Resmi Kaydetmek İçin
  Future<void> _saveImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
  }

  // Galeriye Gitmek için
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print("Resim seçildi: ${pickedFile.path}");
      await _saveImage(pickedFile.path); // Save the image path
    } else {
      print("Resim seçilmedi.");
    }
  }

  // Logout işlemi için
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Tüm SharedPreferences verilerini temizle
  }
}
