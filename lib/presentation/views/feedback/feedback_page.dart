import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:load_control/utils/colors.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    debugPrint("Gönder butonuna basıldı");
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geri Bildirim Gönderildi!'),
          backgroundColor: AppColors.searcColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("FeedbackPage build çağrıldı");
    return Scaffold(
      backgroundColor: AppColors.generalBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.snackBarRed,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.whiteSpot),
          onPressed: () {
            debugPrint("Geri butonuna basıldı");
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          "assets/tgs.png",
          height: 100,
          width: 100,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Geri Bildirim",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.borderColor),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _nameController,
                        hintText: "Adınız",
                        validator: (value) => value!.isEmpty ? "Adınızı giriniz" : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _surnameController,
                        hintText: "Soyadınız",
                        validator: (value) => value!.isEmpty ? "Soyadınızı giriniz" : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        hintText: "E-posta Adresiniz",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return "E-posta giriniz";
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return "Geçerli bir e-posta giriniz";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _feedbackController,
                        hintText: "Lütfen geri bildiriminizi yazın...",
                        maxLines: 6,
                        validator: (value) => value!.isEmpty ? "Geri bildirim giriniz" : null,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitFeedback,
        backgroundColor: AppColors.snackBarRed,
        icon: const Icon(FeatherIcons.send, color: AppColors.whiteSpot),
        label: const Text(
          "Gönder",
          style: TextStyle(
            color: AppColors.whiteSpot,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.greenSpot, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
    );
  }
}
