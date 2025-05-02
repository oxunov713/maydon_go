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

  @override
  String get appTitle => 'Maydonlar';

  @override
  String get noFieldsFound => 'Maydonlar topilmadi';

  @override
  String get addField => 'Maydon qo\'shish';

  @override
  String get dataLoadError => 'Ma\'lumotlarni yuklab bo\'lmadi';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get booked => 'Band qilingan';

  @override
  String get available => 'Bo\'sh';

  @override
  String get manage => 'Boshqarish';

  @override
  String get unknownField => 'Noma\'lum maydon';

  @override
  String get addStadiumTitle => 'Stadion qo\'shish';

  @override
  String get stadiumAddedSuccess => 'Stadion muvaffaqiyatli qo\'shildi!';

  @override
  String get nameLabel => 'Nomi';

  @override
  String get nameHint => 'masalan: Novza stadioni';

  @override
  String get nameRequired => 'Nomi kiritilishi shart';

  @override
  String get descriptionLabel => 'Tavsif';

  @override
  String get descriptionHint => 'masalan: Barcha qulayliklar ega stadion';

  @override
  String get descriptionRequired => 'Tavsif kiritilishi shart';

  @override
  String get priceLabel => 'Narxi';

  @override
  String get priceHint => 'masalan: 200 000 so\'m';

  @override
  String get priceRequired => 'Narxi kiritilishi shart';

  @override
  String get stadiumCountLabel => 'Stadionlar soni';

  @override
  String get stadiumCountHint => 'masalan: Yonma-yon stadionlar soni';

  @override
  String get stadiumCountRequired => 'Son 0 dan katta bo\'lishi kerak';

  @override
  String get selectLocation => 'Google Xaritalardan joy tanlash';

  @override
  String get hasUniforms => 'Forma mavjudmi?';

  @override
  String get hasBathroom => 'Dush mavjudmi?';

  @override
  String get isIndoor => 'Yopiq stadion mavjudmi?';

  @override
  String get submit => 'Yuborish';

  @override
  String get submitting => 'Yuborilmoqda...';

  @override
  String get bookingListTitle => 'Bronlar ro\'yxati';

  @override
  String get noBookingsAvailable => 'Bronlar mavjud emas';

  @override
  String get errorOccurred => 'Xatolik yuz berdi';

  @override
  String get unknownStadium => 'Noma\'lum stadion';

  @override
  String get noNameAvailable => 'Ism mavjud emas';

  @override
  String get call => 'Qo\'ng\'iroq qilish';

  @override
  String get close => 'Yopish';

  @override
  String get selectLocationTitle => 'Joy tanlash';

  @override
  String get confirmLocation => 'Joyni tasdiqlash';

  @override
  String get currentLocation => 'Hozirgi joy';

  @override
  String get loadingLocation => 'Joy yuklanmoqda...';

  @override
  String get locationError => 'Joyni yuklab bo‘lmadi';

  @override
  String get bookingsLabel => 'Bronlar';

  @override
  String get profileLabel => 'Profil';

  @override
  String get profileTitle => 'Profil';

  @override
  String get noName => 'Ism yo\'q';

  @override
  String get notification => 'Bildirishnoma';

  @override
  String get subscription => 'Obuna';

  @override
  String get addImage => 'Rasm qo\'shish';

  @override
  String get aboutApp => 'Ilova haqida';

  @override
  String get imagesUploadedSuccess => 'Rasmlar muvaffaqiyatli yuklandi!';

  @override
  String imageUploadError(Object error) {
    return 'Rasmlarni yuklashda xatolik: $error';
  }

  @override
  String get noImagesSelected => 'Rasmlar tanlanmadi';

  @override
  String get subscriptionPackages => 'Obuna paketlari';

  @override
  String get active => 'Faol';

  @override
  String get inactive => 'Nofaol';

  @override
  String subscriptionSelected(String price) {
    return 'Siz $price obunasini tanladingiz!';
  }

  @override
  String get errorLoading => 'Obunalarni yuklashda xatolik';

  @override
  String get loading => 'Yuklanmoqda...';

  @override
  String get noBookings => 'Tanlangan kunda bronlar mavjud emas';

  @override
  String get client => 'Mijoz';

  @override
  String get bookingsTitle => 'Maydon bronlari';
}
