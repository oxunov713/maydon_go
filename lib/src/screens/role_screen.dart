import 'package:flutter/material.dart';
import 'package:maydon_go/src/screens/owner/owner_sign_up.dart';
import 'package:maydon_go/src/screens/user/user_sign_up_screen.dart';
import '../style/app_colors.dart';
import '../widgets/role_widget.dart';
import 'user/home_screen.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  bool ownerSelected = false;
  bool userSelected = false;

  void _onRoleSelect(bool isUser) {
    setState(() {
      userSelected = isUser;
      ownerSelected = !isUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Maydon Go",
                  style: TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 50),
                buildRoleCard(
                  title: "Maydonni topish",
                  subtitle: "Maydonni qidirmoqchiman",
                  isSelected: userSelected,
                  onTap: () => _onRoleSelect(true),
                ),
                buildRoleCard(
                  title: "Maydonni kiritish",
                  subtitle: "Maydonni kiritmoqchiman",
                  isSelected: ownerSelected,
                  onTap: () => _onRoleSelect(false),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: (userSelected || ownerSelected)
              ? () {
                  if (userSelected) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OwnerSignUp(),
                      ),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            disabledBackgroundColor: AppColors.green40
          ),
          child: const Text(
            "Ro'yxatdan o'tish",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
