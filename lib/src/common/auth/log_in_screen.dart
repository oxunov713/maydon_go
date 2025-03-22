import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:maydon_go/src/common/tools/phone_formatter_extension.dart';
import 'package:maydon_go/src/common/widgets/sign_log_app_bar.dart';

import '../../user/bloc/auth_cubit/auth_cubit.dart';
import '../../user/bloc/auth_cubit/auth_state.dart';
import '../../user/bloc/locale_cubit/locale_cubit.dart';
import '../router/app_routes.dart';
import '../style/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/sign_button.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text.trim().cleanPhoneNumber();
      final password = _passwordController.text.trim();

      final authCubit = context.read<AuthCubit>();

      await authCubit.login(
        phone: phone,
        password: password,
      );

      if (authCubit.state is AuthLoginSuccess) {


        // Barcha oldingi sahifalarni tozalab, faqat `home` yoki `ownerDashboard` sahifasiga o'tish
        if (authCubit.selectedRole == UserRole.user) {
          context.goNamed(AppRoutes.home);
        } else {
          context.goNamed(AppRoutes.ownerDashboard);
        }
      } else if (authCubit.state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (authCubit.state as AuthError).message,
              style: const TextStyle(color: AppColors.white),
            ),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: const BackButton(color: AppColors.main),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                signLogAppBar(context, "Qaytib kelganingizdan xursandmiz"),
                const SizedBox(height: 20),
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
                      obscureText: context.read<AuthCubit>().obscureLoginPassword,
                      toggleVisibility: () =>
                          context.read<AuthCubit>().togglePassword(type: 3),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.lan.loginPasswordEmpty;
                        }
                        if (value.length < 6) {
                          return context.lan.passwordMinLengthError;
                        }
                        return null;
                      },
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () {
                        context.pushNamed(AppRoutes.sms);
                      },
                      child: Text(
                        context.lan.forgot_password,
                        style: const TextStyle(
                            color: AppColors.blue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = context
                .watch<AuthCubit>()
                .isLoadingLogIn; // ✅ AuthCubit dan yuklanish holatini olish
            return BottomSignButton(
              function: isLoading ? () {} : _onLogin,
              // ✅ Yuklanayotganda bosish bloklanadi
              text: context.lan.login,
              isdisabledBT: true,
              isLoading: isLoading, // ✅ Yuklanish holatini uzatish
            );
          },
        ),
      ),
    );
  }
}
