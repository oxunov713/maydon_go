import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';

import '../style/app_colors.dart';

Widget buildStoryAvatar({
  required bool hasSeenStory,
  required String? imageUrl,
  required String? fullName,
}) {
  return Container(
    width: 70,
    height: 70,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: hasSeenStory
          ? const LinearGradient(
              colors: [Colors.grey, Colors.grey], // Ko‘rilgan story border
            )
          : const LinearGradient(
              colors: [AppColors.green, AppColors.green2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(3), // Border qalinligi
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white, // Ichki qism orqa fon
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2), // Ichki bo‘sh joy
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.white,
            backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                ? CachedNetworkImageProvider(imageUrl)
                : null,
            child: (imageUrl == null || imageUrl.isEmpty)
                ? ClipOval(
                    child: Icon(
                      Icons.person,
                      color: AppColors.secondary,
                    ),
                  )
                : null,
          ),
        ),
      ),
    ),
  );
}

Future<void> showAddStoryDialog(BuildContext context) async {
  final picker = ImagePicker();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add to Your Story',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.green),
              title: const Text('Pick Image from Gallery'),
              onTap: () async {
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  print('Image path: ${image.path}');
                  // TODO: Upload image to story
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: AppColors.green),
              title: const Text('Pick Video from Gallery'),
              onTap: () async {
                final XFile? video =
                    await picker.pickVideo(source: ImageSource.gallery);
                if (video != null) {
                  print('Video path: ${video.path}');
                  // TODO: Upload video to story
                }
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.green),
              title: const Text('Open Camera'),
              onTap: () async {
                final XFile? photo =
                    await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  print('Camera photo path: ${photo.path}');
                  // TODO: Upload camera image to story
                }
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
