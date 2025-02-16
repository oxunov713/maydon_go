// ignore_for_file: unnecessary_const

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/style/app_colors.dart';
import '../../bloc/my_club_cubit/my_club_cubit.dart';

class MyClubScreen extends StatelessWidget {
  const MyClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MaydonGo")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: BlocBuilder<MyClubCubit, MyClubState>(
          builder: (context, state) {
            if (state is MyClubLoaded) {
              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Your friends",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                                    radius: 30,
                                    backgroundColor: Colors.blueGrey.shade100,
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
                                  "Add",
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
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.blueGrey.shade100,
                                backgroundImage: user.imageUrl != null &&
                                        user.imageUrl!.isNotEmpty
                                    ? NetworkImage(user.imageUrl!)
                                    : const AssetImage(
                                            "assets/images/ronaldu_avatar.jpg")
                                        as ImageProvider,
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
