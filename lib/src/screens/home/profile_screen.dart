import 'package:flutter/material.dart';
import 'package:maydon_go/src/screens/splash_screen.dart';
import 'package:maydon_go/src/style/app_colors.dart';
import 'package:maydon_go/src/style/app_icons.dart';
import 'package:maydon_go/src/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: Text("Profile"),
        actions: [  TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(),
            ),
          ),
          child: Text(
            "Chiqish",
            style:
            TextStyle(color: AppColors.red, fontWeight: FontWeight.w700),
          ),
        ),],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: SizedBox(
          height: deviceHeight,
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(AppIcons.avatarImage),
                        radius: 70,
                      ),
                      Positioned(
                        left: 100,
                        top: 100,
                        child: CircleAvatar(
                          backgroundColor: AppColors.green2,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Azizbek Oxunov",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        color: AppColors.main),
                  ),
                  Text(
                    "+998 (50) 002-07-13",
                    style: TextStyle(fontSize: 16, color: AppColors.main),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  buildTextField(
                      controller: _passwordController,
                      labelText: "Parolni yangilash"),
                  SizedBox(
                    height: 15,
                  ),
                  buildTextField(
                      controller: _passwordController,
                      labelText: "Yangi parolni yangilash"),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Profileni yangilash",
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
