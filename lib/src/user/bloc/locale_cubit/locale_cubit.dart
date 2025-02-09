import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('uz')); // Default til

  void setLocale(String localeCode) {
    emit(Locale(localeCode));
  }
}
