// lib/src/common/screens/retry_screen.dart
import 'package:flutter/material.dart';

class RetryScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const RetryScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],  // Background color set to light green
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.white),  // White icon for contrast
            const SizedBox(height: 20),
            const Text(
              'Tarmoq mavjud emas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,  // White text for better readability
              ),
            ),


          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: onRetry,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],  // Dark green button
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: StadiumBorder(),
        ),
        child: const Text(
          'Qayta urinib ko‘rish',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,  // White text on the button
          ),
        ),
      ),
    );
  }
}
