import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('uz')) {
    _loadLocale(); // Ilova ochilganda so‘nggi tanlangan tilni yuklash
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('app_locale') ?? 'uz'; // Default 'uz'
    emit(Locale(localeCode));
  }

  Future<void> setLocale(String localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', localeCode); // Yangi tilni saqlash
    emit(Locale(localeCode));
  }
}
