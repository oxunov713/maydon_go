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

  @override
  String get appTitle => 'Поля';

  @override
  String get noFieldsFound => 'Поля не найдены';

  @override
  String get addField => 'Добавить поле';

  @override
  String get dataLoadError => 'Не удалось загрузить данные';

  @override
  String get retry => 'Повторить попытку';

  @override
  String get booked => 'Забронировано';

  @override
  String get available => 'Свободно';

  @override
  String get manage => 'Управлять';

  @override
  String get unknownField => 'Неизвестное поле';

  @override
  String get addStadiumTitle => 'Добавить стадион';

  @override
  String get stadiumAddedSuccess => 'Стадион успешно добавлен!';

  @override
  String get nameLabel => 'Название';

  @override
  String get nameHint => 'например: Стадион Новза';

  @override
  String get nameRequired => 'Название обязательно';

  @override
  String get descriptionLabel => 'Описание';

  @override
  String get descriptionHint => 'например: Стадион со всеми удобствами';

  @override
  String get descriptionRequired => 'Описание обязательно';

  @override
  String get priceLabel => 'Цена';

  @override
  String get priceHint => 'например: 200 000 сум';

  @override
  String get priceRequired => 'Цена обязательна';

  @override
  String get stadiumCountLabel => 'Количество стадионов';

  @override
  String get stadiumCountHint => 'например: Количество соседних стадионов';

  @override
  String get stadiumCountRequired => 'Количество должно быть больше 0';

  @override
  String get selectLocation => 'Выбрать местоположение на Google Картах';

  @override
  String get hasUniforms => 'Есть форма?';

  @override
  String get hasBathroom => 'Есть душ?';

  @override
  String get isIndoor => 'Есть крытый стадион?';

  @override
  String get submit => 'Отправить';

  @override
  String get submitting => 'Отправка...';

  @override
  String get bookingListTitle => 'Список бронирований';

  @override
  String get noBookingsAvailable => 'Бронирований нет';

  @override
  String get errorOccurred => 'Произошла ошибка';

  @override
  String get unknownStadium => 'Неизвестный стадион';

  @override
  String get noNameAvailable => 'Имя отсутствует';

  @override
  String get call => 'Позвонить';

  @override
  String get close => 'Закрыть';

  @override
  String get selectLocationTitle => 'Выбрать местоположение';

  @override
  String get confirmLocation => 'Подтвердить местоположение';

  @override
  String get currentLocation => 'Текущее местоположение';

  @override
  String get loadingLocation => 'Загрузка местоположения...';

  @override
  String get locationError => 'Не удалось загрузить местоположение';

  @override
  String get bookingsLabel => 'Бронирования';

  @override
  String get profileLabel => 'Профиль';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get noName => 'Нет имени';

  @override
  String get notification => 'Уведомления';

  @override
  String get subscription => 'Подписка';

  @override
  String get addImage => 'Добавить изображение';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get imagesUploadedSuccess => 'Изображения успешно загружены!';

  @override
  String imageUploadError(Object error) {
    return 'Ошибка загрузки изображений: $error';
  }

  @override
  String get noImagesSelected => 'Изображения не выбраны';

  @override
  String get subscriptionPackages => 'Пакеты подписки';

  @override
  String get active => 'Активный';

  @override
  String get inactive => 'Неактивный';

  @override
  String subscriptionSelected(String price) {
    return 'Вы выбрали подписку на $price!';
  }

  @override
  String get errorLoading => 'Ошибка загрузки подписок';

  @override
  String get loading => 'Загрузка...';

  @override
  String get noBookings => 'На выбранный день бронирований нет';

  @override
  String get client => 'Клиент';

  @override
  String get bookingsTitle => 'Бронирования стадиона';
}
