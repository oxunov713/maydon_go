import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'dart:io';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../../common/widgets/sign_button.dart';

class AddStadiumScreen extends StatefulWidget {
  @override
  _AddStadiumScreenState createState() => _AddStadiumScreenState();
}

class _AddStadiumScreenState extends State<AddStadiumScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  List<File> _selectedImages = []; // Tanlangan rasmlar

  bool hasBathroom = false;
  bool isIndoor = false;
  bool hasUniforms = false;

  // Rasm tanlash funksiyasi
  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      setState(() {
        _selectedImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  // SwitchListTile uchun alohida widget
  Widget _buildSwitchListTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.main, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(title),
      onChanged: onChanged,
      value: value,
      activeColor: AppColors.green,
      inactiveTrackColor: AppColors.white2,
      inactiveThumbColor: AppColors.secondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Stadium'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 200, child: Image.asset(AppIcons.uzbIcon)),
              SizedBox(height: 25),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: "ex: Novza stadioni",
                  prefixIcon: Icon(Icons.stadium, color: AppColors.main),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.main, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.green, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the stadium name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: "ex: Barcha qulayliklar ega stadion",
                  prefixIcon: Icon(Icons.description, color: AppColors.main),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.main, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.green, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the stadium description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: "ex: 200 000 so'm",
                  prefixIcon: Icon(Icons.attach_money, color: AppColors.main),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.main, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.green, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.red, width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _countController,
                decoration: InputDecoration(
                  labelText: 'Stadium count',
                  hintText: "ex: Yonma-yon stadionlar soni",
                  prefixIcon: Icon(Icons.numbers, color: AppColors.main),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.main, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.green, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.red, width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the stadium count';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              InkWell(
                onTap: () => context.pushNamed(AppRoutes.locationPicker),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.main, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Location from Google Maps',
                        style: TextStyle(color: AppColors.main),
                      ),
                      Icon(
                        Icons.location_pin,
                        color: AppColors.main,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: _pickImages,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.main, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, color: AppColors.main),
                      SizedBox(width: 10),
                      Text(
                        'Pick Images',
                        style: TextStyle(color: AppColors.main),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_selectedImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedImages.map((image) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
              _buildSwitchListTile(
                title: "Forma mavjudmi?",
                value: hasUniforms,
                onChanged: (value) {
                  setState(() {
                    hasUniforms = value;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildSwitchListTile(
                title: "Dush mavjudmi?",
                value: hasBathroom,
                onChanged: (value) {
                  setState(() {
                    hasBathroom = value;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildSwitchListTile(
                title: "Yopiq stadion mavjudmi?",
                value: isIndoor,
                onChanged: (value) {
                  setState(() {
                    isIndoor = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomSignButton(
        function: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Stadium added successfully!')),
            );
          }
        },
        text: "Submit",
        isdisabledBT: true,
      ),
    );
  }
}
