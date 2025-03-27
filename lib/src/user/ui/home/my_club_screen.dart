import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:maydon_go/src/user/bloc/booking_cubit/booking_cubit.dart';
import 'package:maydon_go/src/user/ui/home/other_user_profile.dart';
import '../../../common/constants/config.dart';
import '../../../common/model/time_slot_model.dart';
import '../../../common/service/booking_service.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../../common/widgets/home_menu_widget.dart';
import '../../bloc/my_club_cubit/my_club_cubit.dart';

class MyClubScreen extends StatefulWidget {
  const MyClubScreen({super.key});

  @override
  State<MyClubScreen> createState() => _MyClubScreenState();
}

class _MyClubScreenState extends State<MyClubScreen> {
  @override
  void initState() {
    context.read<MyClubCubit>().loadData();
    super.initState();
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
      body: RefreshIndicator(
        onRefresh: () => context.read<MyClubCubit>().loadData(),
        color: AppColors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: BlocBuilder<MyClubCubit, MyClubState>(
            builder: (context, state) {
              Logger().e(state);
              if (state is MyClubLoaded) {
                int maxLength = 0;
                (state.user.subscriptionModel?.name == "Go+")
                    ? maxLength = 100
                    : maxLength = 10;
                //todo limit qo'yish kerak 10talik uchun
                int itemCount = state.connections.length;
                return CustomScrollView(
                  slivers: [
                    //Friends
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your friends",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              "${state.connections.length}/$maxLength",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                            if (index == 0 &&
                                state.connections.length < maxLength) {
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor: AppColors.green,
                                    child: CircleAvatar(
                                      radius: 32,
                                      backgroundColor: AppColors.white,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          size: 30,
                                          color: AppColors.green,
                                        ),
                                        onPressed: () async {
                                          showSearch(
                                            context: context,
                                            delegate: UserSearchDelegate(
                                              context.read<MyClubCubit>(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Add friends",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            }

                            final friendship = state.connections[index - 1];
                            final friend = friendship.friend;

                            return BlocBuilder<MyClubCubit, MyClubState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return OtherUserProfile(user: friend);
                                        },
                                      ),
                                      child: CircleAvatar(
                                          radius: 35,
                                          backgroundColor: AppColors.white,
                                          backgroundImage: getUserImage(
                                              userAvatarUrl: friend.imageUrl)),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      friend.fullName ?? "No Name",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    //Clubs
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your clubs",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              "2/2",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.4, // Responsive height
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 16),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            final visibleFriends =
                                state.connections.take(3).toList();
                            final remainingFriends =
                                state.connections.length - 3;

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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Do'stlar: ${state.connections.length}/11",
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(Icons.more_vert,
                                            color: Colors.white),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Klub logotipi
                                    Center(
                                      child: CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.12,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.2),
                                        child: CircleAvatar(
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.11,
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
                                                      backgroundImage:
                                                          getUserImage(
                                                              userAvatarUrl:
                                                                  visibleFriends[
                                                                          index]
                                                                      .friend
                                                                      .imageUrl)),
                                                ),
                                              ),
                                            ),

                                            // Qolgan do'stlar soni
                                            if (remainingFriends > 0)
                                              Positioned(
                                                left: visibleFriends.length *
                                                    30.0,
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
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                  style: TextStyle(
                                                      color: AppColors.white),
                                                ),
                                                onPressed: () =>
                                                    context.pushNamed(
                                                        AppRoutes.teamChat),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.white
                                                      .withOpacity(0.1),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Batafsil tugmasi
                                            Expanded(
                                              child: TextButton.icon(
                                                icon: const Icon(
                                                    Icons.navigate_next,
                                                    color: AppColors.white,
                                                    size: 20),
                                                label: const Text(
                                                  'Batafsil',
                                                  style: TextStyle(
                                                      color: AppColors.white),
                                                ),
                                                onPressed: () =>
                                                    context.pushNamed(
                                                        AppRoutes.clubDetail),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.white
                                                      .withOpacity(0.2),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
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
                    SliverToBoxAdapter(
                      child: BlocBuilder<MyClubCubit, MyClubState>(
                        builder: (context, state) {
                          if (state is MyClubLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is MyClubLoaded) {
                            final liders = state.liderBoard;
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.75,
                              ),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 80),
                                itemCount: liders.length,
                                itemBuilder: (context, index) {
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
                              ),
                            );
                          }
                          return const Center(
                            child: Text("No data"),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is MyClubLoading) {
                return const Center(child: CircularProgressIndicator());
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

    final bgColor = backgroundColor ?? (Colors.white);
    final primaryTextColor = textColor ?? (Colors.black);
    final secondaryTextColor = Colors.grey[600]!;
    final coinColor = Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
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
          ]),
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
              child: CircleAvatar(
                radius: size.width * 0.055,
                backgroundImage: getUserImage(userAvatarUrl: userAvatarUrl),
              ),
            ),
          ),

          // User ma'lumotlari
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

          // Coinlar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: coinColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on, size: 18, color: coinColor),
                const SizedBox(width: 4),
                Text(
                  coins.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: coinColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserSearchDelegate extends SearchDelegate<String> {
  final MyClubCubit myClubCubit;
  Timer? _debounce;

  UserSearchDelegate(this.myClubCubit)
      : super(keyboardType: TextInputType.number);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        shadowColor: Colors.transparent,
      ),
      textTheme: const TextTheme(titleLarge: TextStyle(color: Colors.white)),
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white, selectionColor: AppColors.grey4),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.green,
        hintStyle: TextStyle(color: Colors.white70),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.green,
          ), // Aktiv chiziq
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white70, width: 1), // Normal chiziq
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildUserList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      myClubCubit.searchUsers(query);
    });

    return ColoredBox(color: AppColors.white2, child: _buildUserList());
  }

  Widget _buildUserList() {
    return BlocBuilder<MyClubCubit, MyClubState>(
      bloc: myClubCubit,
      builder: (context, state) {
        if (state is MyClubLoaded) {
          final results = state.searchResults;
          if (results.isEmpty) {
            return const Center(child: Text("No results found"));
          }

          final connectedUsers = results
              .where((user) => myClubCubit.isConnected(user.id!))
              .toList();
          final notConnectedUsers = results
              .where((user) => !myClubCubit.isConnected(user.id!))
              .toList();

          final sortedUsers = [...connectedUsers, ...notConnectedUsers];

          return ListView.builder(
            itemCount: sortedUsers.length,
            itemBuilder: (context, index) {
              final user = sortedUsers[index];
              final isConnected = myClubCubit.isConnected(user.id!);

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      user.imageUrl != null && user.imageUrl!.isNotEmpty
                          ? NetworkImage(user.imageUrl!)
                          : const AssetImage("assets/images/ronaldu_avatar.jpg")
                              as ImageProvider,
                ),
                title: Text("${user.fullName}"),
                subtitle: Text(user.phoneNumber ?? ""),
                trailing: IconButton(
                  icon: Icon(
                    isConnected ? Icons.person_remove : Icons.person_add,
                    color: isConnected ? Colors.red : Colors.green,
                  ),
                  onPressed: () {
                    myClubCubit.toggleConnection(user);
                  },
                ),
              );
            },
          );
        }
        return const Center(
            child: CircularProgressIndicator(
          color: AppColors.green,
        ));
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
