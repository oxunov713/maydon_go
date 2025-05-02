import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:story_view/story_view.dart';

import '../../../../common/style/app_colors.dart';

class StoryScreen extends StatefulWidget {
  final List<String> mediaUrls;
  final List<String> mediaTypes;
  final UserModel user;

  const StoryScreen({
    super.key,
    required this.mediaUrls,
    required this.mediaTypes,
    required this.user,
  });

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late StoryController _storyController;

  List<String> _viewedUsers = []; // List to track who viewed the story
  Map<int, List<String>> _storyComments =
      {}; // To store comments for each story

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();
  }



  void _addViewedUser(int index, String userName) {
    if (!_viewedUsers.contains(userName)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // O'zgartirishlar bu yerda bo'ladi, masalan:
          _viewedUsers.add(userName);
        });
      });
    }
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
              // This ensures the StoryView takes up the full screen
              child: StoryView(
                storyItems: storyItems,
                controller: _storyController,
                indicatorOuterPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                indicatorHeight: IndicatorHeight.medium,
                onStoryShow: (storyItem, index) {
                  _addViewedUser(index, widget.user.fullName ?? "Unknown User");
                },
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar
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
                  SizedBox(width: 8),
                  // Full Name and Subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.fullName ?? "No name", // Display full name
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.user.phoneNumber ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70, // Lighter color for subtitle
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chat Button at the bottom
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    isScrollControlled: true,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Text(
                                'Viewed by',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _viewedUsers.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Text(_viewedUsers[index][0]
                                            .toUpperCase()),
                                      ),
                                      title: Text(_viewedUsers[index]),
                                    );
                                  },
                                ),
                              ),


                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      _viewedUsers.length.toString(),
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
