import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/user/ui/home/other_user_profile.dart';
import '../../../common/constants/config.dart';
import '../../../common/style/app_colors.dart';
import '../../bloc/my_club_cubit/my_club_cubit.dart';

class MyClubScreen extends StatelessWidget {
  MyClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: const Text("MaydonGo"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: BlocBuilder<MyClubCubit, MyClubState>(
          builder: (context, state) {
            if (state is MyClubLoaded) {
              return CustomScrollView(
                slivers: [
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
                            "${state.connections.length}/10",
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
                        itemCount: state.connections.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          if (index == 0) {
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
                                      onPressed: () {
                                        showSearch(
                                          context: context,
                                          delegate: UserSearchDelegate(
                                              context.read<MyClubCubit>()),
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
                          final user = state.connections[index - 1];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  // Agar kontent katta bo'lsa, scroll qilish uchun
                                  backgroundColor: Colors.transparent,
                                  // Orqa fonni shaffof qilish
                                  builder: (context) {
                                    return OtherUserProfile(user: user);
                                  },
                                ),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: AppColors.white,
                                  backgroundImage: user.imageUrl != null &&
                                          user.imageUrl!.isNotEmpty
                                      ? NetworkImage(user.imageUrl!)
                                      : const AssetImage(
                                              "assets/images/ronaldu_avatar.jpg")
                                          as ImageProvider,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                user.firstName ?? "No Name",
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
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
                  )),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 5),
                        itemCount: 2,
                        itemBuilder: (context, index) => Container(
                          width: 200,
                          decoration: BoxDecoration(
                              color: AppColors.green3,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Players",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "3/11",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          "https://brandlogos.net/wp-content/uploads/2020/08/real-madrid-logo.png",
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Text(
                                      "Tashkent Bulls",
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    GestureDetector(
                                      onTap: () => context
                                          .pushNamed(AppRoutes.clubDetail),
                                      child: Container(
                                        height: 30,
                                        width: 200,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        decoration: BoxDecoration(
                                            color: AppColors.blue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: Center(
                                          child: Text(
                                            "View",
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                    child: SizedBox(
                      height: height * 0.62,
                      child: BlocBuilder<MyClubCubit, MyClubState>(
                          builder: (context, state) {
                        if (state is MyClubLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is MyClubLoaded) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.searchResults.length,
                            itemBuilder: (context, index) {
                              final maxCoins = state.searchResults
                                  .map((user) => user.point)
                                  .reduce((a, b) => a! > b! ? a : b);
                              return UserCoinsDiagram(
                                userName:
                                    state.searchResults[index].firstName ??
                                        "No name",
                                maxCoins: maxCoins ?? 15,
                                index: index,
                                userAvatarUrl: $users[index].imageUrl!,
                                coins: state.searchResults[index].point ?? 1,
                              );
                            },
                          );
                        }
                        return Center(
                          child: Text("No data"),
                        );
                      }),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class UserCoinsDiagram extends StatelessWidget {
  final String userName;
  final String userAvatarUrl;
  final int coins;
  final int maxCoins;
  final int index;

  UserCoinsDiagram({
    required this.userName,
    required this.userAvatarUrl,
    required this.coins,
    required this.maxCoins,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
      child: Row(
        children: [
          Center(
            child: Text(
              "${index + 1}) ",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.03),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userAvatarUrl),
                radius: height * 0.025,
              ),
              SizedBox(
                width: width * 0.15,
                child: Text(
                  userName,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: height * 0.012,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: height * 0.03,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: coins / maxCoins,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: height * 0.03,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        '$coins coins',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
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

  UserSearchDelegate(this.myClubCubit);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          myClubCubit.searchUsers('');
        },
      ),
    ];
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
    // Debounce to prevent excessive searches
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      myClubCubit.searchUsers(query);
    });

    return _buildUserList();
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

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final user = results[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      user.imageUrl != null && user.imageUrl!.isNotEmpty
                          ? NetworkImage(user.imageUrl!)
                          : const AssetImage("assets/images/ronaldu_avatar.jpg")
                              as ImageProvider,
                ),
                title: Text("${user.firstName} ${user.lastName}"),
                subtitle: Text(user.contactNumber ?? ""),
                trailing: IconButton(
                  icon: const Icon(Icons.person_add, color: Colors.green),
                  onPressed: () {
                    myClubCubit.addConnection(user);
                    close(context, "");
                  },
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
