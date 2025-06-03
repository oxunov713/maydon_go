import 'package:flutter/material.dart';

import '../service/connectivity_service.dart';

class RetryDialog extends StatelessWidget {
  final VoidCallback onRetry;

  const RetryDialog({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.white),
          const SizedBox(height: 20),
          const Text(
            'Tarmoq mavjud emas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'Qayta urinib ko‘rish',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class RetryPage extends StatefulWidget {
  final ConnectivityService connectivityService;

  const RetryPage({super.key, required this.connectivityService});

  @override
  State<RetryPage> createState() => _RetryPageState();
}

class _RetryPageState extends State<RetryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showRetryDialog();
    });
  }

  Future<void> _showRetryDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RetryDialog(
        onRetry: () async {
          await widget.connectivityService.checkInitialConnection();
          if (widget.connectivityService.isConnected) {
            Navigator.pop(context); // dialog yopiladi
            // Optional: Navigatsiya yoki boshqa action qilish mumkin
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: Center(
        child: Text(
          'Tarmoqqa ulanmagan...',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
