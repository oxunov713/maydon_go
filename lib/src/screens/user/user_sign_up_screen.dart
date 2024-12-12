import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../style/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import 'log_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      print('First Name: $firstName');
      print('Last Name: $lastName');
      print('Phone: $phone');
      print('Password: $password');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup successful!'),
          backgroundColor: AppColors.green,
        ),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LogInScreen(),
          ));
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ro'yxatdan o'tish"),
        backgroundColor: AppColors.green,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LogInScreen(),
              ),
            ),
            child: Text(
              "Kirish",
              style:
                  TextStyle(color: AppColors.red, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(
                controller: _firstNameController,
                labelText: 'Ism',
                validator: (value) => value == null || value.isEmpty
                    ? 'Iltimos, ismingizni kiriting!'
                    : null,
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: _lastNameController,
                labelText: 'Familiya',
                validator: (value) => value == null || value.isEmpty
                    ? 'Iltimos, familiyangizni kiriting!'
                    : null,
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: _phoneController,
                labelText: 'Telefon raqam',
                inputFormatters: [MaskedInputFormatter("+998 (##) ###-##-##")],
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos, raqamingizni kiriting!';
                  }
                  if (!RegExp(r'^\+998 \(\d{2}\) \d{3}-\d{2}-\d{2}$')
                      .hasMatch(value)) {
                    print(value);
                    return "Telefon raqamning formatini to'g'irlang!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: _passwordController,
                labelText: 'Parol',
                obscureText: _obscureText,
                toggleVisibility: _togglePasswordVisibility,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos, parol yarating';
                  }
                  if (value.length < 6) {
                    return "Parol kamida 6 ta belgi bo'lishi kerak!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: _confirmPasswordController,
                labelText: 'Parolni qayta kiriting',
                obscureText: _obscureText,
                toggleVisibility: _togglePasswordVisibility,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yaratgan parolingizni qayta kiriting!';
                  }
                  if (value != _passwordController.text) {
                    return "Parollar bir xil bo'lishi kerak!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _onSignup,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Ro'yxatdan o'tish",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
