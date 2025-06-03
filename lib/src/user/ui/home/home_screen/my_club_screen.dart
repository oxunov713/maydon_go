import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/widgets/create_club.dart';
import 'package:maydon_go/src/user/ui/home/profile_screen/profile_screen.dart';

import '../../../../common/tools/language_extension.dart';
import '../../../../common/constants/config.dart';
import '../../../../common/router/app_routes.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/widgets/club_card.dart';
import '../../../../common/widgets/custom_coin.dart';
import '../../../../common/widgets/premium_widget.dart';
import '../../../../common/widgets/story_avatar.dart';
import '../../../bloc/my_club_cubit/fab_visibility_cubit.dart';
import '../../../bloc/my_club_cubit/my_club_cubit.dart';

class MyClubScreen extends StatefulWidget {
  const MyClubScreen({super.key});

  @override
  State<MyClubScreen> createState() => _MyClubScreenState();
}

class _MyClubScreenState extends State<MyClubScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final fabCubit = context.read<FabVisibilityCubit>();
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      fabCubit.hide();
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      fabCubit.show();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: Text(context.lan.appName),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: BlocBuilder<FabVisibilityCubit, bool>(
        builder: (context, isVisible) {
          return AnimatedSlide(
            offset: isVisible ? Offset.zero : const Offset(0, 2),
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isVisible ? 1 : 0,
              child: FloatingActionButton(
                backgroundColor: AppColors.green3,
                onPressed: () {
                  context.pushNamed(AppRoutes.messages);
                },
                child: const Icon(
                  Icons.chat,
                  color: AppColors.white,
                ),
              ),
            ),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<MyClubCubit>().loadData(),
        color: AppColors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: BlocBuilder<MyClubCubit, MyClubState>(
            builder: (context, state) {
              if (state is MyClubLoaded) {
                int maxLength = GoPlusSubscriptionFeatures.friendsLength;

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    //Friends

                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: state.connections.length < maxLength
                              ? state.connections.length + 1
                              : state.connections.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            // === "Your Story" ===
                            if (index == 0 &&
                                state.connections.length < maxLength) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      showComingSoonDialog(context);
                                      //await showAddStoryDialog(context);
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: AppColors.green2,
                                          backgroundImage:
                                              (state.user.imageUrl != null &&
                                                      state.user.imageUrl!
                                                          .isNotEmpty)
                                                  ? CachedNetworkImageProvider(
                                                      state.user.imageUrl!)
                                                  : null,
                                          child: (state.user.imageUrl == null ||
                                                  state.user.imageUrl!.isEmpty)
                                              ? Text(
                                                  state.user.fullName!
                                                          .isNotEmpty
                                                      ? state.user.fullName![0]
                                                          .toUpperCase()
                                                      : '?',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.white,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.white,
                                          child: const Icon(
                                            Icons.add_circle,
                                            color: Colors.blueAccent,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Your Story",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            }

                            // === Friend's Stories ===
                            final friendship = state.connections[index - 1];
                            final friend = friendship.friend;

                            return GestureDetector(
                              onTap: () {
                                List<String> mediaUrls = [
                                  "https://static.dw.com/image/52159051_702.jpg",
                                  "https://i.pinimg.com/736x/10/12/1c/10121c6ec2d43d330c894e58319d5bcf.jpg",
                                  "https://maydon-go.s3.eu-north-1.amazonaws.com/test_video.mp4",
                                  "https://www.film.ru/sites/default/files/people/_tmdb/Xx9eyFGi1BeQoROXhdxF2qWOfS.jpg"
                                ];

                                List<String> mediaTypes = [
                                  'image', // Image
                                  'image', // Image
                                  'video', // Image'
                                  'image', // Image
                                ];

                                // context.pushNamed(AppRoutes.story, extra: {
                                //   "url": mediaUrls,
                                //   "types": mediaTypes,
                                //   "user": friend,
                                //   'chatId': friendship.chatId
                                // });
                                showComingSoonDialog(context);
                              },
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 4,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.visibility),
                                            title: Text('Hikoyani ko‘rish'),
                                            onTap: () {
                                              context.pop();
                                              List<String> mediaUrls = [
                                                "https://cdn.marvel.com/content/1x/avengersendgame_lob_crd_05.jpg",
                                                "https://i.pinimg.com/736x/10/12/1c/10121c6ec2d43d330c894e58319d5bcf.jpg",
                                                "https://maydon-go.s3.eu-north-1.amazonaws.com/%D0%97%D0%B0%D0%BF%D0%B8%D1%81%D1%8C+%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0+%D0%BE%D1%82+21.03.2025+14%3A47%3A19.webm",
                                              ];

                                              List<String> mediaTypes = [
                                                'image', // Image
                                                'image', // Image
                                                'video', // Image
                                              ];

                                              context.pushNamed(AppRoutes.story,
                                                  extra: {
                                                    "url": mediaUrls,
                                                    "types": mediaTypes,
                                                    "user": friend,
                                                    'chatId': friendship.chatId
                                                  });
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text('Profilga o‘tish'),
                                            onTap: () {
                                              context.pop(context);
                                              context.pushNamed(
                                                AppRoutes.profileChat,
                                                extra: {
                                                  'receivedUser': friend,
                                                  // UserModel
                                                  'chatId': friendship.chatId,
                                                },
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.message),
                                            title: Text('Xabar yuborish'),
                                            onTap: () {
                                              context.pop();
                                              final user = context
                                                  .read<MyClubCubit>()
                                                  .user;

                                              context.pushNamed(
                                                AppRoutes.chat,
                                                extra: {
                                                  'currentUser': user,
                                                  'receiverUser': friend,
                                                  "chatId": friendship.chatId,
                                                },
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.person_remove,
                                                color: Colors.red),
                                            title: Text('Do‘stdan chiqarish',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onTap: () {
                                              context.pop();
                                              context
                                                  .read<MyClubCubit>()
                                                  .removeConnection(friend);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Column(
                                children: [
                                  buildStoryAvatar(
                                    hasSeenStory: false, // <-- Important
                                    imageUrl: friend.imageUrl,
                                    fullName: friend.fullName,
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      friend.fullName ?? "No Name",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    //Clubs
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15, right: 5),
                        child: Text(
                          "Your clubs",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: state.clubs.isEmpty
                            ? Center(
                                child: GestureDetector(
                                  onTap: () => showCreateClubDialog(context),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(16),
                                    color: Colors.grey,
                                    dashPattern: [6, 3],
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6, // Kattaroq qilish
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.add,
                                                size: 40, color: Colors.grey),
                                            SizedBox(height: 12),
                                            Text(
                                              "Sizda hali klublar yo'q\nYangi klub yarating",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.separated(

                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 16),
                                itemCount: state.clubs.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < state.clubs.length) {
                                    final club = state.clubs[index];
                                    final isOwnedByUser =
                                        club.ownerId == state.user.id;
                                    final visibleFriends =
                                        club.members.take(3).toList();

                                    final remainingFriends =
                                        club.members.length > 3
                                            ? club.members.length - 3
                                            : 0;

                                    return ClubCard(
                                      visibleFriends: visibleFriends,
                                      remainingFriends: remainingFriends,
                                      index: index,
                                      state: state,
                                      imageUrl: club.imageUrl,
                                      isOwnedByUser: isOwnedByUser,
                                      clubId: club.id,
                                      chatId: club.chatId,
                                    );
                                  } else {
                                    // Bu holatda index == state.clubs.length, ya'ni oxirgi "Create Club" item
                                    return GestureDetector(
                                      onTap: () =>
                                          showCreateClubDialog(context),
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(16),
                                        color: Colors.grey,
                                        dashPattern: [6, 3],
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          padding: EdgeInsets.all(16),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.add,
                                                    size: 40,
                                                    color: Colors.grey),
                                                SizedBox(height: 8),
                                                Text("Create Club",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                      ),
                    ),
                    //LiderBoard
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "World ranking",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.pushNamed(AppRoutes.coinsRanking),
                              child: Text(
                                "Barchasi",
                                style: TextStyle(
                                    fontSize: 15, color: AppColors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<MyClubCubit, MyClubState>(
                      builder: (context, state) {
                        if (state is MyClubLoading) {
                          return SliverToBoxAdapter(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is MyClubLoaded) {
                          final liders = state.liderBoard;

                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  child: UserCoinsDiagram(
                                    userName:
                                        liders[index].fullName ?? "No name",
                                    index: index,
                                    userAvatarUrl: liders[index].imageUrl,
                                    coins: liders[index].points,
                                  ),
                                );
                              },
                              childCount: liders.length,
                            ),
                          );
                        }

                        return SliverToBoxAdapter(
                          child: const Center(
                            child: Text("No data"),
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else if (state is MyClubLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.green,));
              } else if (state is MyClubError) {
                return ListView(
                    padding: EdgeInsets.only(top: 250),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Text(
                            "Xatolik yuz berdi, iltimos qayta urinib ko‘ring."),
                      )
                    ]);
              }
              return Center(
                child: Text(context.lan.noData),
              );
            },
          ),
        ),
      ),
    );
  }
}

class UserCoinsDiagram extends StatelessWidget {
  final String userName;
  final String? userAvatarUrl;
  final int coins;
  final int index;
  final Color? backgroundColor;
  final Color? textColor;

  const UserCoinsDiagram({
    super.key,
    required this.userName,
    required this.userAvatarUrl,
    required this.coins,
    required this.index,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    final bgColor = backgroundColor ?? Colors.white;
    final primaryTextColor = textColor ?? Colors.black;
    final secondaryTextColor = Colors.grey[600]!;
    final coinColor = Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            alignment: Alignment.center,
            child: Text(
              "${index + 1}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: secondaryTextColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
              radius: size.width * 0.06,
              backgroundColor: theme.cardColor,
              child: userAvatarUrl != null && userAvatarUrl!.isNotEmpty
                  ? CircleAvatar(
                      radius: size.width * 0.055,
                      backgroundImage:
                          CachedNetworkImageProvider(userAvatarUrl!),
                    )
                  : CircleAvatar(
                      radius: size.width * 0.055,
                      backgroundColor: AppColors.green2,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : "?",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          Expanded(
            child: Text(
              userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryTextColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: coinColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatCoins(coins),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: coinColor,
                  ),
                ),
                const SizedBox(width: 4),
                CustomPaint(
                  size: const Size(20, 20),
                  painter: CoinPainter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kattaroq raqamlarni qisqartirib formatlaydi (masalan: 1.2K, 3.4M)
  String formatCoins(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}
