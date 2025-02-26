import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';

class OwnerDetailScreen extends StatelessWidget {
  const OwnerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () =>context.goNamed(AppRoutes.welcome),
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
