import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/tools/language_extension.dart';

import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../router/app_routes.dart';
import '../../style/app_colors.dart';
import '../../widgets/custom_text_field.dart';


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


  void _onSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.signUp(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
      );

      await Future.delayed(const Duration(seconds: 5));

      context.goNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.lan.signUp),
        backgroundColor: AppColors.green,
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: () => context.pushNamed(AppRoutes.login),
            child: Text(
              context.lan.login,
              style:
                  const TextStyle(color: AppColors.red, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: Provider.of<AuthProvider>(context).isSigningUp
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.green,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.lan.signupInProgress,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    buildTextField(
                      controller: _firstNameController,
                      labelText: context.lan.firstName,
                      validator: (value) => value == null || value.isEmpty
                          ? context.lan.firstNameError
                          : null,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _lastNameController,
                      labelText: context.lan.lastName,
                      validator: (value) => value == null || value.isEmpty
                          ? context.lan.lastNameError
                          : null,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _phoneController,
                      labelText: context.lan.phone,
                      isNumber: true,
                      inputFormatters: [
                        MaskedInputFormatter(
                          " (##) ###-##-##",
                        ),
                      ],
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        value = "+998${value!}";
                        if (value.isEmpty) {
                          return context.lan.phoneError;
                        }
                        if (!RegExp(r'^\+998 \(\d{2}\) \d{3}-\d{2}-\d{2}$')
                            .hasMatch(value)) {
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
                          Provider.of<AuthProvider>(context, listen: true)
                              .obscurePassword1,
                      toggleVisibility: () =>
                          Provider.of<AuthProvider>(context, listen: false)
                              .togglePassword(1),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.lan.passwordError;
                        }
                        if (value.length < 6) {
                          return context.lan.passwordMinLengthError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _confirmPasswordController,
                      labelText: context.lan.confirmPassword,
                      obscureText:
                          Provider.of<AuthProvider>(context, listen: true)
                              .obscurePassword2,
                      toggleVisibility: () =>
                          Provider.of<AuthProvider>(context, listen: false)
                              .togglePassword(2),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.lan.confirmPasswordError;
                        }
                        if (value != _passwordController.text) {
                          return context.lan.passwordMatchError;
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
          child: Text(
            context.lan.signUp,
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
