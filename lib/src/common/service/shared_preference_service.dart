import 'package:shared_preferences/shared_preferences.dart';

import '../../user/bloc/auth_cubit/auth_state.dart';

class ShPService {
  const ShPService._();

  // SharedPreferences instance olish
  static Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  // Foydalanuvchi rolini saqlash
  static Future<void> saveRole(UserRole role) async {
    final prefs = await _getPreferences();
    await prefs.setString('role', role.toString());
  }

  // Foydalanuvchi rolini olish
  static Future<String?> getRole() async {
    final prefs = await _getPreferences();
    return prefs.getString('role');
  }

  // Tokenni saqlash
  static Future<void> saveToken(String token) async {
    final prefs = await _getPreferences();
    await prefs.setString('authToken', token);
  }

  // Tokenni olish
  static Future<String?> getToken() async {
    final prefs = await _getPreferences();
    return prefs.getString('authToken');
  }

  // Tokenni o'chirish
  static Future<void> removeToken() async {
    final prefs = await _getPreferences();
    await prefs.remove('authToken');
  }

  // Barcha ma'lumotlarni tozalash
  static Future<void> clearAllData() async {
    final prefs = await _getPreferences();
    await prefs.clear();
  }

  static const String _votedTournamentsKey = 'voted_tournaments';

  // Ovoz bergan turnirlarni olish
  static Future<List<int>> getVotedTournaments() async {
    final prefs = await _getPreferences();
    final votedTournaments = prefs.getStringList(_votedTournamentsKey) ?? [];
    return votedTournaments.map((id) => int.parse(id)).toList();
  }

  // Turnirga ovoz berish
  static Future<void> saveVotedTournament(int tournamentId) async {
    final prefs = await _getPreferences();
    final votedTournaments = await getVotedTournaments();

    if (!votedTournaments.contains(tournamentId)) {
      votedTournaments.add(tournamentId);
      await prefs.setStringList(
        _votedTournamentsKey,
        votedTournaments.map((id) => id.toString()).toList(),
      );
    }
  }

  // Stadion ID ni saqlash
  static Future<void> saveOwnerStadiumId(int stadiumId) async {
    final prefs = await _getPreferences();
    await prefs.setInt('owner_stadium_id', stadiumId);
  }

  // Stadion ID ni olish
  static Future<int?> getOwnerStadiumId() async {
    final prefs = await _getPreferences();
    return prefs.getInt('owner_stadium_id');
  }

  // Ovoz berilgan turnirlarni tozalash
  static Future<void> clearVotedTournaments() async {
    final prefs = await _getPreferences();
    await prefs.remove(_votedTournamentsKey);
  }

  // Devorga rasm saqlash
  static Future<void> setWallpaper(String wallpaperPath) async {
    final prefs = await _getPreferences();
    await prefs.setString('selectedWallpaper', wallpaperPath);
  }

  // Devorga rasmni olish
  static Future<String?> getWallpaper() async {
    final prefs = await _getPreferences();
    return prefs.getString('selectedWallpaper');
  }
}
