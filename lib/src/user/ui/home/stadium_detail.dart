import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../common/tools/average_rating_extension.dart';
import '../../../common/tools/price_formatter_extension.dart';
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
  String selectedStadium = "";

  @override
  void initState() {
    super.initState();
    selectedStadium = widget.stadium.stadiumsSlots.first.keys.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingCubit>().changeStadium(selectedStadium);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
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
                      bool isSaved = savedState is SavedStadiumsLoadedState &&
                          cubit.isStadiumSaved(widget.stadium);
                      return IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          isSaved
                              ? cubit.removeStadiumFromSaved(widget.stadium)
                              : cubit.addStadiumToSaved(widget.stadium);
                        },
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.stadium.name,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: deviceHeight * 0.025,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  background: CarouselSlider.builder(
                    itemCount: widget.stadium.images.length,
                    itemBuilder: (context, index, realIndex) {
                      return CachedNetworkImage(
                        imageUrl: widget.stadium.images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, size: 50),
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: 1.0,
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
                        horizontal: deviceWidth * 0.03,
                        vertical: deviceHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.stadium.location.address,
                            style: TextStyle(
                              fontSize: deviceHeight * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          BlocBuilder<BookingCubit, BookingState>(
                            builder: (context, state) {
                              String selectedStadium = "";
                              if (state is BookingLoaded) {
                                selectedStadium = state.selectedStadium;
                              }
                              return DropdownButton<String>(
                                value: selectedStadium.isNotEmpty
                                    ? selectedStadium
                                    : null,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<BookingCubit>().clearBooking();
                                    context
                                        .read<BookingCubit>()
                                        .changeStadium(value);
                                  }
                                },
                                items: widget.stadium.stadiumsSlots
                                    .map((stadiumSlot) {
                                  final stadiumName = stadiumSlot.keys.first;
                                  return DropdownMenuItem(
                                    value: stadiumName,
                                    child: Text(stadiumName),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          const TabBar(
                            tabs: [
                              Tab(text: "Bo'sh vaqtlar"),
                              Tab(text: "Qo'shimcha"),
                            ],
                            labelColor: AppColors.green,
                            indicatorColor: AppColors.green,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.7,
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                BlocBuilder<BookingCubit, BookingState>(
                                  builder: (context, state) {
                                    if (state is BookingLoaded) {
                                      return CustomCalendar(
                                          groupedSlots: state.groupedSlots);
                                    }
                                    return Center(
                                        child:
                                            CircularProgressIndicator()); // Agar yuklanyotgan bo‘lsa
                                  },
                                ),
                                const Center(
                                  child: Text(
                                    "Qo'shimcha ma'lumotlar",
                                    style: TextStyle(fontSize: 18),
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
              ),
            ],
          ),
          bottomNavigationBar: BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              int bookingCount =
                  state is BookingLoaded ? state.bookedSlots.length : 0;
              return BottomSignButton(
                function: () => context.pushNamed(AppRoutes.paymentPage),
                text: "Booking $bookingCount hours",
                isdisabledBT: bookingCount != 0,
              );
            },
          ),
        ),
      ),
    );
  }
}
