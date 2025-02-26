// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get chooseLanguage => 'Tilni tanlang';

  @override
  String get appName => 'Maydon Go';

  @override
  String get uzbek => 'O\'zbek';

  @override
  String get russian => 'Rus';

  @override
  String get english => 'Ingliz';

  @override
  String get continueBt => 'Davom etish';

  @override
  String get roleUserTitle => 'Maydonni topish';

  @override
  String get roleUserSubTitle => 'Maydonni qidirmoqchiman';

  @override
  String get roleOwnerTitle => 'Maydonni kiritish';

  @override
  String get roleOwnerSubTitle => 'Maydonni kiritmoqchiman';

  @override
  String get signUp => 'Ro\'yxatdan o\'tish';

  @override
  String get login => 'Kirish';

  @override
  String get firstName => 'Ism';

  @override
  String get lastName => 'Familiya';

  @override
  String get phone => 'Telefon raqam';

  @override
  String get password => 'Parol';

  @override
  String get confirmPassword => 'Parolni qayta kiriting';

  @override
  String get signupSuccess => 'Ro\'yxatdan o\'tish muvaffaqiyatli!';

  @override
  String get phoneFormatError => 'Iltimos, telefon raqamining to\'g\'ri formatini kiriting.';

  @override
  String get passwordMinLengthError => 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak!';

  @override
  String get passwordMatchError => 'Parollar mos kelishi kerak!';

  @override
  String get firstNameError => 'Iltimos, ismingizni kiriting!';

  @override
  String get lastNameError => 'Iltimos, familiyangizni kiriting!';

  @override
  String get phoneError => 'Iltimos, raqamingizni kiriting!';

  @override
  String get passwordError => 'Iltimos, parol yarating';

  @override
  String get confirmPasswordError => 'Yaratgan parolingizni qayta kiriting!';

  @override
  String get signupInProgress => 'Ro\'yxatdan o\'tish davom etmoqda...';

  @override
  String get signupButtonText => 'Ro\'yxatdan o\'tish';

  @override
  String get loginPasswordEmpty => 'Iltimos, parol kiriting';

  @override
  String get otp_verification_title => 'OTP kodini tekshirish';

  @override
  String otp_verification_subtitle(Object last2numbers) {
    return 'Biz telefon raqamingizga OTP kodini yubordik --- --- ---$last2numbers. Davomi ostidagi OTP kodini kiriting davom etish uchun.';
  }

  @override
  String otp_verification_resend_timer(Object remaining_seconds) {
    return 'Sizga kodni $remaining_seconds soniyada qayta yuboramiz';
  }

  @override
  String get otp_verification_button => 'Tasdiqlash';

  @override
  String get forgot_password => 'Parolni unutdingizmi?';

  @override
  String get resend_code => 'Qayta yuborish';

  @override
  String get stadiums => 'Stadionlar';

  @override
  String get saved => 'Saqlanganlar';

  @override
  String get myClub => 'My club';

  @override
  String get profile => 'Profil';

  @override
  String get all_stadiums => 'Barcha maydonlar';

  @override
  String get search_placeholder => 'Maydon nomi';

  @override
  String get rating => 'Reyting';

  @override
  String get price => 'Narx';

  @override
  String get empty_slots => 'Bugungi bo\'sh vaqtlar';

  @override
  String get all_slots_booked => 'Barcha soatlar band';

  @override
  String get location => 'Manzil';

  @override
  String get noData => 'Ma\'lumot mavjud emas';
}
