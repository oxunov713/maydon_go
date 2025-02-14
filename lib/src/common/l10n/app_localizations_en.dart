import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get appName => 'Maydon Go';

  @override
  String get uzbek => 'Uzbek';

  @override
  String get russian => 'Russian';

  @override
  String get english => 'English';

  @override
  String get continueBt => 'Continue';

  @override
  String get roleUserTitle => 'Find a Field';

  @override
  String get roleUserSubTitle => 'I want to search for a field';

  @override
  String get roleOwnerTitle => 'Enter a Field';

  @override
  String get roleOwnerSubTitle => 'I want to enter a field';

  @override
  String get signUp => 'Sign Up';

  @override
  String get login => 'Login';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phone => 'Phone number';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get signupSuccess => 'Signup Successful!';

  @override
  String get phoneFormatError => 'Please enter a valid phone number format.';

  @override
  String get passwordMinLengthError => 'Password must be at least 6 characters long!';

  @override
  String get passwordMatchError => 'Passwords must match!';

  @override
  String get firstNameError => 'Please enter your first name!';

  @override
  String get lastNameError => 'Please enter your last name!';

  @override
  String get phoneError => 'Please enter your phone number!';

  @override
  String get passwordError => 'Please create a password';

  @override
  String get confirmPasswordError => 'Please confirm your password!';

  @override
  String get signupInProgress => 'Signup in progress...';

  @override
  String get signupButtonText => 'Sign Up';

  @override
  String get loginPassworEmpty => 'Please enter the password';

  @override
  String get otp_verification_title => 'OTP Verification';

  @override
  String otp_verification_subtitle(Object last2numbers) {
    return 'We sent an OTP code to your phone number --- --- ---99. Enter the OTP code below to continue.';
  }

  @override
  String otp_verification_resend_timer(Object remaining_seconds) {
    return 'You can resend the code in $remaining_seconds seconds';
  }

  @override
  String get otp_verification_button => 'Verify';

  @override
  String get forgot_password => 'Forgot your password?';

  @override
  String get resend_code => 'Resend Code';
}
