import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:load_control/presentation/views/flight_record_listview/flight_record_list_view.dart';
import 'package:load_control/utils/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.generalBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/tgs.png",
                    height: 200,
                    width: 200,
                  ),
                  Text(
                    "KONTROL SİSTEMİ",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 40),
                  buildAvatar(),
                  const SizedBox(height: 40),
                  buildForm(context, screenWidth),
                  const SizedBox(height: 20),
                  _buildFooter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAvatar() {
    return Hero(
      tag: 'login-avatar',
      child: CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.snackBarRed.withOpacity(0.1),
        child: const Icon(
          FeatherIcons.user,
          size: 80,
          color: AppColors.snackBarRed,
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context, double screenWidth) {
    return _LoginForm(screenWidth: screenWidth);
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Text(
        "TURKISH GROUND SERVICES",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  final double screenWidth;

  const _LoginForm({required this.screenWidth});

  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen Tüm Alanları Doldurunuz!"),
          backgroundColor: AppColors.greenSpot,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLogin ? "Giriş başarılı " : "Kayıt başarılı (Demo)"),
        backgroundColor: AppColors.snackBarGreen,
      ),
    );

    if (_isLogin) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const FlightRecordListView(
                  email: '',
                )),
      );
    } else {
      setState(() {
        _isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "E-posta",
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.greenSpot, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Şifre",
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.greenSpot, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _submit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.snackBarRed,
            foregroundColor: Colors.white,
            minimumSize: Size(widget.screenWidth * 0.8, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          child: Text(
            _isLogin ? "Giriş Yap" : "Kayıt Ol",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
