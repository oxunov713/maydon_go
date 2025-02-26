// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get chooseLanguage => 'Выберите язык';

  @override
  String get appName => 'Maydon Go';

  @override
  String get uzbek => 'Узбекский';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'Английский';

  @override
  String get continueBt => 'Продолжить';

  @override
  String get roleUserTitle => 'Найти поле';

  @override
  String get roleUserSubTitle => 'Я хочу найти поле';

  @override
  String get roleOwnerTitle => 'Ввести поле';

  @override
  String get roleOwnerSubTitle => 'Я хочу ввести поле';

  @override
  String get signUp => 'Регистрация';

  @override
  String get login => 'Войти';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get phone => 'Телефонный номер';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get signupSuccess => 'Регистрация успешна!';

  @override
  String get phoneFormatError => 'Пожалуйста, введите номер телефона в правильном формате.';

  @override
  String get passwordMinLengthError => 'Пароль должен содержать не менее 6 символов!';

  @override
  String get passwordMatchError => 'Пароли должны совпадать!';

  @override
  String get firstNameError => 'Пожалуйста, введите ваше имя!';

  @override
  String get lastNameError => 'Пожалуйста, введите вашу фамилию!';

  @override
  String get phoneError => 'Пожалуйста, введите номер телефона!';

  @override
  String get passwordError => 'Пожалуйста, создайте пароль';

  @override
  String get confirmPasswordError => 'Пожалуйста, подтвердите ваш пароль!';

  @override
  String get signupInProgress => 'Регистрация в процессе...';

  @override
  String get signupButtonText => 'Зарегистрироваться';

  @override
  String get loginPasswordEmpty => ' Пожалуйста, введите пароль';

  @override
  String get otp_verification_title => 'Проверка OTP';

  @override
  String otp_verification_subtitle(Object last2numbers) {
    return 'Мы отправили OTP код на ваш номер телефона --- --- ---99. Введите OTP код ниже, чтобы продолжить.';
  }

  @override
  String otp_verification_resend_timer(Object remaining_seconds) {
    return 'Вы можете отправить код повторно через $remaining_seconds секунд';
  }

  @override
  String get otp_verification_button => 'Подтвердить';

  @override
  String get forgot_password => 'Забыли пароль?';

  @override
  String get resend_code => 'Отправить снова';

  @override
  String get stadiums => 'Стадионы';

  @override
  String get saved => 'Сохраненные';

  @override
  String get myClub => 'Мой клуб';

  @override
  String get profile => 'Профиль';

  @override
  String get all_stadiums => 'Все стадионы';

  @override
  String get search_placeholder => 'Название стадиона';

  @override
  String get rating => 'Рейтинг';

  @override
  String get price => 'Цена';

  @override
  String get empty_slots => 'Свободные часы на сегодня';

  @override
  String get all_slots_booked => 'Все часы заняты';

  @override
  String get location => 'Адрес';

  @override
  String get noData => 'Данные отсутствуют';
}
