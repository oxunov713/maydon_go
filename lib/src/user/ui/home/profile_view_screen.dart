import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/tools/phone_fromatter_extension.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  String? _imageUrl = $users[1].imageUrl; // Default image
  File? _pickedImage; // Tanlangan rasm uchun

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path); // Fayl sifatida saqlash
      });
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              context.pushReplacementNamed(AppRoutes.role);
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!) as ImageProvider
                      : NetworkImage(_imageUrl!), // Mahalliy yoki URL rasm
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo),
                label: Text("Change Photo"),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${$users[0].firstName} ${$users[0].lastName}",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              Text(
                $users[0].contactNumber.toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey4),
              )
            ],
          ),

          // Logout tugmasi
          ElevatedButton.icon(
            onPressed: _logout,
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            label: Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
