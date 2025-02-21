import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../common/widgets/sign_button.dart';
import '../../../common/tools/language_extension.dart';
import '../../bloc/auth_cubit/auth_cubit.dart';
import '../../bloc/auth_cubit/auth_state.dart';
import '../../../common/router/app_routes.dart';
import '../../../common/style/app_colors.dart';

class SmsVerification extends StatefulWidget {
  const SmsVerification({super.key});

  @override
  State<SmsVerification> createState() => _SmsVerificationState();
}

class _SmsVerificationState extends State<SmsVerification> {
  @override
  void initState() {
    super.initState();
    // Start the timer when the screen is loaded
    context.read<AuthCubit>().startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.lan.otp_verification_title,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            Text(
              context.lan.otp_verification_subtitle("13"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            // PinCodeTextField to accept SMS code
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final smsCodeLength = context.read<AuthCubit>().smsCodeLength;

                return PinCodeTextField(
                  appContext: context,
                  length: smsCodeLength,
                  onChanged: (value) {
                    context.read<AuthCubit>().validateSmsCode(value);
                  },
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(15),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    inactiveColor: AppColors.grey4,
                    activeColor: AppColors.green2,
                    selectedColor: AppColors.green,
                  ),
                );
              },
            ),
            // Resend Button
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                bool isResendButtonEnabled =
                    context.read<AuthCubit>().isResendEnabled;

                return TextButton(
                  onPressed: isResendButtonEnabled
                      ? () => context.read<AuthCubit>().resendCode()
                      : null,
                  child: Text(
                    isResendButtonEnabled
                        ? context.lan.resend_code
                        : context.lan.otp_verification_resend_timer(context.read<AuthCubit>().remainingSeconds),
                    style: TextStyle(
                      color: isResendButtonEnabled
                          ? AppColors.green
                          : AppColors.grey4,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSignButton(
        isdisabledBT: context.watch<AuthCubit>().isSmsCodeValid,
        function: () {
          context.goNamed(AppRoutes.home);
        },
        text: context.lan.otp_verification_button,
      ),
    );
  }
}