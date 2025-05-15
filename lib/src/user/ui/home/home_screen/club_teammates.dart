import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/friend_model.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:maydon_go/src/common/tools/position_enum.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:maydon_go/src/user/bloc/team_cubit/team_cubit.dart';
import 'package:maydon_go/src/user/bloc/team_cubit/team_state.dart';

import '../../../../common/model/team_model.dart';

class ClubTeammates extends StatefulWidget {
  const ClubTeammates({super.key, required this.club});

  final ClubModel club;

  @override
  State<ClubTeammates> createState() => _ClubTeammatesState();
}

class _ClubTeammatesState extends State<ClubTeammates> {
  @override
  void initState() {
    super.initState();
    context.read<TeamCubit>().initialize(widget.club.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: const Text("Tashkent Bulls"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TeamCubit, TeamState>(
          builder: (context, state) {
            return _buildMembersList(state.club.members);
          },
        ),
      ),
    );
  }

  Widget _buildMembersList(List<MemberModel> members) {
    if (members.isEmpty) {
      return Center(
        child: Text(
          "Jamoa a'zolari hozircha mavjud emas",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: members.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final member = members[index];
        final initials = _getInitials(member.username);
        final imageUrl = member.userImage;

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.green.withOpacity(0.2),
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? Text(
                      initials,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            title: Text(
              member.username,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(member.position),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle, color: AppColors.red),
              onPressed: () => _showRemoveConfirmation(context, member),
            ),
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    return name
        .split(' ')
        .map((part) => part.isNotEmpty ? part[0] : '')
        .take(2)
        .join();
  }

  void _showRemoveConfirmation(BuildContext context, MemberModel member) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("A'zoni o'chirish"),
        content: Text(
          "Haqiqatan ham ${member.username} jamoangizdan o'chirmoqchimisiz?",
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(), // ✅ GoRouter usuli
            child: const Text("Bekor qilish"),
          ),
          TextButton(
            onPressed: () async {
              await context.read<MyClubCubit>().removeMember(
                    clubId: widget.club.id,
                    memberId: member.id, // ✅ Bu `ChatMember.id` bo‘lishi kerak
                  );
              context.read<TeamCubit>().initialize(widget.club.id);
              if (context.mounted) {
                dialogContext.pop(); // ✅ Dialogni yopish
              }
            },
            child: const Text(
              "O'chirish",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
