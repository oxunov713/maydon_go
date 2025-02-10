import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/tools/average_rating_extension.dart';
import '../../../common/tools/price_formatter_extension.dart';
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
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        automaticallyImplyLeading:
            context.watch<StadiumCubit>().state is StadiumLoaded &&
                    (context.watch<StadiumCubit>().state as StadiumLoaded)
                        .isSearching
                ? false
                : true,
        title: context.watch<StadiumCubit>().state is StadiumLoaded &&
                (context.watch<StadiumCubit>().state as StadiumLoaded)
                    .isSearching
            ? _buildSearchField(context)
            : const Text("Barcha maydonlar"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: context.watch<StadiumCubit>().state is StadiumLoaded &&
                    (context.watch<StadiumCubit>().state as StadiumLoaded)
                        .isSearching
                ? IconButton(
                    onPressed: () =>
                        context.read<StadiumCubit>().toggleSearchMode(),
                    icon: const Icon(Icons.close),
                  )
                : InkWell(
                    child: SvgPicture.asset(
                      AppIcons.searchIcon,
                      height: 23,
                    ),
                    onTap: () =>
                        context.read<StadiumCubit>().toggleSearchMode(),
                  ),
          ),
        ],
      ),
      body: BlocBuilder<StadiumCubit, StadiumState>(
        builder: (context, state) {
          if (state is StadiumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StadiumError) {
            return Center(child: Text(state.message));
          } else if (state is StadiumLoaded) {
            return ListView.builder(
              itemCount: state.filteredStadiums.length,
              itemBuilder: (context, stadiumIndex) {
                final stadium = state.filteredStadiums[stadiumIndex];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: AppColors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    stadium.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: deviceHeight * 0.025,
                                    ),
                                  ),
                                ),
                                Card(
                                  color: AppColors.green2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: deviceHeight * 0.005,
                                      horizontal: deviceWidth * 0.02,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: deviceWidth * 0.01),
                                          child: Text(
                                            stadium.ratings.average.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.white,
                                              fontSize: deviceHeight * 0.015,
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          AppIcons.stars,
                                          height: deviceHeight * 0.02,
                                          width: deviceWidth * 0.04,
                                        ),
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CarouselSlider(
                                      items: stadium.images.map((imageUrl) {
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Center(
                                              child: Icon(Icons.error,
                                                  size: 50, color: Colors.red),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      options: CarouselOptions(
                                        aspectRatio: 16 / 9,
                                        viewportFraction: 1.0,
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 7),
                                        enlargeCenterPage: true,
                                        onPageChanged: (index, reason) =>
                                            context
                                                .read<StadiumCubit>()
                                                .updateCurrentIndex(
                                                    index, stadiumIndex),
                                      ),
                                      carouselController: context
                                          .read<StadiumCubit>()
                                          .getCarouselController(stadiumIndex),
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
                                              const Duration(milliseconds: 300),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          width: state.currentIndexList[
                                                      stadiumIndex] ==
                                                  index
                                              ? 12
                                              : 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: state.currentIndexList[
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
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${stadium.price.formatWithSpace()} so'm",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: deviceHeight * 0.025,
                                  ),
                                ),
                                BlocBuilder<SavedStadiumsCubit,
                                    SavedStadiumsState>(
                                  builder: (context, savedState) {
                                    final cubit =
                                        context.read<SavedStadiumsCubit>();

                                    bool isSaved = false;
                                    if (savedState
                                        is SavedStadiumsLoadedState) {
                                      isSaved = cubit.isStadiumSaved(stadium);
                                    }

                                    return IconButton(
                                      icon: Icon(
                                        isSaved
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: AppColors.green,
                                      ),
                                      onPressed: () {
                                        if (isSaved) {
                                          cubit.removeStadiumFromSaved(stadium);
                                        } else {
                                          cubit.addStadiumToSaved(stadium);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: deviceWidth,
                              child: Text(
                                "Bugungi bo'sh vaqtlar",
                                style: TextStyle(
                                  fontSize: deviceHeight * 0.017,
                                  color: AppColors.grey4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: deviceHeight * 0.04,
                              child: stadium.availableSlots.isNotEmpty &&
                                      stadium.availableSlots.values.first
                                          .isNotEmpty
                                  ? ListView.separated(
                                      itemCount: stadium
                                          .availableSlots.values.first.length,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 10),
                                      itemBuilder: (context, index) {
                                        final slots =
                                            stadium.availableSlots.values.first;
                                        final slot = slots[index];
                                        final startHour = slot.startTime.hour
                                            .toString()
                                            .padLeft(2, '0');
                                        final startMinute = slot
                                            .startTime.minute
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
                                          decoration: const BoxDecoration(
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
                                                fontSize: deviceHeight * 0.015,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: deviceWidth * 0.9,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: AppColors.red,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Barcha soatlar band",
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: deviceHeight * 0.018,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            const Divider(height: 30),
                            GestureDetector(
                              onTap: () => context.pushNamed(
                                AppRoutes.detailStadium,
                                extra: stadium,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on),
                                      SizedBox(width: deviceWidth * 0.02),
                                      SizedBox(
                                        width: deviceWidth - 150,
                                        child: Text(
                                          stadium.location.address,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: deviceHeight * 0.015,
                                              color: AppColors.main,
                                              overflow: TextOverflow.visible),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward_outlined,
                                      color: AppColors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
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
}
