import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/locale_cubit/locale_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationOn = true; // Default notification holati

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationOn = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      _isNotificationOn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      backgroundColor: Color(0xffF2F3F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔔 Notification Toggle
            SwitchListTile(
              title: Text(
                "Notifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              value: _isNotificationOn,
              onChanged: _toggleNotifications,
              tileColor: AppColors.white,
              activeColor: AppColors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),

            SizedBox(height: 25),

            Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Language",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: DropdownMenu<String>(
                        initialSelection:
                            context.watch<LocaleCubit>().state.languageCode,
                        onSelected: (String? newLocale) {
                          if (newLocale != null) {
                            context.read<LocaleCubit>().setLocale(newLocale);
                          }
                        },
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: AppColors.green,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: AppColors.transparent,
                              width: 0,
                            ),
                          ),
                        ),
                        dropdownMenuEntries: [
                          _buildDropdownItem('uz', '🇺🇿 O‘zbek', context),
                          _buildDropdownItem('en', '🇬🇧 English', context),
                          _buildDropdownItem('ru', '🇷🇺 Русский', context),
                        ],
                        menuStyle: MenuStyle(
                          backgroundColor:
                              const WidgetStatePropertyAll(AppColors.white),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: AppColors.green,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Dropdown menu uchun item yaratish
  DropdownMenuEntry<String> _buildDropdownItem(
      String value, String text, BuildContext context) {
    bool isSelected = context.watch<LocaleCubit>().state.languageCode == value;
    return DropdownMenuEntry<String>(
      value: value,
      label: text,
      leadingIcon: isSelected
          ? Icon(Icons.check, color: Colors.green) // ✅ Checkmark
          : null,
    );
  }
}
