import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:go_router/go_router.dart';
import '../../provider/auth_provider.dart';
import '../../router/app_routes.dart';
import '../../tools/language_extension.dart';

import 'package:provider/provider.dart';

import '../../style/app_colors.dart';
import '../../widgets/custom_text_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLogIn() {
    if ((_formKey.currentState?.validate() ?? true)) {
      final phoneNumber = _phoneController.text.trim();
      final password = _passwordController.text.trim();
      print(phoneNumber);
      print(password);
      context.goNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.lan.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(
                controller: _phoneController,
                labelText: context.lan.phone,
                inputFormatters: [
                  MaskedInputFormatter(" (##) ###-##-##"),
                ],
                isNumber: true,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  value = "+998${value!}";
                  if (value.isEmpty) {
                    return context.lan.phoneError;
                  }
                  if (!RegExp(r'^\+998 \(\d{2}\) \d{3}-\d{2}-\d{2}$')
                      .hasMatch(value)) {
                    print(value);
                    return context.lan.phoneFormatError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildTextField(
                controller: _passwordController,
                labelText: context.lan.password,
                obscureText:
                    Provider.of<AuthProvider>(context).obscurePasswordLogin,
                toggleVisibility: () =>
                    Provider.of<AuthProvider>(context).toggleLogInPassword(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.lan.loginPassworEmpty;
                  }
                  if (value.length < 6) {
                    return context.lan.passwordMinLengthError;
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
          child: Text(
            context.lan.login,
            style: const TextStyle(
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
