import 'package:flutter/material.dart';
import '../style/app_colors.dart';
import '../widgets/role_widget.dart';
import 'home_screen.dart';

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
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            InkWell(
              onTap: (userSelected || ownerSelected)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  : null,
              child: Container(
                height: 60,
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: (userSelected || ownerSelected)
                      ? AppColors.green
                      : AppColors.green40,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Davom etish",
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
