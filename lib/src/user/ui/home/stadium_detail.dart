import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/common/tools/average_rating_extension.dart';
import 'package:maydon_go/src/common/tools/price_formatter_extension.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/router/app_routes.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/sign_button.dart';
import '../../bloc/booking_cubit/booking_cubit.dart';
import '../../bloc/booking_cubit/booking_state.dart';
import '../../bloc/saved_stadium_cubit/saved_stadium_cubit.dart';
import '../../bloc/saved_stadium_cubit/saved_stadium_state.dart';

class StadiumDetailScreen extends StatelessWidget {
  final Stadium stadium;

  const StadiumDetailScreen({super.key, required this.stadium});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    // Responsivlik uchun asosiy o'lchamlar
    final double titleFontSize = deviceHeight * 0.025;
    final double addressFontSize = deviceHeight * 0.02;
    final double priceFontSize = deviceHeight * 0.03;
    final double ratingFontSize = deviceHeight * 0.015;
    final double iconSize = deviceHeight * 0.02;
    final double tabBarHeight = deviceHeight;
    final double paddingHorizontal = deviceWidth * 0.03;
    final double paddingVertical = deviceHeight * 0.02;

    // Mavjud vaqtlarni guruhlash
    final groupedSlots = <String, List<TimeSlot>>{};
    for (var entry in stadium.availableSlots.entries) {
      final dateKey = DateFormat("yyyy-MM-dd").format(entry.key);
      if (!groupedSlots.containsKey(dateKey)) {
        groupedSlots[dateKey] = [];
      }
      groupedSlots[dateKey]!.addAll(entry.value);
    }

    return BlocProvider(
      create: (context) => BookingCubit(),
      child: DefaultTabController(
        length: 2, // Ikkita tab
        child: SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  expandedHeight: deviceHeight * 0.25,
                  actions: [
                    BlocBuilder<SavedStadiumsCubit, SavedStadiumsState>(
                      builder: (context, savedState) {
                        final cubit = context.read<SavedStadiumsCubit>();

                        bool isSaved = false;
                        if (savedState is SavedStadiumsLoadedState) {
                          isSaved = cubit.isStadiumSaved(stadium);
                        }

                        return IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: AppColors.white,
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
                  flexibleSpace: FlexibleSpaceBar(
                    title: Padding(
                      padding:  EdgeInsets.only(right: deviceWidth*0.1),
                      child: Text(
                        stadium.name,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    background: CarouselSlider.builder(
                      itemCount: stadium.images.length,
                      itemBuilder: (context, index, realIndex) {
                        return SizedBox(
                          width: deviceWidth,
                          child: CachedNetworkImage(
                            imageUrl: stadium.images[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, size: 50),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        viewportFraction: 1.0,
                        initialPage: 0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                      ),
                    ),
                  ),
                ),
                // Sanalar qatorini tepada to'xtatish uchun

                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontal,
                          vertical: paddingVertical,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          stadium.location.address,
                                          style: TextStyle(
                                            fontSize: addressFontSize,
                                            color: AppColors.main,
                                            fontWeight: FontWeight.bold,
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
                                                  stadium.ratings.average
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.white,
                                                    fontSize: ratingFontSize,
                                                  ),
                                                ),
                                              ),
                                              Image.asset(
                                                AppIcons.stars,
                                                height: iconSize,
                                                width: iconSize,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: deviceWidth,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "${stadium.price.formatWithSpace()} so'm",
                                      style: TextStyle(
                                        fontSize: priceFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            const TabBar(
                              tabs: [
                                Tab(text: "Bo'sh vaqtlar"),
                                Tab(text: "Qo'shimcha"),
                              ],
                              labelColor: AppColors.green,
                              labelStyle: TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600),
                              unselectedLabelColor: AppColors.grey4,
                              indicatorColor: AppColors.green,
                            ),
                            // TabBarView uchun joy
                            SizedBox(
                              height: tabBarHeight,
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  CustomCalendar(groupedSlots: groupedSlots),
                                  ListView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    children: const [
                                      Text(
                                        "Qo'shimcha ma'lumotlar",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                int bookingCount = 0;
                if (state is BookingUpdated) {
                  bookingCount = state.bookedSlots.length;
                }
                return BottomSignButton(
                  function: () => context.pushNamed(AppRoutes.paymentPage),
                  text: "Booking $bookingCount hours",
                  isdisabledBT: bookingCount != 0,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
