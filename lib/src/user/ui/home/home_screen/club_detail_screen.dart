import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/model/team_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';
import 'package:maydon_go/src/common/tools/position_enum.dart';
import 'package:maydon_go/src/user/bloc/auth_cubit/auth_cubit.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:maydon_go/src/user/bloc/profile_cubit/profile_cubit.dart';
import '../../../bloc/team_cubit/team_cubit.dart';
import '../../../bloc/team_cubit/team_state.dart';

class ClubDetailScreen extends StatefulWidget {
  const ClubDetailScreen({super.key, required this.club});

  final ClubModel club;

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeamCubit>().initialize(widget.club.id);
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<TeamCubit>().state.club.ownerId ==
        context.read<MyClubCubit>().user.id;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.club.name),
        centerTitle: true,
        actions: [
          BlocBuilder<TeamCubit, TeamState>(
            builder: (context, state) {
              final isAdmin =
                  state.club.ownerId == context.read<MyClubCubit>().user.id;

              if (isAdmin) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    context.pushNamed(AppRoutes.clubTeammates, extra: widget.club);
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.red),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.logout,
                                  size: 48, color: AppColors.red),
                              const SizedBox(height: 16),
                              const Text(
                                'Klubdan chiqishni istaysizmi?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Bu amalni bekor qilib bo‘lmaydi.',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        // ❗️Navigator emas, dialog context!
                                        dialogContext.pop(false);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.grey4,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      child: const Text('Bekor qilish'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        dialogContext.pop(true);
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: AppColors.red,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Chiqish',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    if (confirmed == true) {
                      final userId = context.read<MyClubCubit>().user.id;

                      // ✅ 1. ChatMemberni topish
                      final chatMember = state.club.members.firstWhere(
                        (member) => member.userId == userId,
                        orElse: () => throw Exception('ChatMember topilmadi'),
                      );

                      // ✅ 2. memberId sifatida ChatMember.id uzatish
                      context.read<MyClubCubit>().removeMember(
                            clubId: state.club.id,
                            memberId: chatMember.id, // << to‘g‘ri ID
                          );

                      if (context.mounted) {
                        context.goNamed(AppRoutes.home);
                      }
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppIcons.clubN1),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: BlocBuilder<TeamCubit, TeamState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null) {
                return Center(child: Text('Error: ${state.error}'));
              }
              final players = _mapMembersToPositions(state.players);
              return Center(
                child: _buildFootballField(context, players),
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

  Map<FootballPosition, MemberModel?> _mapMembersToPositions(
      List<MemberModel> members) {
    final Map<FootballPosition, MemberModel?> players = {
      for (var pos in FootballPosition.values) pos: null,
    };
    for (var member in members) {
      final position = FootballPosition.values.firstWhere(
        (pos) => pos.abbreviation == member.position,
        orElse: () => FootballPosition.goalkeeper,
      );
      players[position] = member;
    }
    return players;
  }

  Widget _buildFootballField(
    BuildContext context,
    Map<FootballPosition, MemberModel?> players,
  ) {
    final size = MediaQuery.of(context).size;
    final isAdmin = context.read<TeamCubit>().state.club.ownerId ==
        context.read<MyClubCubit>().user.id;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Attackers (3)
        _buildPositionRow(context,
            positions: [
              FootballPosition.leftWingForward,
              FootballPosition.centerForward,
              FootballPosition.rightWingForward,
            ],
            players: players,
            isAdmin: isAdmin),
        SizedBox(height: size.height * 0.05),
        // Midfielders (3)
        _buildPositionRow(context,
            positions: [
              FootballPosition.centerMidfielder,
              FootballPosition.defensiveMidfielder,
              FootballPosition.centerMidfielder2,
            ],
            players: players,
            isAdmin: isAdmin),
        SizedBox(height: size.height * 0.05),
        // Defenders (4)
        _buildPositionRow(
          context,
          positions: [
            FootballPosition.leftBack,
            FootballPosition.centerBack,
            FootballPosition.centerBack2,
            FootballPosition.rightBack,
          ],
          isAdmin: isAdmin,
          players: players,
        ),
        SizedBox(height: size.height * 0.05),
        // Goalkeeper
        _buildPlayerContainer(
          context,
          position: FootballPosition.goalkeeper,
          player: players[FootballPosition.goalkeeper],
          isAdmin: isAdmin,
        ),
      ],
    );
  }

  Widget _buildPositionRow(
    BuildContext context, {
    required List<FootballPosition> positions,
    required Map<FootballPosition, MemberModel?> players,
    required bool isAdmin,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: positions.map((position) {
        return _buildPlayerContainer(
          context,
          position: position,
          player: players[position],
          isAdmin: isAdmin,
        );
      }).toList(),
    );
  }

  Widget _buildPlayerContainer(
    BuildContext context, {
    required FootballPosition position,
    MemberModel? player,
    required bool isAdmin,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPlayerAvatar(
          context,
          position: position,
          player: player,
          isAdmin: isAdmin,
        ),
        const SizedBox(height: 4),
        (player != null)
            ? SizedBox(
                width: 70,
                child: Text(
                  player.username.split(' ').last,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : SizedBox(
                width: 70,
                child: Text(""),
              ),
      ],
    );
  }

  Widget _buildPlayerAvatar(
    BuildContext context, {
    required FootballPosition position,
    MemberModel? player,
    required bool isAdmin,
  }) {
    final size = MediaQuery.of(context).size;
    final cubit = context.read<TeamCubit>();
    final showPositions = cubit.state.showPositions;

    return GestureDetector(
      onTap: isAdmin && player == null
          ? () => _showPlayerSelectionDialog(context, position, player)
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.height * 0.08,
            height: size.height * 0.08,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: player == null
                    ? Colors.grey.withOpacity(0.5)
                    : AppColors.green,
                width: 2,
              ),
              color:
                  player == null ? Colors.grey.withOpacity(0.2) : Colors.white,
            ),
            child: player != null
                ? CircleAvatar(
                    radius: size.height * 0.04,
                    backgroundColor: Colors.transparent,
                    backgroundImage: player.userImage != null
                        ? NetworkImage(player.userImage!)
                        : null,
                    child: player.userImage == null
                        ? Text(
                            player.username.isNotEmpty
                                ? player.username[0].toUpperCase()
                                : '',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  )
                : isAdmin
                    ? Icon(
                        Icons.person_add,
                        color: Colors.grey.withOpacity(0.7),
                        size: size.height * 0.03,
                      )
                    : Icon(
                        Icons.person_outline,
                        color: Colors.grey.withOpacity(0.7),
                        size: size.height * 0.03,
                      ),
          ),
          if (showPositions) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
        ],
      ),
    );
  }

  void _showPlayerSelectionDialog(
    BuildContext context,
    FootballPosition position,
    MemberModel? currentPlayer,
  ) {
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
