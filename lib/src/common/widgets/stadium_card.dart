import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../model/stadium_model.dart';
import '../style/app_colors.dart';
import '../style/app_icons.dart';
import '../tools/price_formatter_extension.dart';

class StadiumCard extends StatelessWidget {
  final StadiumDetail stadium;
  final int stadiumIndex;

  final Function(StadiumDetail) onTap;

  const StadiumCard({
    super.key,
    required this.stadium,
    required this.stadiumIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    // Fetch authentication state

    return GestureDetector(
      onTap: () {
        // Proceed with the action if the user is authenticated
        onTap(stadium);
            },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleAndRating(context, stadium, stadiumIndex),
              const SizedBox(height: 10),
              _buildCarousel(stadium, stadiumIndex),
              const SizedBox(height: 12),
              _buildPriceAndBookmark(context, stadium),
              const Text(
                "Bugungi bo'sh vaqtlar",
                style: TextStyle(fontSize: 14, color: AppColors.grey4),
              ),
              const SizedBox(height: 10),
              _buildAvailableSlots(stadium),
              const Divider(height: 25),
              _buildLocation(deviceWidth, stadium),
            ],
          ),
        ),
      ),
    );
  }


  Row _buildTitleAndRating(BuildContext context, StadiumDetail stadium, int stadiumIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${stadiumIndex + 1}. ${stadium.name}",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
        Card(
          color: AppColors.green2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            child: Row(
              children: [
                const Text(
                  // You can add a rating here if available
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 5),
                Image.asset(
                  AppIcons.stars,
                  height: 15,
                  width: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AspectRatio _buildCarousel(StadiumDetail stadium, int stadiumIndex) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          // CarouselSlider for images
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CarouselSlider(
              items: stadium.images.map((imageUrl) {
                return Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                );
              }).toList(),
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
              ),
            ),
          ),
          // Dotted Indicator (optional)
        ],
      ),
    );
  }

  Row _buildPriceAndBookmark(BuildContext context, StadiumDetail stadium) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${stadium.price.formatWithSpace()} so'm",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ],
    );
  }

  SizedBox _buildAvailableSlots(StadiumDetail stadium) {
    return const SizedBox();
  }

  Row _buildLocation(double deviceWidth, StadiumDetail stadium) {
    return Row(
      children: [
        const Icon(Icons.location_on),
        const SizedBox(width: 10),
        SizedBox(
          width: deviceWidth - 150,
          child: Text(
            stadium.location.address,
            style: const TextStyle(
                fontSize: 14,
                color: AppColors.main,
                overflow: TextOverflow.visible),
          ),
        ),
      ],
    );
  }
}
