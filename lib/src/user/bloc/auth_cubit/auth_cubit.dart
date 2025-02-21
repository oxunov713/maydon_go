import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../common/router/app_routes.dart';
import '../../../common/service/api_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiService apiService = ApiService();

  AuthCubit() : super(AuthInitial());

  // 📌 1️⃣ ROLE SELECTION (Foydalanuvchi rolini tanlash)
  UserRole selectedRole = UserRole.none;

  void onRoleSelect(UserRole role) {
    selectedRole = role;
    emit(AuthRoleSelected(selectedRole));
  }

  void navigateBasedOnSelection(BuildContext context) {
    if (selectedRole == UserRole.user) {
      context.pushNamed(AppRoutes.home);
    } else if (selectedRole == UserRole.owner) {
      context.pushNamed(AppRoutes.ownerDashboard);
    }
  }

  bool isContinueButtonEnabled() {
    return selectedRole != UserRole.none;
  }

  // 📌 2️⃣ PASSWORD TOGGLE (Parolni ko‘rsatish yoki yashirish)
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool obscureLoginPassword = true;

  void togglePassword({required int type}) {
    if (type == 1) obscurePassword = !obscurePassword;
    if (type == 2) obscureConfirmPassword = !obscureConfirmPassword;
    if (type == 3) obscureLoginPassword = !obscureLoginPassword;

    emit(AuthPasswordToggled(
      isPasswordVisible: obscurePassword,
      isConfirmPasswordVisible: obscureConfirmPassword,
      isLoginPasswordVisible: obscureLoginPassword,
    ));
  }

  // 📌 3️⃣ SIGN UP (Ro‘yxatdan o‘tish)
  bool isLoadingSignUp = false;

  Future<void> signUp({
    required String name,
    required String phone,
    required String password,
    required String language,
  }) async {
    isLoadingSignUp = true;
    emit(AuthLoading());
    try {
      final response = await apiService.userSignUp(
          name: name,
          phoneNumber: phone,
          password: password,
          language: language);

      if (response is Map && response.containsKey('token')) {
        emit(AuthSignUpSuccess());
      } else {
        emit(AuthError(response['message'] ?? 'Unknown error occurred.'));
      }
    } catch (e) {
      emit(AuthError('Error: $e'));
    } finally {
      isLoadingSignUp = false;
    }
  }

  // 📌 4️⃣ LOGIN (Tizimga kirish)
  bool isLoadingLogIn = false;

  Future<void> login({
    required String phone,
    required String password,
    required String language,
  }) async {
    isLoadingLogIn = true;
    emit(AuthLoading());

    try {
      final response = await apiService.userLogin(
          phoneNumber: phone, password: password, language: language);

      if (response is Map && response.containsKey('token')) {
        emit(AuthLoginSuccess());
      } else {
        emit(AuthError(response['message'] ?? 'Unknown error occurred.'));
      }
    } catch (e) {
      emit(AuthError('Error: $e'));
    } finally {
      isLoadingLogIn = false;
    }
  }

  // 📌 5️⃣ SMS CODE VERIFY (SMS kodni tekshirish va taymer)
  Timer? _timer; // Timer ni nullable qilamiz
  int remainingSeconds = 60;
  bool isResendEnabled = false;

  void startTimer() {
    // Avvalgi timer ni to'xtatamiz
    _timer?.cancel();

    remainingSeconds = 60;
    isResendEnabled = false;
    emit(AuthTimerUpdated(remainingSeconds, isResendEnabled));

    // Yangi timer yaratamiz
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        emit(AuthTimerUpdated(remainingSeconds, isResendEnabled));
      } else {
        isResendEnabled = true;
        _timer?.cancel();
        emit(AuthTimerUpdated(remainingSeconds, isResendEnabled));
      }
    });
  }

  void resendCode() {
    if (isResendEnabled) {
      startTimer(); // Timer ni qayta boshlash
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Timer ni to'xtatish
    return super.close();
  }

  // 📌 6️⃣ SMS CODE LENGTH CHECK (SMS kod tugmasini yoqish)
  bool isSmsCodeValid = false;
  final int smsCodeLength = 6;

  void validateSmsCode(String smsCode) {
    isSmsCodeValid = smsCode.length == smsCodeLength;
    emit(AuthSmsCodeUpdated(isSmsCodeValid));
  }
}
