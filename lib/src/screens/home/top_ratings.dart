import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/stadium_model.dart';
import '../../provider/top_rating_provider.dart';
import '../../style/app_colors.dart';
import '../../widgets/stadium_card.dart';
import 'stadium_detail.dart';

class TopRatings extends StatelessWidget {
  const TopRatings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: const Text("Top reyting"),
      ),
      body: Consumer<TopRatingProvider>(
        builder: (context, provider, child) {
          if (provider.stadiums.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: provider.stadiums.length,
            itemBuilder: (context, stadiumIndex) {
              final stadium = provider.stadiums[stadiumIndex];
              return StadiumCard(
                stadium: stadium,
                stadiumIndex: stadiumIndex,
                provider: provider,
                onTap: (stadium) => _navigateToDetailScreen(context, stadium),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToDetailScreen(BuildContext context, Stadium stadium) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StadiumDetailScreen(stadium: stadium),
      ),
    );
  }
}