import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/router/app_routes.dart';
import 'package:maydon_go/src/tools/extension_custom.dart';
import 'package:provider/provider.dart';

import '../../model/stadium_model.dart';
import '../../provider/all_stadium_provider.dart';
import '../../provider/saved_stadium_provider.dart';
import '../../style/app_colors.dart';
import '../../style/app_icons.dart';
import 'stadium_detail.dart';

class AllStadiumsScreen extends StatefulWidget {
  AllStadiumsScreen();

  @override
  State<AllStadiumsScreen> createState() => _AllStadiumsScreenState();
}

class _AllStadiumsScreenState extends State<AllStadiumsScreen> {
  @override
  Widget build(BuildContext context) {
    final listen = Provider.of<StadiumProvider>(context, listen: true);
    final nolisten = Provider.of<StadiumProvider>(context, listen: false);
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        automaticallyImplyLeading: listen.isSearching ? false : true,
        title: listen.isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: listen.searchController,
                        decoration: InputDecoration(
                          hintText: 'Maydon nomi',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.black),
                        onChanged: nolisten.filterStadiums,
                      ),
                    ),
                  ],
                ),
              )
            : const Text("Barcha maydonlar"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: listen.isSearching
                ? IconButton(
                    onPressed: () {
                      nolisten.toggleSearchMode();
                    },
                    icon: Icon(Icons.close),
                  )
                : InkWell(
                    child: SvgPicture.asset(
                      AppIcons.searchIcon,
                      height: 23,
                    ),
                    onTap: nolisten.toggleSearchMode,
                  ),
          ),
        ],
      ),
      body: listen.filteredStadiums.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listen.filteredStadiums.length,
              itemBuilder: (context, stadiumIndex) {
                final stadium = listen.filteredStadiums[stadiumIndex];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: AppColors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => context.pushNamed(
                              AppRoutes.detailStadium,
                              extra: stadium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    stadium.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25),
                                  ),
                                  Card(
                                    color: AppColors.green2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            stadium.ratings.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.white),
                                          ),
                                          SizedBox(width: 5),
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
                              ),
                              SizedBox(height: 10),
                              AspectRatio(
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
                                            fit: BoxFit
                                                .cover, // Ensure the image fills the card area
                                          );
                                        }).toList(),
                                        options: CarouselOptions(
                                          aspectRatio: 16 / 9,
                                          viewportFraction: 1.0,
                                          initialPage: 0,
                                          enableInfiniteScroll: true,
                                          reverse: false,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 5),
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          enlargeFactor: 0.3,
                                          onPageChanged: (index, reason) =>
                                              nolisten.updateCurrentIndex(
                                                  index, stadiumIndex),
                                        ),
                                        carouselController:
                                            nolisten.getCarouselController(
                                                stadiumIndex),
                                      ),
                                    ),

                                    // Dotted Indicator
                                    Positioned(
                                      bottom: 10,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          stadium.images.length,
                                          (index) => AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            width: listen.currentIndexList[
                                                        stadiumIndex] ==
                                                    index
                                                ? 12
                                                : 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: listen.currentIndexList[
                                                          stadiumIndex] ==
                                                      index
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
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${stadium.price.formatWithSpace()} so'm",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      context
                                              .watch<SavedStadiumsProvider>()
                                              .isStadiumSaved(stadium)
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: AppColors.green,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      // Stadionni saqlash yoki olib tashlash
                                      if (context
                                          .read<SavedStadiumsProvider>()
                                          .isStadiumSaved(stadium)) {
                                        context
                                            .read<SavedStadiumsProvider>()
                                            .removeStadiumFromSaved(stadium);
                                      } else {
                                        context
                                            .read<SavedStadiumsProvider>()
                                            .addStadiumToSaved(stadium);
                                      }
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Bugungi bo'sh vaqtlar",
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.grey4),
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                height: 45,
                                child: ListView.separated(
                                  itemCount: nolisten
                                      .findEarliestDate(stadium.availableSlots)
                                      .values
                                      .first
                                      .length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final slots = nolisten
                                        .findEarliestDate(
                                            stadium.availableSlots)
                                        .values
                                        .first;
                                    final slot = slots[index];
                                    final startHour = slot.startTime.hour
                                        .toString()
                                        .padLeft(2, '0');
                                    final startMinute = slot.startTime.minute
                                        .toString()
                                        .padLeft(2, '0');
                                    final endHour = slot.endTime.hour
                                        .toString()
                                        .padLeft(2, '0');
                                    final endMinute = slot.endTime.minute
                                        .toString()
                                        .padLeft(2, '0');

                                    return Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
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
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
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
                              ),
                              Divider(height: 25),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border_rounded,
                                size: 30,
                              ),
                            ),
                            Text("320"),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                AppIcons.comment,
                                height: 30,
                              ),
                            ),
                            Text("75"),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
