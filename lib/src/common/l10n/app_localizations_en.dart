// ignore: unused_import
import 'package:intl/intl.dart' as intl;
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
  String get passwordMinLengthError =>
      'Password must be at least 6 characters long!';

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
  String get loginPasswordEmpty => 'Please enter the password';

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

  @override
  String get stadiums => 'Stadiums';

  @override
  String get saved => 'Saved';

  @override
  String get myClub => 'My Club';

  @override
  String get profile => 'Profile';

  @override
  String get all_stadiums => 'All stadiums';

  @override
  String get search_placeholder => 'Stadium name';

  @override
  String get rating => 'Rating';

  @override
  String get price => 'Price';

  @override
  String get empty_slots => 'Today\'s available slots';

  @override
  String get all_slots_booked => 'All slots are booked';

  @override
  String get location => 'Location';

  @override
  String get noData => 'No data available';

  @override
  String get appTitle => 'Fields';

  @override
  String get noFieldsFound => 'No fields found';

  @override
  String get addField => 'Add field';

  @override
  String get dataLoadError => 'Failed to load data';

  @override
  String get retry => 'Retry';

  @override
  String get booked => 'Booked';

  @override
  String get available => 'Available';

  @override
  String get manage => 'Manage';

  @override
  String get unknownField => 'Unknown field';

  @override
  String get addStadiumTitle => 'Add Stadium';

  @override
  String get stadiumAddedSuccess => 'Stadium added successfully!';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'e.g., Novza Stadium';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'e.g., A stadium with all amenities';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get priceLabel => 'Price';

  @override
  String get priceHint => 'e.g., 200,000 UZS';

  @override
  String get priceRequired => 'Price is required';

  @override
  String get stadiumCountLabel => 'Stadium count';

  @override
  String get stadiumCountHint => 'e.g., Number of side-by-side stadiums';

  @override
  String get stadiumCountRequired => 'Count must be greater than 0';

  @override
  String get selectLocation => 'Select Location from Google Maps';

  @override
  String get hasUniforms => 'Uniforms available?';

  @override
  String get hasBathroom => 'Bathroom available?';

  @override
  String get isIndoor => 'Indoor stadium available?';

  @override
  String get submit => 'Submit';

  @override
  String get submitting => 'Submitting...';

  @override
  String get bookingListTitle => 'Booking List';

  @override
  String get noBookingsAvailable => 'No bookings available';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get unknownStadium => 'Unknown stadium';

  @override
  String get noNameAvailable => 'No name available';

  @override
  String get call => 'Call';

  @override
  String get close => 'Close';

  @override
  String get selectLocationTitle => 'Select Location';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get loadingLocation => 'Loading location...';

  @override
  String get locationError => 'Failed to load location';

  @override
  String get bookingsLabel => 'Bookings';

  @override
  String get profileLabel => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get noName => 'No name';

  @override
  String get notification => 'Notification';

  @override
  String get subscription => 'Subscription';

  @override
  String get addImage => 'Add image';

  @override
  String get aboutApp => 'About app';

  @override
  String get imagesUploadedSuccess => 'Images uploaded successfully!';

  @override
  String imageUploadError(Object error) {
    return 'Error uploading images: $error';
  }

  @override
  String get noImagesSelected => 'No images selected';

  @override
  String get subscriptionPackages => 'Subscription Packages';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String subscriptionSelected(String price) {
    return 'You have selected the $price subscription!';
  }

  @override
  String get errorLoading => 'Error loading subscriptions';

  @override
  String get loading => 'Loading...';

  @override
  String get noBookings => 'No bookings available on the selected day';

  @override
  String get client => 'Client';

  @override
  String get bookingsTitle => 'Substadium Bookings';
}
