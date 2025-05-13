import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/user/bloc/chat_cubit/chat_cubit.dart';

import '../../../../common/service/shared_preference_service.dart';
import '../../../../common/style/app_icons.dart';

class WallpaperPage extends StatelessWidget {
  const WallpaperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wallpapers = [
      AppIcons.chatWall1,
      AppIcons.chatWall2,
      AppIcons.chatWall3,
      AppIcons.chatWall4,
      AppIcons.chatWall5,
      AppIcons.chatWall6,
      AppIcons.chatWall7,
      AppIcons.chatWall8,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Select Wallpaper")),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: wallpapers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final path = wallpapers[index];
          return GestureDetector(
            onTap: () {
              context.read<ChatCubit>().changeWallpaper(path);
              context.pop();
            },
            child: Image.asset(path, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
