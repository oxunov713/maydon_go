import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
    checkInitialConnection();
  }

  Future<void> checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Agar resultda hech qanaqa ulanish turi bo'lmasa, demak internet yo'q
    final connected = results.any((r) => r != ConnectivityResult.none);
    if (_isConnected != connected) {
      _isConnected = connected;
      notifyListeners();
    }
  }
}
