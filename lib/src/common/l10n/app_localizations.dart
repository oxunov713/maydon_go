import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz')
  ];

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Maydon Go'**
  String get appName;

  /// No description provided for @uzbek.
  ///
  /// In en, this message translates to:
  /// **'Uzbek'**
  String get uzbek;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @continueBt.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBt;

  /// No description provided for @roleUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a Field'**
  String get roleUserTitle;

  /// No description provided for @roleUserSubTitle.
  ///
  /// In en, this message translates to:
  /// **'I want to search for a field'**
  String get roleUserSubTitle;

  /// No description provided for @roleOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a Field'**
  String get roleOwnerTitle;

  /// No description provided for @roleOwnerSubTitle.
  ///
  /// In en, this message translates to:
  /// **'I want to enter a field'**
  String get roleOwnerSubTitle;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signup Successful!'**
  String get signupSuccess;

  /// No description provided for @phoneFormatError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number format.'**
  String get phoneFormatError;

  /// No description provided for @passwordMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long!'**
  String get passwordMinLengthError;

  /// No description provided for @passwordMatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match!'**
  String get passwordMatchError;

  /// No description provided for @firstNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name!'**
  String get firstNameError;

  /// No description provided for @lastNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name!'**
  String get lastNameError;

  /// No description provided for @phoneError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number!'**
  String get phoneError;

  /// No description provided for @passwordError.
  ///
  /// In en, this message translates to:
  /// **'Please create a password'**
  String get passwordError;

  /// No description provided for @confirmPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password!'**
  String get confirmPasswordError;

  /// No description provided for @signupInProgress.
  ///
  /// In en, this message translates to:
  /// **'Signup in progress...'**
  String get signupInProgress;

  /// No description provided for @signupButtonText.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupButtonText;

  /// No description provided for @loginPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter the password'**
  String get loginPasswordEmpty;

  /// No description provided for @otp_verification_title.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otp_verification_title;

  /// No description provided for @otp_verification_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent an OTP code to your phone number --- --- ---99. Enter the OTP code below to continue.'**
  String otp_verification_subtitle(Object last2numbers);

  /// No description provided for @otp_verification_resend_timer.
  ///
  /// In en, this message translates to:
  /// **'You can resend the code in {remaining_seconds} seconds'**
  String otp_verification_resend_timer(Object remaining_seconds);

  /// No description provided for @otp_verification_button.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otp_verification_button;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgot_password;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend_code;

  /// No description provided for @stadiums.
  ///
  /// In en, this message translates to:
  /// **'Stadiums'**
  String get stadiums;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @myClub.
  ///
  /// In en, this message translates to:
  /// **'My Club'**
  String get myClub;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @all_stadiums.
  ///
  /// In en, this message translates to:
  /// **'All stadiums'**
  String get all_stadiums;

  /// No description provided for @search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Stadium name'**
  String get search_placeholder;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @empty_slots.
  ///
  /// In en, this message translates to:
  /// **'Today\'s available slots'**
  String get empty_slots;

  /// No description provided for @all_slots_booked.
  ///
  /// In en, this message translates to:
  /// **'All slots are booked'**
  String get all_slots_booked;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
    case 'uz': return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
