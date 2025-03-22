import 'package:maps_launcher/maps_launcher.dart';

class MapsLauncherService {
  static Future<void> launchCoordinates(
      double latitude, double longitude) async {
    await MapsLauncher.launchCoordinates(latitude, longitude);
  }

  static Future<void> launchQuery(String address) async {
    await MapsLauncher.launchQuery(address);
  }
}
