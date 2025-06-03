import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:story_view/story_view.dart';

import '../../../../common/style/app_colors.dart';

class StoryScreen extends StatefulWidget {
  final List<String> mediaUrls;
  final List<String> mediaTypes;
  final UserModel user;
  final int chatId;

  const StoryScreen({
    super.key,
    required this.mediaUrls,
    required this.mediaTypes,
    required this.user,
    required this.chatId,
  });

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late StoryController _storyController;

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();
  }

  @override
  Widget build(BuildContext context) {
    List<StoryItem> storyItems = [];

    // Build StoryItem list based on mediaUrls and mediaTypes
    for (int i = 0; i < widget.mediaUrls.length; i++) {
      String mediaType = widget.mediaTypes[i];
      String mediaUrl = widget.mediaUrls[i];

      if (mediaType == 'image') {
        storyItems.add(
          StoryItem.pageImage(
              url: mediaUrl,
              controller: _storyController,
              duration: Duration(seconds: 10),
              imageFit: BoxFit.cover),
        );
      } else if (mediaType == 'video') {
        storyItems.add(
          StoryItem.pageVideo(
            mediaUrl,
            controller: _storyController,
            duration: Duration(seconds: 60),
          ),
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // StoryView - Make sure it has constraints
            Positioned.fill(
              child: StoryView(
                storyItems: storyItems,
                controller: _storyController,
                indicatorOuterPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                indicatorHeight: IndicatorHeight.medium,
                onStoryShow: (storyItem, index) {},
                onComplete: () {
                  context.goNamed(
                      AppRoutes.home); // Close when the story is complete
                },
                inline: false,
              ),
            ),
            // User Info at the top
            Positioned(
              top: 20, // Adjust top position as needed
              left: 10,
              right: 0,
              child: InkWell(
                onTap: () {
                  context.pop(context);
                  context.pushNamed(
                    AppRoutes.profileChat,
                    extra: {
                      'receivedUser': widget.user,
                      'chatId': widget.chatId,
                    },
                  );
                },
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Row(
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.green2,
                          backgroundImage: widget.user.imageUrl != null &&
                                  widget.user.imageUrl!.isNotEmpty
                              ? NetworkImage(widget.user.imageUrl!)
                              : null,
                          child: (widget.user.imageUrl == null ||
                                  widget.user.imageUrl!.isEmpty)
                              ? Text(
                                  widget.user.fullName != null &&
                                          widget.user.fullName!.isNotEmpty
                                      ? widget.user.fullName![0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                )
                              : null,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.fullName ?? "No name",
                              // Display full name
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "bugun 19:01 da",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors
                                    .white70, // Lighter color for subtitle
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 'download') {
                          downloadAndSaveMedia(context, widget.mediaUrls[2]);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'download',
                          child: Row(
                            children: [
                              Icon(Icons.download, color: Colors.black),
                              SizedBox(width: 8),
                              Text('Download'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      "713",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> downloadAndSaveMedia(
  BuildContext context,
  String mediaUrl,
) async {
  // Validate URL first
  if (mediaUrl.isEmpty || !Uri.parse(mediaUrl).isAbsolute) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Noto'g'ri media manzili")),
    );
    return;
  }

  // Request permissions

  // Create temporary file
  final tempDir = await getTemporaryDirectory();
  final filePath =
      "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(mediaUrl)}";

  final dio = Dio();
  final progressNotifier = ValueNotifier<double>(0);
  late OverlayEntry progressOverlay;

  // Show progress dialog
  if (context.mounted) {
    progressOverlay = OverlayEntry(
      builder: (context) => AlertDialog(
        title: const Text("Yuklanmoqda..."),
        content: ValueListenableBuilder<double>(
          valueListenable: progressNotifier,
          builder: (context, value, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: value),
              const SizedBox(height: 10),
              Text("${(value * 100).toStringAsFixed(0)}%"),
            ],
          ),
        ),
      ),
    );
    Overlay.of(context).insert(progressOverlay);
  }

  try {
    // Download file
    await dio.download(
      mediaUrl,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          progressNotifier.value = received / total;
        }
      },
      deleteOnError: true,
    );

    // Verify file exists
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception("Yuklab olingan fayl topilmadi");
    }

    // Save to gallery
    final result = await ImageGallerySaverPlus.saveFile(filePath);

    if (context.mounted) {
      progressOverlay.remove();

      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Muvaffaqiyatli saqlandi!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Galereyaga saqlashda xatolik")),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      progressOverlay.remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik: ${e.toString()}")),
      );
    }

    // Clean up failed download
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  } finally {
    progressNotifier.dispose();
  }
}

String _getFileExtension(String url) {
  try {
    final uri = Uri.parse(url);
    final path = uri.path;
    final extension = path.substring(path.lastIndexOf('.'));
    return extension.isNotEmpty ? extension : '.jpg';
  } catch (_) {
    return '.jpg';
  }
}
