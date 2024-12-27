import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/router/app_routes.dart';

class AuthProvider with ChangeNotifier {
  // Role Secreen
  bool ownerSelected = false;
  bool userSelected = false;

  void onRoleSelect(bool isUser) {
    userSelected = isUser;
    ownerSelected = !isUser;
    notifyListeners();
  }

  void navigateBasedOnSelection(BuildContext context) {
    if (userSelected) {
      context.pushNamed(AppRoutes.signUp);
    } else if (ownerSelected) {
      context.pushNamed(AppRoutes.ownerSignUp);
    }
  }

  bool letDisable() {
    return (userSelected || ownerSelected) ? true : false;
  }

  //SignUp screen
  bool _isSigningUp = false;

  bool get isSigningUp => _isSigningUp;

  bool obscurePassword1 = true;
  bool obscurePassword2 = true;

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
  }) async {
    _isSigningUp = true;
    notifyListeners();

    try {
      // Call your Auth service to handle the signup process
      //await AuthService.signUp(firstName, lastName, phone, password);

      // If successful
      // _isSigningUp = false;
      //notifyListeners();
    } catch (e) {
      // _isSigningUp = false;
      //notifyListeners();
      // Handle error or show error message
    }
  }

  void togglePassword(int n) {
    if (n == 1) {
      obscurePassword1 = !obscurePassword1;
    }
    if (n == 2) {
      obscurePassword2 = !obscurePassword2;
    }
    notifyListeners();
  }

  //logIn screen
  bool obscurePasswordLogin = true;

  void toggleLogInPassword() {
    obscurePasswordLogin = !obscurePasswordLogin;
    notifyListeners();
  }

  // SMS verify
  late Timer _timer;
  int remainingSeconds = 60;
  bool isResendButtonEnabled = false;

  void startTimer() {
    remainingSeconds = 60;
    isResendButtonEnabled = false;

    // Timerni boshlab yuborish
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
      } else {
        isResendButtonEnabled = true;
        _timer.cancel();
      }
      // O'zgarishlarni bildirish
      notifyListeners();
    });
  }

  void resendCode() {
    if (isResendButtonEnabled) {
      // Timer qayta ishga tushiriladi
      startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool isEnabled = false;
  int smsCodeLength = 6;

  void enabledBT(String smsCode) {
    isEnabled = smsCode.length == smsCodeLength;

    notifyListeners();
  }
}
