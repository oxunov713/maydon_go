import 'dart:convert';

import 'package:maydon_go/src/common/model/main_model.dart';

import '../model/stadium_model.dart';

final class Config {
  const Config._();

  static const baseUrl = "https://api.maydongo.uz/api";

  static const wsServerUrl = 'wss://api.maydongo.uz/api/ws';
}

final class GoSubscriptionFeatures {
  const GoSubscriptionFeatures._();

  static const friendsLength = 50;

  static const clubLength = 1;

  static const timeSlotsLength = 3;
}

final class GoPlusSubscriptionFeatures {
  const GoPlusSubscriptionFeatures._();

  static const friendsLength = 500;

  static const clubLength = 5;

  static const timeSlotsLength = 15;
}
