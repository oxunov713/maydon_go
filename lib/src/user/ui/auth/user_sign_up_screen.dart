import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/tools/phone_fromatter_extension.dart';
import 'package:maydon_go/src/common/widgets/sign_log_app_bar.dart';

import '../../../common/tools/language_extension.dart';
import '../../../common/router/app_routes.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/sign_button.dart';
import '../../bloc/auth_cubit/auth_cubit.dart';
import '../../bloc/auth_cubit/auth_state.dart';
import '../../bloc/locale_cubit/locale_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _onSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _userNameController.text.trim();
      final phone = _phoneController.text.trim().cleanPhoneNumber();
      final password = _passwordController.text.trim();

      context.read<AuthCubit>().signUp(
            name: name,
            phone: phone,
            password: password,
            language: context.read<LocaleCubit>().state.languageCode,
          );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            signLogAppBar(context, context.lan.signUp),
            const SizedBox(height: 20),
            buildTextField(
              controller: _userNameController,
              labelText: "Ismingiz",
              isName: true, // ✅ Ism kiritish rejimi
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Iltimos, Ismingizni kiriting!";
                }
                if (value.length < 3) {
                  return "Ism kamida 3 ta harf bo‘lishi kerak!";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            buildTextField(
              controller: _phoneController,
              labelText: context.lan.phone,
              isNumber: true,
              inputFormatters: [MaskedInputFormatter(" (##) ###-##-##")],
              keyboardType: TextInputType.phone,
              validator: (value) {
                value = "+998${value!}";
                if (!RegExp(r'^\+998 \(\d{2}\) \d{3}-\d{2}-\d{2}$')
                    .hasMatch(value)) {
                  return context.lan.phoneFormatError;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return buildTextField(
                  controller: _passwordController,
                  labelText: context.lan.password,
                  isPassword: true,
                  obscureText: context.read<AuthCubit>().obscurePassword,
                  toggleVisibility: () =>
                      context.read<AuthCubit>().togglePassword(type: 1),
                  validator: (value) {
                    if (value!.isEmpty) return context.lan.passwordError;
                    if (value.length < 6) {
                      return context.lan.passwordMinLengthError;
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return buildTextField(
                  controller: _confirmPasswordController,
                  labelText: context.lan.confirmPassword,
                  isPassword: true,
                  obscureText: context.read<AuthCubit>().obscureConfirmPassword,
                  toggleVisibility: () =>
                      context.read<AuthCubit>().togglePassword(type: 2),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return context.lan.passwordMatchError;
                    }
                    return null;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ro\'yxatdan o\'tish muvaffaqiyatli!'),
              backgroundColor: AppColors.green,
            ),
          );
          context.goNamed(AppRoutes.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: const BackButton(color: AppColors.main),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.green),
                    const SizedBox(height: 10),
                    Text(context.lan.signupInProgress),
                  ],
                ),
              );
            }
            return _buildForm();
          },
        ),
        bottomNavigationBar: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = context
                .watch<AuthCubit>()
                .isLoadingSignUp; // ✅ AuthCubit dan yuklanish holatini olish
            return BottomSignButton(
              function: isLoading ? () {} : _onSignup,
              // ✅ Yuklanayotganda bosish bloklanadi
              text: context.lan.signUp,
              isdisabledBT: true,
              isLoading: isLoading, // ✅ Yuklanish holatini uzatish
            );
          },
        ),
      ),
    );
  }
}
