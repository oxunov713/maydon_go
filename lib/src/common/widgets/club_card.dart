import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';

import '../router/app_routes.dart';
import '../style/app_colors.dart';
import '../style/app_icons.dart';

class ClubCard extends StatelessWidget {
  const ClubCard(
      {super.key,
      required this.visibleFriends,
      required this.remainingFriends,
      required this.index,
      required this.state});

  final List visibleFriends;
  final int remainingFriends;
  final int index;
  final MyClubLoaded state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      // Responsive width
      constraints: const BoxConstraints(maxWidth: 350),
      // Maksimum o'lcham
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.green, AppColors.green2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sarlavha qismi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Do'stlar: ${state.connections.length}/11",
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
            const SizedBox(height: 16),

            // Klub logotipi
            Center(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.12,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.11,
                  backgroundImage: const NetworkImage(
                    "https://brandlogos.net/wp-content/uploads/2020/08/real-madrid-logo.png",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Klub nomi
            const Center(
              child: Text(
                "Tashkent Bulls",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Do'stlar avatarlari
            Center(
              child: SizedBox(
                height: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ...List.generate(
                      visibleFriends.length,
                      (i) => Positioned(
                        left: i * 30.0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                visibleFriends[index].friend.imageUrl != null &&
                                        visibleFriends[index]
                                            .friend
                                            .imageUrl!
                                            .isNotEmpty
                                    ? AppColors.white
                                    : Colors.blue,
                            // Rasm bo'lmasa, fon rangi (Telegram uslubi)
                            backgroundImage:
                                visibleFriends[index].friend.imageUrl != null &&
                                        visibleFriends[index]
                                            .friend
                                            .imageUrl!
                                            .isNotEmpty
                                    ? NetworkImage(visibleFriends[index]
                                        .friend
                                        .imageUrl!) as ImageProvider
                                    : null,
                            child: (visibleFriends[index].friend.imageUrl ==
                                        null ||
                                    visibleFriends[index]
                                        .friend
                                        .imageUrl!
                                        .isEmpty)
                                ? Text(
                                    visibleFriends[index]
                                            .friend
                                            .fullName!
                                            .isNotEmpty
                                        ? visibleFriends[index]
                                            .friend
                                            .fullName![0]
                                            .toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white, // Oq rangda harf (aniq ko'rinishi uchun)
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    // Qolgan do'stlar soni
                    if (remainingFriends > 0)
                      Positioned(
                        left: visibleFriends.length * 30.0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.green,
                              ),
                              child: Center(
                                child: Text(
                                  "+$remainingFriends",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tugmalar paneli
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    // Chat tugmasi
                    Expanded(
                      child: TextButton.icon(
                        icon: SvgPicture.asset(
                          AppIcons.chatIcon,
                          color: AppColors.white,
                          width: 20,
                          height: 20,
                        ),
                        label: const Text(
                          'Chat',
                          style: TextStyle(color: AppColors.white),
                        ),
                        onPressed: () => context.pushNamed(AppRoutes.teamChat),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Batafsil tugmasi
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.navigate_next,
                            color: AppColors.white, size: 20),
                        label: const Text(
                          'Batafsil',
                          style: TextStyle(color: AppColors.white),
                        ),
                        onPressed: () =>
                            context.pushNamed(AppRoutes.clubDetail),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
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
}
