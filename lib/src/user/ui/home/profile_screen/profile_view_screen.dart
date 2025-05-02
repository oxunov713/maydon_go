import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/service/shared_preference_service.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/user/bloc/profile_cubit/profile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/model/main_model.dart';
import '../../../../common/widgets/edit_name.dart';
import '../../../bloc/locale_cubit/locale_cubit.dart';
import '../../../bloc/profile_cubit/profile_state.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {

  bool _isNotificationOn = true;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationOn = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    FlutterLocalNotificationsPlugin().cancelAll();

    setState(() {
      _isNotificationOn = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      backgroundColor: AppColors.white2,
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ProfileCubit>();
            final user = state is ProfileLoaded
                ? state.user
                : state is ProfileUpdating
                    ? state.user
                    : state is ProfileError
                        ? state.lastUser
                        : UserModel(id: -1,fullName: "No name");

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildProfileImage(state, user, cubit),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () =>
                                  _showEditNameDialog(context, user!.fullName!),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    user?.fullName ?? "No name",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                        color: AppColors.main),
                                  ),
                                  Icon(
                                    Icons.edit,
                                    color: AppColors.green,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              user?.phoneNumber?.toString() ?? '',
                              style: TextStyle(
                                  color: AppColors.grey4,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SwitchListTile(
                    title: Text(
                      "Notifications",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    value: _isNotificationOn,
                    onChanged: _toggleNotifications,
                    tileColor: AppColors.white,
                    activeColor: AppColors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: DropdownMenu<String>(
                              initialSelection: context
                                  .watch<LocaleCubit>()
                                  .state
                                  .languageCode,
                              onSelected: (String? newLocale) {
                                if (newLocale != null) {
                                  context
                                      .read<LocaleCubit>()
                                      .setLocale(newLocale);
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
                                _buildDropdownItem(
                                    'uz', '🇺🇿 O‘zbek', context),
                                _buildDropdownItem(
                                    'en', '🇬🇧 English', context),
                                _buildDropdownItem(
                                    'ru', '🇷🇺 Русский', context),
                              ],
                              menuStyle: MenuStyle(
                                backgroundColor: const WidgetStatePropertyAll(
                                    AppColors.white),
                                shape: WidgetStatePropertyAll<
                                    RoundedRectangleBorder>(
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
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLogoutDialog(context),
        backgroundColor: Colors.white,
        elevation: 4,
        splashColor: Colors.red.withOpacity(0.2),
        child: const Icon(Icons.logout, color: Colors.red, size: 26),
      ),
    );
  }

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

  void _showEditNameDialog(BuildContext context, String currentName) {
    showDialog(
      context: context,
      builder: (context) => EditNameDialog(
        currentName: currentName,
        onSave: (newName) {
          context.read<ProfileCubit>().updateUserName(newName);
        },
      ),
    );
  }

  Widget _buildProfileImage(
      ProfileState state, UserModel? user, ProfileCubit cubit) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.main.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: state is ProfileUpdating
                ? const Center(child: CircularProgressIndicator())
                : user?.imageUrl?.isNotEmpty == true
                ? Image.network(
              user!.imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (_, __, ___) => _buildInitialsAvatar(user),
            )
                : _buildInitialsAvatar(user),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final pickedFile = await ImagePicker().pickImage(
              source: ImageSource.gallery,
              imageQuality: 85,
            );

            if (pickedFile != null) {
              File imageFile = File(pickedFile.path);
              context.read<ProfileCubit>().updateProfileImage(imageFile);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.main,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialsAvatar(UserModel? user) {
    String initials = user!.fullName?.isNotEmpty == true ? user.fullName![0].toUpperCase() : "?";
    return Container(
      color: AppColors.green2,
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout Confirmation"),
        content:
            const Text("Are you sure you want to logout from your account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColors.grey4),
            ),
          ),
          TextButton(
            onPressed: () {
              ShPService.removeToken();
              ShPService.clearAllData();
              context.pushReplacementNamed(AppRoutes.splash);
              context.pop();
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
