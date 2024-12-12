import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:maydon_go/src/screens/user/home_screen.dart';
import 'package:maydon_go/src/widgets/custom_text_field.dart';

import '../../style/app_colors.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  void _onLogIn() {
    if (!(_formKey.currentState?.validate() ?? true)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
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
        automaticallyImplyLeading: false,
        title: Text("Kirish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(
                controller: _phoneController,
                labelText: "Telefon raqam",
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
              SizedBox(
                height: 16,
              ),
              buildTextField(
                controller: _passwordController,
                labelText: "Parol",
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _onLogIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Kirish",
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
