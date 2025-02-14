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

class StadiumDetailScreen extends StatefulWidget {
  final StadiumDetail stadium;

  const StadiumDetailScreen({super.key, required this.stadium});

  @override
  State<StadiumDetailScreen> createState() => _StadiumDetailScreenState();
}

class _StadiumDetailScreenState extends State<StadiumDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.stadium.stadiumsSlots.isNotEmpty) {
      context
          .read<BookingCubit>()
          .setSelectedDate(widget.stadium.stadiumsSlots.first.keys.first);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
  }

  void _scrollToToday() {
    final keys = widget.stadium.stadiumsSlots
        .first[context.read<BookingCubit>().selectedDate]?.keys
        .map((date) => DateFormat("yyyy-MM-dd").format(date))
        .toList();
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if (keys != null && keys.contains(today)) {
      final todayIndex = keys.indexOf(today);
      _scrollController.animateTo(
        todayIndex * 60.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

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
    final double tabBarHeight =
        deviceHeight * 0.7; // TabBarView uchun balandlik
    final double paddingHorizontal = deviceWidth * 0.03;
    final double paddingVertical = deviceHeight * 0.02;

    return DefaultTabController(
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
                        isSaved = cubit.isStadiumSaved(widget.stadium);
                      }

                      return IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          if (isSaved) {
                            cubit.removeStadiumFromSaved(widget.stadium);
                          } else {
                            cubit.addStadiumToSaved(widget.stadium);
                          }
                        },
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: EdgeInsets.only(right: deviceWidth * 0.1),
                    child: Text(
                      widget.stadium.name,
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
                    itemCount: widget.stadium.images.length,
                    itemBuilder: (context, index, realIndex) {
                      return SizedBox(
                        width: deviceWidth,
                        child: CachedNetworkImage(
                          imageUrl: widget.stadium.images[index],
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
                                        widget.stadium.location.address,
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
                                                widget.stadium.ratings.average
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BlocBuilder<BookingCubit, BookingState>(
                                      builder: (context, state) {
                                        return DropdownMenu<String>(
                                          initialSelection: context
                                              .read<BookingCubit>()
                                              .selectedDate,
                                          onSelected: (String? value) {
                                            if (value != null) {
                                              context
                                                  .read<BookingCubit>()
                                                  .setSelectedDate(value);

                                              context
                                                  .read<BookingCubit>()
                                                  .changeStadium(value);
                                              _scrollToToday();
                                            }
                                          },
                                          dropdownMenuEntries: widget
                                              .stadium.stadiumsSlots
                                              .map((stadiumSlot) {
                                            final stadiumName =
                                                stadiumSlot.keys.first;
                                            return DropdownMenuEntry<String>(
                                              value: stadiumName,
                                              label: stadiumName,
                                            );
                                          }).toList(),
                                          menuStyle: MenuStyle(
                                            backgroundColor:
                                                const WidgetStatePropertyAll(
                                                    AppColors.white),
                                            shape: WidgetStatePropertyAll<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: const BorderSide(
                                                  color: AppColors.green,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          textStyle: TextStyle(
                                            fontSize: deviceHeight * 0.02,
                                            color: AppColors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          inputDecorationTheme:
                                              InputDecorationTheme(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                color: AppColors.green,
                                                width: 1,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                color: AppColors.green,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                color: AppColors.green,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Narxi:",
                                          style: TextStyle(
                                            fontSize: deviceHeight * 0.02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: deviceWidth * 0.45,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            "${widget.stadium.price.formatWithSpace()} so'm",
                                            style: TextStyle(
                                                fontSize: priceFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.green,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
                                letterSpacing: 1, fontWeight: FontWeight.w600),
                            unselectedLabelColor: AppColors.grey4,
                            indicatorColor: AppColors.green,
                          ),
                          // TabBarView uchun joy
                          SizedBox(
                            height: tabBarHeight,
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                BlocBuilder<BookingCubit, BookingState>(
                                  builder: (context, state) {
                                    final groupedSlots =
                                        <String, List<TimeSlot>>{};
                                    final selectedStadiumSlots =
                                        widget.stadium.stadiumsSlots.firstWhere(
                                              (stadium) =>
                                                  stadium.keys.first ==
                                                  context
                                                      .read<BookingCubit>()
                                                      .selectedDate,
                                              orElse: () => {},
                                            )[context
                                                .read<BookingCubit>()
                                                .selectedDate] ??
                                            {};

                                    for (var entry
                                        in selectedStadiumSlots.entries) {
                                      final dateKey = DateFormat("yyyy-MM-dd")
                                          .format(entry.key);
                                      if (!groupedSlots.containsKey(dateKey)) {
                                        groupedSlots[dateKey] = [];
                                      }
                                      groupedSlots[dateKey]!
                                          .addAll(entry.value);
                                    }

                                    return CustomCalendar(
                                        scrollController: _scrollController,
                                        groupedSlots: groupedSlots);
                                  },
                                ),
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
              return BottomSignButton(
                function: () => context.pushNamed(AppRoutes.paymentPage),
                text: "Booking  hours",
                isdisabledBT: true,
              );
            },
          ),
        ),
      ),
    );
  }
}
