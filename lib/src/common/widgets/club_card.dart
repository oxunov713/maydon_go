import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maydon_go/src/common/model/team_model.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';

import '../router/app_routes.dart';
import '../style/app_colors.dart';
import '../style/app_icons.dart';

class ClubCard extends StatelessWidget {
  const ClubCard({
    super.key,
    required this.visibleFriends,
    required this.remainingFriends,
    required this.index,
    required this.clubId,
    required this.chatId,
    required this.state,
    required this.isOwnedByUser,
    required this.imageUrl,
  });

  final List<MemberModel> visibleFriends;
  final String? imageUrl;
  final int remainingFriends;
  final int index;
  final int clubId;
  final int chatId;
  final MyClubLoaded state;
  final bool isOwnedByUser;

  void _showEditClubModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sozlamalar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: AppColors.green),
                title: const Text("Rasmni almashtirish"),
                onTap: () {
                  context.pop();
                  _pickAndUploadImage(
                      context, clubId); // clubId ni shu yerda berasiz
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: AppColors.green),
                title: const Text(
                  "Nomni tahrirlash",
                ),
                onTap: () {
                  context.pop();
                  _showEditNameDialog(context); // Klub nomi uchun dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.red),
                title: const Text(
                  "Klubni o'chirish",
                  style: TextStyle(
                      color: AppColors.red, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  context.pop();
                  _showDeleteClubDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context, int clubId) async {
    final cubit = context.read<MyClubCubit>(); // ✅ avval cubit ni saqlab olish

    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      cubit.updateClubImage(
          clubId, pickedFile.path); // ✅ context ishlatilmayapti
    }
  }

  void _showEditNameDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              spacing: 24,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Klub nomini tahrirlash',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => context.pop(),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Klub nomi',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      prefixIcon: Icon(Icons.group, color: Colors.green[600]),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.green[400]!, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Iltimos, klub nomini kiriting';
                      }
                      if (value.trim().length < 3) {
                        return 'Nom juda qisqa (kamida 3 ta belgi)';
                      }
                      return null;
                    },
                  ),
                ),

                BlocBuilder<MyClubCubit, MyClubState>(
                  builder: (context, state) {
                    final isLoading = state is MyClubLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isLoading ? Colors.green[300] : Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (formKey.currentState?.validate() ?? false) {
                                  context.read<MyClubCubit>().updateClub(
                                      clubId, controller.text.trim());
                                  context.pop();
                                }
                              },
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Saqlash',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteClubDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Klubni o‘chirish',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[800],
                              ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Message
                const Text(
                  'Bu amalni tasdiqlaysizmi?\nKlubni o‘chirsangiz, barcha maʼlumotlar ham o‘chiriladi.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                /// Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Bekor qilish"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<MyClubCubit>().deleteClub(clubId);
                          context.pop();
                        },
                        child: const Text(
                          "O‘chirish",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      constraints: const BoxConstraints(maxWidth: 350),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isOwnedByUser
            ? const LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
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
                  "Do'stlar: ${state.clubs[index].members.length}/11",
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                isOwnedByUser
                    ? GestureDetector(
                        onTap: () => _showEditClubModal(context),
                        child: const Icon(Icons.more_vert, color: Colors.white))
                    : SizedBox()
              ],
            ),
            const SizedBox(height: 16),

            // Klub logotipi
            Center(
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageUrl == null
                        ? AssetImage(AppIcons.clubImage) as ImageProvider
                        : NetworkImage(imageUrl!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Klub nomi
            Center(
              child: Column(
                children: [
                  Text(
                    state.clubs[index].name,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isOwnedByUser)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "You",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                ],
              ),
            ),

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
                                visibleFriends[i].userImage != null &&
                                        visibleFriends[i].userImage!.isNotEmpty
                                    ? AppColors.white
                                    : Colors.blue,
                            backgroundImage:
                                visibleFriends[i].userImage != null &&
                                        visibleFriends[i].userImage!.isNotEmpty
                                    ? NetworkImage(visibleFriends[i].userImage!)
                                        as ImageProvider
                                    : null,
                            child: (visibleFriends[i].userImage == null ||
                                    visibleFriends[i].userImage!.isEmpty)
                                ? Text(
                                    visibleFriends[i].username.isNotEmpty
                                        ? visibleFriends[i]
                                            .username[0]
                                            .toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                        onPressed: () => context.pushNamed(AppRoutes.teamChat,
                            extra: chatId),
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
                        onPressed: () => context.pushNamed(AppRoutes.clubDetail,
                            extra: state.clubs[index]),
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
