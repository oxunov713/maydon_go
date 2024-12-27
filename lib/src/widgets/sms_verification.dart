import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/provider/auth_provider.dart';
import 'package:maydon_go/src/router/app_routes.dart';
import 'package:maydon_go/src/style/app_colors.dart';
import 'package:maydon_go/src/tools/language_extension.dart';
import 'package:maydon_go/src/widgets/sign_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class SmsVerification extends StatefulWidget {
  const SmsVerification({super.key});

  @override
  State<SmsVerification> createState() => _SmsVerificationState();
}

class _SmsVerificationState extends State<SmsVerification> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).startTimer();
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

            SizedBox(height: 15),
            Text(
              context.lan.otp_verification_subtitle("13"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            PinCodeTextField(
              appContext: context,
              length: Provider.of<AuthProvider>(context).smsCodeLength,
              onChanged: (value) {
                Provider.of<AuthProvider>(context, listen: false)
                    .enabledBT(value);
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
            ),
            TextButton(
              onPressed: Provider.of<AuthProvider>(context, listen: true)
                      .isResendButtonEnabled
                  ? Provider.of<AuthProvider>(context, listen: false).resendCode
                  : null,
              child: Text(
                Provider.of<AuthProvider>(context, listen: true)
                        .isResendButtonEnabled
                    ? context.lan.resend_code
                    : '${context.lan.otp_verification_resend_timer(Provider.of<AuthProvider>(context, listen: true).remainingSeconds)}',
                style: TextStyle(
                  color: Provider.of<AuthProvider>(context, listen: true)
                          .isResendButtonEnabled
                      ? AppColors.green
                      : AppColors.grey4,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSignButton(
        isdisabledBT:
            Provider.of<AuthProvider>(context, listen: true).isEnabled,
        function: () {
          context.goNamed(AppRoutes.home);
        },
        text: context.lan.otp_verification_button,
      ),
    );
  }
}
