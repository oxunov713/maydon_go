import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';

import 'my_club_screen.dart';

class UserCoinsRanking extends StatefulWidget {
  const UserCoinsRanking({super.key});

  @override
  State<UserCoinsRanking> createState() => _UserCoinsRankingState();
}

class _UserCoinsRankingState extends State<UserCoinsRanking> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    context.read<MyClubCubit>().loadData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: Text("World Ranking"),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<MyClubCubit, MyClubState>(
        builder: (context, state) {
          if (state is MyClubLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
              ),
            );
          }

          if (state is MyClubError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.error,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => context.read<MyClubCubit>().loadData(),
                    child: Text(
                      "Refresh",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is MyClubLoaded) {
            final users = state.liderBoard;

            if (users.isEmpty) {
              return Center(
                child: Text(
                  "No data",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<MyClubCubit>().loadData(),
              color: AppColors.green,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return UserCoinsDiagram(
                      index: index,
                      userName: user.fullName ?? "No name",
                      userAvatarUrl: user.imageUrl,
                      coins: user.points,
                    );
                  },
                ),
              ),
            );
          }

          return Center(
            child: Text(context.lan.noData),
          );
        },
      ),
    );
  }
}
