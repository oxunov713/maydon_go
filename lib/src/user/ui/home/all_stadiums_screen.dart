import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/tools/extension_custom.dart';

import '../../../common/model/stadium_model.dart';
import '../../../common/router/app_routes.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../bloc/all_stadium_cubit/all_stadium_cubit.dart';
import '../../bloc/all_stadium_cubit/all_stadium_state.dart';
import '../../bloc/saved_stadium_cubit/saved_stadium_cubit.dart';
import '../../bloc/saved_stadium_cubit/saved_stadium_state.dart';

class AllStadiumsScreen extends StatelessWidget {
  const AllStadiumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      // appBar: AppBar(
      //   automaticallyImplyLeading: context.watch<StadiumCubit>().state.isSearching ? false : true,
      //   title: context.watch<StadiumCubit>().state.isSearching
      //       ? _buildSearchField(context)
      //       : const Text("Barcha maydonlar"),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 10),
      //       child: context.watch<StadiumCubit>().state.isSearching
      //           ? IconButton(
      //         onPressed: () => context.read<StadiumCubit>().toggleSearchMode(),
      //         icon: const Icon(Icons.close),
      //       )
      //           : InkWell(
      //         child: SvgPicture.asset(
      //           AppIcons.searchIcon,
      //           height: 23,
      //         ),
      //         onTap: () => context.read<StadiumCubit>().toggleSearchMode(),
      //       ),
      //     ),
      //   ],
      // ),
      // body: BlocBuilder<StadiumCubit, StadiumState>(
      //   builder: (context, state) {
      //     if (state is StadiumLoading) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (state is StadiumError) {
      //       return Center(child: Text(state.message));
      //     } else if (state is StadiumLoaded) {
      //       return ListView.builder(
      //         itemCount: state.filteredStadiums.length,
      //         itemBuilder: (context, stadiumIndex) {
      //           final stadium = state.filteredStadiums[stadiumIndex];
      //           return _buildStadiumCard(context, stadium, stadiumIndex, state);
      //         },
      //       );
      //     }
      //     return const Center(child: Text('No data available'));
      //   },
      // ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final cubit = context.read<StadiumCubit>();
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(Icons.search, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: cubit.searchController,
              decoration: const InputDecoration(
                hintText: 'Maydon nomi',
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: cubit.filterStadiums,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStadiumCard(BuildContext context, Stadium stadium,
      int stadiumIndex, StadiumLoaded state) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () =>
                  context.pushNamed(AppRoutes.detailStadium, extra: stadium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stadium.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 25),
                      ),
                      Card(
                        color: AppColors.green2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                stadium.averageRating.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white),
                              ),
                              const SizedBox(width: 5),
                              Image.asset(AppIcons.stars,
                                  height: 15, width: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              onPageChanged: (index, reason) => context
                                  .read<StadiumCubit>()
                                  .updateCurrentIndex(index, stadiumIndex),
                            ),
                            //  carouselController: context.read<StadiumCubit>().getCarouselController(stadiumIndex),
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
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                width: state.currentIndexList[stadiumIndex] ==
                                        index
                                    ? 12
                                    : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: state.currentIndexList[stadiumIndex] ==
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
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${stadium.price.formatWithSpace()} so'm",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      // BlocBuilder<SavedStadiumsCubit, SavedStadiumsState>(
                      //   builder: (context, savedState) {
                      //     return IconButton(
                      //       icon: Icon(
                      //         savedState.savedStadiums.contains(stadium)
                      //             ? Icons.bookmark
                      //             : Icons.bookmark_border,
                      //         color: AppColors.green,
                      //         size: 30,
                      //       ),
                      //       onPressed: () {
                      //         if (savedState.savedStadiums.contains(stadium)) {
                      //           context
                      //               .read<SavedStadiumsCubit>()
                      //               .removeStadiumFromSaved(stadium);
                      //         } else {
                      //           context
                      //               .read<SavedStadiumsCubit>()
                      //               .addStadiumToSaved(stadium);
                      //         }
                      //       },
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Bugungi bo'sh vaqtlar",
                    style: TextStyle(fontSize: 14, color: AppColors.grey4),
                  ),
                  const SizedBox(height: 5),
                  Row(
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
                  ),
                  const Divider(height: 25),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_rounded, size: 30),
                ),
                const Text("320"),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(AppIcons.comment, height: 30),
                ),
                const Text("75"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
