
// Foydalanuvchi roli uchun enum
enum UserRole { user, owner, none }

// Auth holatlari uchun asosiy State class
abstract class AuthState {}

// 🔹 Dastlabki (boshlang‘ich) holat
class AuthInitial extends AuthState {}

// 🔹 Foydalanuvchi roli tanlanganda
class AuthRoleSelected extends AuthState {
  final UserRole selectedRole;

   AuthRoleSelected(this.selectedRole);
}

// 🔹 Yozilgan parollarni toggling qilish uchun
class AuthPasswordToggled extends AuthState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoginPasswordVisible;

   AuthPasswordToggled({
    this.isPasswordVisible = true,
    this.isConfirmPasswordVisible = true,
    this.isLoginPasswordVisible = true,
  });
}

// 🔹 Ro‘yxatdan o‘tish yoki kirish jarayoni davom etyapti
class AuthLoading extends AuthState {}

// 🔹 Ro‘yxatdan o‘tish muvaffaqiyatli bo‘ldi
class AuthSignUpSuccess extends AuthState {}

// 🔹 Kirish muvaffaqiyatli bo‘ldi
class AuthLoginSuccess extends AuthState {}

// 🔹 Xatolik yuz berdi (ro‘yxatdan o‘tish/kirish)
class AuthError extends AuthState {
  final String message;

   AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// 🔹 SMS kodni kiritish ekrani uchun vaqtni yangilash
class AuthTimerUpdated extends AuthState {
  final int remainingSeconds;
  final bool isResendEnabled;

   AuthTimerUpdated(this.remainingSeconds, this.isResendEnabled);


}

// 🔹 SMS kod uzunligi tekshirilganda tugmani yoqish
class AuthSmsCodeUpdated extends AuthState {
  final bool isButtonEnabled;

   AuthSmsCodeUpdated(this.isButtonEnabled);

}
