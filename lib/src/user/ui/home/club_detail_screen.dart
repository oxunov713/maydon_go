import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/tools/position_enum.dart';

import '../../bloc/team_cubit/team_cubit.dart';
import '../../bloc/team_cubit/team_state.dart';

class ClubDetailScreen extends StatelessWidget {
  const ClubDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tashkent Bulls"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.pushNamed(AppRoutes.clubTeammates),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/club_background.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: BlocBuilder<TeamCubit, TeamState>(
            builder: (context, state) {
              return Center(
                child: _buildFootballField(context, state.players),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,
        onPressed: () => context.read<TeamCubit>().togglePositionVisibility(),
        child: BlocBuilder<TeamCubit, TeamState>(
          builder: (context, state) {
            return Icon(
              state.showPositions ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            );
          },
        ),
      ),
    );
  }

  Widget _buildFootballField(
      BuildContext context, Map<FootballPosition, UserModel?> players) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<TeamCubit, TeamState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Attackers (3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.leftWingForward,
                  player: players[FootballPosition.leftWingForward],
                ),
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.centerForward,
                  player: players[FootballPosition.centerForward],
                ),
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.rightWingForward,
                  player: players[FootballPosition.rightWingForward],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.07),

            // Midfielders (3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.centerMidfielder,
                  player: players[FootballPosition.centerMidfielder],
                ),
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.defensiveMidfielder,
                  player: players[FootballPosition.defensiveMidfielder],
                ),
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.centerMidfielder2,
                  player: players[FootballPosition.centerMidfielder2],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.07),

            // Defenders (4)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.leftBack,
                  player: players[FootballPosition.leftBack],
                ),
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.centerBack,
                  player: players[FootballPosition.centerBack],
                ),
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.centerBack2,
                  player: players[FootballPosition.centerBack2],
                ),
                _buildPlayerAvatar(
                  context,
                  position: FootballPosition.rightBack,
                  player: players[FootballPosition.rightBack],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.07),

            // Goalkeeper
            _buildPlayerAvatar(
              context,
              position: FootballPosition.goalkeeper,
              player: players[FootballPosition.goalkeeper],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayerAvatar(
    BuildContext context, {
    required FootballPosition position,
    UserModel? player,
  }) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => _showPlayerSelectionDialog(context, position),
      child: BlocBuilder<TeamCubit, TeamState>(
        builder: (context, state) {
          return Column(
            children: [
              CircleAvatar(
                radius: size.height * 0.04,
                backgroundColor: Colors.white,
                backgroundImage: player?.imageUrl != null
                    ? NetworkImage(player!.imageUrl!)
                    : null,
                child: player == null
                    ? Icon(
                        Icons.person_add,
                        color: AppColors.green,
                        size: size.height * 0.03,
                      )
                    : null,
              ),
              if (state.showPositions) ...[
                SizedBox(height: size.height * 0.005),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    position.abbreviation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              if (player != null) ...[
                SizedBox(height: size.height * 0.005),
                SizedBox(
                  width: size.width * 0.15,
                  child: Text(
                    player.fullName?.split(' ').last ?? "No name",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _showPlayerSelectionDialog(
      BuildContext context, FootballPosition position) {
    final cubit = context.read<TeamCubit>();
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : size.width * 0.15,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Select player for ${position.fullName}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                BlocBuilder<TeamCubit, TeamState>(
                  builder: (context, state) {
                    if (state.error != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Error: ${state.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: size.height * 0.6,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.availablePlayers.length,
                        itemBuilder: (context, index) {
                          final friend = state.availablePlayers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                radius: isSmallScreen ? 22 : 28,
                                backgroundImage: friend.imageUrl != null
                                    ? NetworkImage(friend.imageUrl!)
                                    : null,
                                child: friend.imageUrl == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(
                                friend.fullName ?? 'No name',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                ),
                              ),
                              subtitle: Text(
                                position.abbreviation,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 14,
                                  color: AppColors.green,
                                ),
                              ),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                cubit.addFriendToPosition(position, friend);
                                context.pop();
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
