import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/model/friend_model.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:maydon_go/src/common/tools/position_enum.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:maydon_go/src/user/bloc/team_cubit/team_cubit.dart';

class ClubTeammates extends StatefulWidget {
  const ClubTeammates({super.key});

  @override
  State<ClubTeammates> createState() => _ClubTeammatesState();
}

class _ClubTeammatesState extends State<ClubTeammates> {
  @override
  void initState() {
    context.read<MyClubCubit>().loadData();
    super.initState();
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
        child: BlocBuilder<MyClubCubit, MyClubState>(
          builder: (context, state) {
            if (state is MyClubLoaded) {
              return _buildMembersList(state.connections);
            } else if (state is MyClubLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyClubError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Xatolik yuz berdi, iltimos qayta urinib ko'ring.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<MyClubCubit>().loadData(),
                      child: const Text("Qayta yuklash"),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text(context.lan.noData));
          },
        ),
      ),
    );
  }

  Widget _buildMembersList(List<Friendship> members) {
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
        final initials = _getInitials(member.friend.fullName ?? "N N");
        final imageUrl = member.friend.imageUrl;

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              member.friend.fullName ?? "Noma'lum",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(member.friend.phoneNumber ?? "Telefon raqami mavjud emas"),
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
    return name.split(' ').map((part) => part.isNotEmpty ? part[0] : '').take(2).join();
  }

  void _showRemoveConfirmation(BuildContext context, Friendship member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("A'zoni o'chirish"),
        content: Text(
          "Haqiqatan ham ${member.friend.fullName ?? 'bu a\'zoni'} jamoangizdan o'chirmoqchimisiz?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Bekor qilish"),
          ),
          TextButton(
            onPressed: () {
              context.read<TeamCubit>().removeFromPosition(FootballPosition.centerBack);
              Navigator.pop(context);
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