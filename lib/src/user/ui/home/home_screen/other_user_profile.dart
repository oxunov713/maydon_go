import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/common/service/url_launcher_service.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';

import '../../../../common/model/main_model.dart';
import '../../../../common/router/app_routes.dart';
import '../../../../common/widgets/custom_coin.dart';
import '../../../bloc/my_club_cubit/my_club_cubit.dart';
import 'chat_screen.dart';

class OtherUserProfilePage extends StatefulWidget {
  final UserModel receivedUser;
  final UserModel currentUser;
  final int id;

  const OtherUserProfilePage({
    super.key,
    required this.receivedUser,
    required this.currentUser,
    required this.id,
  });

  @override
  _OtherUserProfilePageState createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () async {
              await UrlLauncherService.callPhoneNumber(
                  widget.receivedUser.phoneNumber ?? "0");
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'remove_friend') {
                context.goNamed(AppRoutes.home);
                context
                    .read<MyClubCubit>()
                    .removeConnection(widget.receivedUser);
              } else if (value == 'delete_chat') {
                //context.read<ChatCubit>().deleteChat();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'remove_friend',
                child: ListTile(
                  dense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  visualDensity: VisualDensity.compact,
                  leading: Icon(
                    Icons.person_remove,
                    color: AppColors.red,
                  ),
                  title: Text(
                    'Remove Friend',
                    style: TextStyle(
                        color: AppColors.red, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.receivedUser.imageUrl != null &&
                              widget.receivedUser.imageUrl!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenImagePage(
                                  imageUrl: widget.receivedUser.imageUrl!,
                                ),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.green2,
                          radius: 40,
                          backgroundImage:
                              widget.receivedUser.imageUrl != null &&
                                      widget.receivedUser.imageUrl!.isNotEmpty
                                  ? NetworkImage(widget.receivedUser.imageUrl!)
                                  : null,
                          child: widget.receivedUser.imageUrl == null ||
                                  widget.receivedUser.imageUrl!.isEmpty
                              ? Text(
                                  (widget.receivedUser.fullName ?? "U")
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.receivedUser.fullName.toString(),
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "last seen recently",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: AppColors.greenDark,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                              "Coins",
                              widget.currentUser.point.toString(),
                              Icons.videogame_asset),
                          _buildStatItem("Games", "8", Icons.videogame_asset),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("Friends", "36", Icons.group),
                          _buildStatItem("Clubs", "5", Icons.sports_soccer),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 90,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      currentUser: widget.currentUser,
                      receiverUser: widget.receivedUser,
                      chatId: widget.id,
                    ),
                  ),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blue,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Icon(CupertinoIcons.chat_bubble_text,
                    color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Text(
          NumberFormat.decimalPattern('en').format(int.tryParse(count)),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }
}
class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: InteractiveViewer(
            child: Hero(
              tag: imageUrl,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
