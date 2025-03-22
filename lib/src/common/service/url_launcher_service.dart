import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  // Telegram link ochish
  static Future<void> openTelegram(String username) async {
    final url = Uri.parse('https://t.me/$username');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Telegramni ochib bo‘lmadi: $url';
    }
  }

  // Instagram link ochish
  static Future<void> openInstagram(String username) async {
    final url = Uri.parse('https://www.instagram.com/$username/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Instagramni ochib bo‘lmadi: $url';
    }
  }

  // Telefon raqamga qo‘ng‘iroq qilish
  static Future<void> callPhoneNumber(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(url)) {
      throw 'Telefon raqamni ochib bo‘lmadi: $url';
    }
  }

  // SMS yozish
  static Future<void> sendSms(String phoneNumber) async {
    final url = Uri.parse('sms:$phoneNumber');
    if (!await launchUrl(url)) {
      throw 'SMSni ochib bo‘lmadi: $url';
    }
  }

  // Email jo‘natish
  static Future<void> sendEmail(String email) async {
    final url = Uri.parse('mailto:$email');
    if (!await launchUrl(url)) {
      throw 'Emailni ochib bo‘lmadi: $url';
    }
  }

  //shareLocation
  static Future<void> shareLocationViaTelegram(
      double latitude, double longitude, String stadiumName) async {
    final message = Uri.encodeComponent(
        "$stadiumName \nBu yerda futbol o‘ynaymiz!  📍\n\nGoogle Maps: https://maps.google.com/?q=$latitude,$longitude\n\nYandex Maps: https://yandex.com/maps/?ll=$longitude,$latitude&z=16");

    final url = Uri.parse("https://t.me/share/url?url=$message");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Telegramni ochib bo‘lmadi!';
    }
  }
}
