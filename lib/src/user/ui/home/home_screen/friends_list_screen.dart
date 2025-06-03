// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
//
// import '../../../../common/style/app_colors.dart';
// import '../../../../common/model/friend_model.dart';
// import '../../../../common/model/main_model.dart';
//
// class MyFriendsList extends StatefulWidget {
//   const MyFriendsList({super.key});
//
//   @override
//   State<MyFriendsList> createState() => _MyFriendsListState();
// }
//
// class _MyFriendsListState extends State<MyFriendsList> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     // Do'stlar ro'yxatini yuklash
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       //context.read<MyClubCubit>().loadConnections();
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: BlocBuilder<MyClubCubit, MyClubState>(
//         builder: (context, state) {
//           // Loading holati
//           if (state is MyClubLoading) {
//             return const Center(
//                 child: CircularProgressIndicator(color: AppColors.green));
//           }
//
//           // Xatolik holati
//           if (state is MyClubError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(state.error, style: const TextStyle(color: Colors.grey)),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       //  context.read<MyClubCubit>().loadConnections();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.green,
//                     ),
//                     child: const Text('Qayta yuklash',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           // Do'stlar ro'yxati
//           List<Friendship> allUsers = [];
//           if (state is MyClubLoaded) {
//             allUsers = state.connections;
//           }
//
//           // Qidiruv bo'yicha filtrlash
//           final filteredUsers = allUsers.where((user) {
//             final fullName = user.friend.fullName?.toLowerCase() ?? '';
//             final username = 'sdsd';
//             return fullName.contains(_searchQuery.toLowerCase()) ||
//                 username.contains(_searchQuery.toLowerCase());
//           }).toList();
//
//           // Online foydalanuvchilarni ajratib olish
//           final onlineUsers = filteredUsers
//               .where((user) => user.friend.isOnline == true)
//               .toList();
//
//           return CustomScrollView(
//             slivers: [
//               // AppBar
//               SliverAppBar(
//                 floating: true,
//                 pinned: true,
//                 title: const Text('Do\'stlar',
//                     style: TextStyle(color: Colors.white)),
//                 actions: [
//                   IconButton(
//                     icon: const Icon(Icons.search, color: Colors.white),
//                     onPressed: () {
//                       showSearch(
//                         context: context,
//                         delegate: _FriendSearchDelegate(
//                           users: allUsers,
//                           onUserSelected: (user) {
//                             _showUserOptions(context, user.friend);
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//
//               // Do'st qo'shish button
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       // context.read<MyClubCubit>().openAddConnection(context);
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                           content: Text('Do\'stlarni qo\'shish funksiyasi')));
//                     },
//                     icon: const Icon(Icons.person_add_alt, color: Colors.white),
//                     label: const Text('Do\'st qo\'shish',
//                         style: TextStyle(color: Colors.white)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.green,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       minimumSize: const Size(double.infinity, 48),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Online do'stlar bo'limi
//               if (onlineUsers.isNotEmpty) ...[
//                 SliverToBoxAdapter(
//                   child: const Padding(
//                     padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
//                     child: Text(
//                       'Onlayn',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black54,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       final friend = onlineUsers[index].friend;
//                       return _buildUserListItem(context, friend, true);
//                     },
//                     childCount: onlineUsers.length,
//                   ),
//                 ),
//               ],
//
//               // Barcha do'stlar bo'limi
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                       left: 16,
//                       top: onlineUsers.isNotEmpty ? 16 : 8,
//                       bottom: 8),
//                   child: Text(
//                     onlineUsers.isNotEmpty ? 'Barcha do\'stlar' : 'Do\'stlar',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black54,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//
//               if (filteredUsers.isEmpty)
//                 const SliverFillRemaining(
//                   child: Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.people_outline,
//                             size: 64, color: Colors.grey),
//                         SizedBox(height: 16),
//                         Text(
//                           "Sizda hozircha do'stlar yo'q",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               else
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       final friend = filteredUsers[index].friend;
//                       // Online userslarni ikki marta ko'rsatmaslik uchun
//                       if (onlineUsers.isNotEmpty && friend.isOnline == true) {
//                         return const SizedBox.shrink();
//                       }
//                       return _buildUserListItem(context, friend, false);
//                     },
//                     childCount: filteredUsers.length,
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.green,
//         child: const Icon(Icons.edit, color: Colors.white),
//         onPressed: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Yangi chat yaratish')));
//         },
//       ),
//     );
//   }
//
//   Widget _buildUserListItem(
//       BuildContext context, UserModel user, bool isInOnlineSection) {
//     final lastSeen = DateTime.now();
//     String subtitle = '';
//
//     if (user.isOnline == true) {
//       subtitle = 'online';
//     } else if (lastSeen != null) {
//       subtitle = _formatLastSeen(lastSeen);
//     }
//
//     return ListTile(
//       leading: Stack(
//         children: [
//           CircleAvatar(
//             radius: 24,
//             backgroundColor: AppColors.green2,
//             backgroundImage: user.imageUrl != null && user.imageUrl!.isNotEmpty
//                 ? NetworkImage(user.imageUrl!)
//                 : null,
//             child: user.imageUrl == null || user.imageUrl!.isEmpty
//                 ? Text(
//                     user.fullName != null && user.fullName!.isNotEmpty
//                         ? user.fullName![0].toUpperCase()
//                         : '?',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   )
//                 : null,
//           ),
//           if (user.isOnline == true)
//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: Container(
//                 width: 13,
//                 height: 13,
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       title: Text(
//         user.fullName ?? "Noma'lum",
//         style: const TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 16,
//         ),
//       ),
//       subtitle: Text(
//         subtitle,
//         style: TextStyle(
//           color: user.isOnline == true ? Colors.green : Colors.grey,
//           fontSize: 14,
//         ),
//       ),
//       onTap: () => _showUserOptions(context, user),
//     );
//   }
//
//   String _formatLastSeen(DateTime lastSeen) {
//     final now = DateTime.now();
//     final difference = now.difference(lastSeen);
//
//     if (difference.inDays > 7) {
//       return '${lastSeen.day}.${lastSeen.month}.${lastSeen.year}';
//     } else if (difference.inDays > 0) {
//       final dayNames = [
//         'Dushanba',
//         'Seshanba',
//         'Chorshanba',
//         'Payshanba',
//         'Juma',
//         'Shanba',
//         'Yakshanba'
//       ];
//       return dayNames[lastSeen.weekday - 1];
//     } else if (difference.inHours > 0) {
//       return 'bugun';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} daqiqa oldin';
//     } else {
//       return 'hozirgina';
//     }
//   }
//
//   void _showUserOptions(BuildContext context, UserModel user) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.message, color: AppColors.green),
//               title: const Text('Xabar yozish'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // context.read<MyClubCubit>().openChatWith(user);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Xabar yozish funksiyasi')));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.call, color: AppColors.green),
//               title: const Text('Qo\'ng\'iroq qilish'),
//               onTap: () {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                     content: Text('Qo\'ng\'iroq qilish funksiyasi')));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.videocam, color: AppColors.green),
//               title: const Text('Video qo\'ng\'iroq'),
//               onTap: () {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                     content: Text('Video qo\'ng\'iroq funksiyasi')));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.info_outline, color: AppColors.green),
//               title: const Text('Ma\'lumotlarni ko\'rish'),
//               onTap: () {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                     content: Text('Profil ma\'lumotlari funksiyasi')));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.person_remove, color: Colors.red),
//               title: const Text('Do\'stlikdan chiqarish'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _confirmRemoveFriend(context, user);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _confirmRemoveFriend(BuildContext context, UserModel user) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Do\'stdan chiqarish'),
//         content: Text(
//             '${user.fullName}ni do\'stlar ro\'yxatidan o\'chirmoqchimisiz?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Bekor qilish'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // context.read<MyClubCubit>().removeFriend(user.id);
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text('${user.fullName} do\'stlardan o\'chirildi')));
//             },
//             child:
//                 const Text('O\'chirish', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Do'stlarni qidirish delegati
// class _FriendSearchDelegate extends SearchDelegate<Friendship> {
//   final List<Friendship> users;
//   final Function(Friendship) onUserSelected;
//
//   _FriendSearchDelegate({required this.users, required this.onUserSelected});
//
//   @override
//   String get searchFieldLabel => 'Do\'stlarni qidirish';
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       if (query.isNotEmpty)
//         IconButton(
//           icon: const Icon(Icons.clear),
//           onPressed: () => query = '',
//         ),
//     ];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () =>
//           close(context, users.first), // Just to satisfy return type
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return buildSuggestions(context);
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestions = users.where((user) {
//       final fullName = user.friend.fullName?.toLowerCase() ?? '';
//       final username = 'sdsds';
//       return fullName.contains(query.toLowerCase()) ||
//           username.contains(query.toLowerCase());
//     }).toList();
//
//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         final user = suggestions[index].friend;
//         return ListTile(
//           leading: CircleAvatar(
//             backgroundImage:
//                 user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
//             backgroundColor: AppColors.green2,
//             child: user.imageUrl == null || user.imageUrl!.isEmpty
//                 ? Text(
//                     user.fullName != null && user.fullName!.isNotEmpty
//                         ? user.fullName![0].toUpperCase()
//                         : '?',
//                     style: const TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                   )
//                 : null,
//           ),
//           title: Text(user.fullName ?? 'Noma\'lum'),
//           subtitle: Text('@oxunov_713'),
//           onTap: () {
//             close(context, suggestions[index]);
//             onUserSelected(suggestions[index]);
//           },
//         );
//       },
//     );
//   }
// }
