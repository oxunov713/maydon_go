import 'package:shared_preferences/shared_preferences.dart';

class ShPService {
  const ShPService._();

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Barcha ma’lumotlarni tozalaydi
    print("✅ Barcha local saqlangan ma’lumotlar o‘chirildi!");
  }
}
