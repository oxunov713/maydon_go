import 'package:url_launcher/url_launcher.dart';

class ShareService {
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