import 'package:flutter/material.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';

import '../../../common/constants/config.dart';
import 'my_club_screen.dart';

class UserCoinsRanking extends StatelessWidget {
  UserCoinsRanking({super.key});

  final List<Map<String, dynamic>> users = [
    {'name': 'Obidjon', 'coins': 1200},
    {'name': 'Durbek', 'coins': 980},
    {'name': 'Muhamadali', 'coins': 860},
    {'name': 'Rahimjon', 'coins': 750},
    {'name': 'Azizbek', 'coins': 900},
    {'name': 'Murod', 'coins': 620},
    {'name': 'Nodir', 'coins': 590},
    {'name': 'Obidjon', 'coins': 1200},
    {'name': 'Durbek', 'coins': 980},
    {'name': 'Muhamadali', 'coins': 860},
    {'name': 'Rahimjon', 'coins': 750},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: Text("World Ranking"),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final maxCoins = users
              .map((user) => user['coins'])
              .reduce((a, b) => a > b ? a : b);
          return UserCoinsDiagram(index: index,
            userName: users[index]["name"],
            maxCoins: maxCoins,
            userAvatarUrl: $users[index].imageUrl!,
            coins: users[index]['coins'],
          );
        },
      ),
    );
  }
}
