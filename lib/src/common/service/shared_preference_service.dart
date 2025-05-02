import 'dart:convert';

import 'package:maydon_go/src/user/bloc/auth_cubit/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShPService {
  const ShPService._();

  static Future<void> saveRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role.toString());
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

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
    await prefs.clear();
  }

  static const String _votedTournamentsKey = 'voted_tournaments';

  static Future<List<int>> getVotedTournaments() async {
    final prefs = await SharedPreferences.getInstance();
    final votedTournaments = prefs.getStringList(_votedTournamentsKey) ?? [];
    return votedTournaments.map((id) => int.parse(id)).toList();
  }

  static Future<void> saveVotedTournament(int tournamentId) async {
    final prefs = await SharedPreferences.getInstance();
    final votedTournaments = await getVotedTournaments();

    if (!votedTournaments.contains(tournamentId)) {
      votedTournaments.add(tournamentId);
      await prefs.setStringList(
        _votedTournamentsKey,
        votedTournaments.map((id) => id.toString()).toList(),
      );
    }
  }

  static Future<void> saveOwnerStadiumId(int stadiumId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('owner_stadium_id', stadiumId);
  }

  static Future getOwnerStadiumId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('owner_stadium_id');
  }

  static Future<void> clearVotedTournaments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_votedTournamentsKey);
  }
}
