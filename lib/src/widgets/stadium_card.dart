import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:maydon_go/src/tools/extension_custom.dart';
import 'package:provider/provider.dart';

import '../model/stadium_model.dart';
import '../provider/saved_stadium_provider.dart';
import '../provider/top_rating_provider.dart';
import '../style/app_colors.dart';
import '../style/app_icons.dart';

class StadiumCard extends StatelessWidget {
  final Stadium stadium;
  final int stadiumIndex;
  final provider;
  final Function(Stadium) onTap;

  const StadiumCard({
    super.key,
    required this.stadium,
    required this.stadiumIndex,
    required this.provider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => onTap(stadium),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card title with rating
              _buildTitleAndRating(context, stadium, stadiumIndex),
              const SizedBox(height: 10),
              _buildCarousel(stadium, provider, stadiumIndex),
              SizedBox(height: 12),
              _buildPriceAndBookmark(context, stadium),

              Text(
                "Bugungi bo'sh vaqtlar",
                style: TextStyle(fontSize: 14, color: AppColors.grey4),
              ),
              SizedBox(
                height: 10,
              ),
              _buildAvailableSlots(provider, stadium),
              Divider(height: 25),
              _buildLocation(deviceWidth, stadium),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTitleAndRating(
      BuildContext context, Stadium stadium, int stadiumIndex) {
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
                Text(
                  stadium.ratings.toStringAsFixed(1),
                  style: const TextStyle(
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
        )
      ],
    );
  }

  AspectRatio _buildCarousel(
      Stadium stadium, TopRatingProvider provider, int stadiumIndex) {
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
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                onPageChanged: (index, reason) =>
                    provider.updateCurrentIndex(index, stadiumIndex),
              ),
              carouselController: provider.getCarouselController(stadiumIndex),
            ),
          ),

          // Dotted Indicator
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stadium.images.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width:
                      provider.currentIndexList[stadiumIndex] == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: provider.currentIndexList[stadiumIndex] == index
                        ? AppColors.green2
                        : AppColors.grey4,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildPriceAndBookmark(BuildContext context, Stadium stadium) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${stadium.price.formatWithSpace()} so'm",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        IconButton(
          icon: Icon(
            context.watch<SavedStadiumsProvider>().isStadiumSaved(stadium)
                ? Icons.bookmark
                : Icons.bookmark_border,
            color: AppColors.green,
            size: 30,
          ),
          onPressed: () {
            // Stadionni saqlash yoki olib tashlash
            if (context.read<SavedStadiumsProvider>().isStadiumSaved(stadium)) {
              context
                  .read<SavedStadiumsProvider>()
                  .removeStadiumFromSaved(stadium);
            } else {
              context.read<SavedStadiumsProvider>().addStadiumToSaved(stadium);
            }
          },
        )
      ],
    );
  }

  SizedBox _buildAvailableSlots(TopRatingProvider provider, Stadium stadium) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        itemCount: provider
            .findEarliestDate(stadium.availableSlots)
            .values
            .first
            .length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final slots =
              provider.findEarliestDate(stadium.availableSlots).values.first;
          final slot = slots[index];
          final startHour = slot.startTime.hour.toString().padLeft(2, '0');
          final startMinute = slot.startTime.minute.toString().padLeft(2, '0');
          final endHour = slot.endTime.hour.toString().padLeft(2, '0');
          final endMinute = slot.endTime.minute.toString().padLeft(2, '0');

          return Container(
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: AppColors.green40,
            ),
            child: Center(
              child: Text(
                "$startHour:$startMinute - $endHour:$endMinute",
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row _buildLocation(double deviceWidth, Stadium stadium) {
    return Row(
      children: [
        Icon(Icons.location_on),
        SizedBox(width: 10),
        SizedBox(
          width: deviceWidth - 150,
          child: Text(
            stadium.location.address,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.main,
                overflow: TextOverflow.visible),
          ),
        ),
      ],
    );
  }
}
