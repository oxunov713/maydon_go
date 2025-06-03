import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/substadium_model.dart';
import 'package:maydon_go/src/common/tools/average_rating_extension.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:vibration/vibration.dart';
import '../../../../common/model/stadium_model.dart';
import '../../../../common/model/time_slot_model.dart';
import '../../../../common/tools/price_formatter_extension.dart';
import '../../../../common/router/app_routes.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_icons.dart';
import '../../../bloc/all_stadium_cubit/all_stadium_cubit.dart';
import '../../../bloc/all_stadium_cubit/all_stadium_state.dart';
import '../../../bloc/saved_stadium_cubit/saved_stadium_cubit.dart';
import '../../../bloc/saved_stadium_cubit/saved_stadium_state.dart';

class AllStadiumsScreen extends StatefulWidget {
  const AllStadiumsScreen({super.key});

  @override
  State<AllStadiumsScreen> createState() => _AllStadiumsScreenState();
}

class _AllStadiumsScreenState extends State<AllStadiumsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      double currentScroll = _scrollController.position.pixels;
      await context.read<StadiumCubit>().fetchStadiums();
      _scrollController.animateTo(
        currentScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final lan = context.lan;

    return Scaffold(
      backgroundColor: AppColors.white2,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context, lan),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<StadiumCubit>().refreshStadiums();
        },
        displacement: 40,
        color: AppColors.green,
        backgroundColor: AppColors.white,
        child: BlocBuilder<StadiumCubit, StadiumState>(
          builder: (context, state) {
            if (state is StadiumLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.green));
            } else if (state is StadiumError) {
              return _buildErrorWidget(context, state);
            } else if (state is StadiumLoaded) {
              return _buildStadiumList(
                  context, state, deviceWidth, deviceHeight, lan);
            } else {
              return Center(child: Text(lan.noData));
            }
          },
        ),
      ),

    );
  }

  AppBar _buildAppBar(BuildContext context, lan) {
    final stadiumCubit = context.watch<StadiumCubit>();
    final state = stadiumCubit.state;
    final isSearching = state is StadiumLoaded && state.isSearching;

    return AppBar(
      automaticallyImplyLeading: false,
      title: isSearching ? _buildSearchField(context) : Text(lan.all_stadiums),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            onPressed: () => stadiumCubit.toggleSearchMode(),
            icon: Icon(isSearching ? Icons.close : Icons.search),
          ),
        ),
      ],
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
              decoration: InputDecoration(
                hintText: context.lan.search_placeholder,
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

  Widget _buildErrorWidget(BuildContext context, StadiumError state) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 250),
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        Center(child: Text("Xatolik yuz berdi, iltimos qayta urinib ko‘ring."))
      ],
    );
  }

  Widget _buildStadiumList(BuildContext context, StadiumLoaded state,
      double deviceWidth, double deviceHeight, lan) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.filteredStadiums.length,
      itemBuilder: (context, stadiumIndex) {
        final stadium = state.filteredStadiums[stadiumIndex];
        final today = DateTime.now();
        final todaySlots = _getAvailableTodaySlots(stadium.fields!, today);
        return _buildStadiumCard(context, stadium, todaySlots, deviceWidth,
            deviceHeight, lan, stadiumIndex, state);
      },
    );
  }

  Widget _buildStadiumCard(
      BuildContext context,
      StadiumDetail stadium,
      List<TimeSlot> todaySlots,
      double deviceWidth,
      double deviceHeight,
      lan,
      int stadiumIndex,
      StadiumLoaded state) {
    return BlocProvider(
      // BlocProvider ni shu yerga ko'chiramiz
      create: (context) => SavedStadiumsCubit(),
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
              _buildStadiumHeader(context, stadium, deviceHeight, deviceWidth),
              const SizedBox(height: 10),
              _buildStadiumImages(
                  context, stadium, deviceHeight, stadiumIndex, state),
              const SizedBox(height: 12),
              _buildStadiumPriceAndSave(context, stadium, deviceHeight),
              const SizedBox(height: 10),
              _buildAvailableSlots(
                  context, todaySlots, deviceWidth, deviceHeight, lan),
              const Divider(height: 30),
              _buildStadiumLocation(
                  context, stadium, deviceWidth, deviceHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStadiumHeader(BuildContext context, StadiumDetail stadium,
      double deviceHeight, double deviceWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            stadium.name.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: deviceHeight * 0.025,
            ),
          ),
        ),
        _buildRatingCard(stadium, deviceHeight, deviceWidth),
      ],
    );
  }

  Widget _buildRatingCard(
      StadiumDetail stadium, double deviceHeight, double deviceWidth) {
    return Card(
      color: AppColors.green2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: deviceHeight * 0.005,
          horizontal: deviceWidth * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: deviceWidth * 0.01),
              child: Text(
                stadium.averageRating.toString(),
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
    );
  }

  Widget _buildStadiumImages(BuildContext context, StadiumDetail stadium,
      double deviceHeight, int stadiumIndex, StadiumLoaded state) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CarouselSlider(
              items: (stadium.images?.isNotEmpty ?? false)
                  ? stadium.images!.map((imageUrl) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            AppIcons.defaultStadium, // Default image
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList()
                  : [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          AppIcons.defaultStadium, // Default image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 7),
                enlargeCenterPage: true,
                onPageChanged: (index, reason) => context
                    .read<StadiumCubit>()
                    .updateCurrentIndex(index, stadiumIndex),
              ),
              carouselController: context
                  .read<StadiumCubit>()
                  .getCarouselController(stadiumIndex),
            ),
          ),
          _buildImageIndicator(stadium, deviceHeight, stadiumIndex, state),
        ],
      ),
    );
  }

  Widget _buildImageIndicator(StadiumDetail stadium, double deviceHeight,
      int stadiumIndex, StadiumLoaded state) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          stadium.images?.isNotEmpty ?? false
              ? stadium.images!.length
              : 1, // If no images, show indicator for the default one
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: state.currentIndexList[stadiumIndex] == index ? 12 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: state.currentIndexList[stadiumIndex] == index
                  ? AppColors.green2
                  : AppColors.grey4,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStadiumPriceAndSave(
      BuildContext context, StadiumDetail stadium, double deviceHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${stadium.price?.formatWithSpace()} so'm",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: deviceHeight * 0.025,
          ),
        ),
        SizedBox.square(
            dimension: 50,
            child: _buildSaveButton(
                context, stadium, context.read<SavedStadiumsCubit>())),
      ],
    );
  }

  Widget _buildSaveButton(
      BuildContext context, StadiumDetail stadium, SavedStadiumsCubit cubit) {
    return BlocBuilder<SavedStadiumsCubit, SavedStadiumsState>(
      bloc: cubit,
      buildWhen: (previous, current) {
        final id = stadium.id;
        return cubit.isStadiumSaved(id!) !=
            (previous is SavedStadiumsLoaded &&
                previous.savedStadiums.contains(stadium));
      },
      builder: (context, savedState) {
        final id = stadium.id;
        bool isSaved = cubit.isStadiumSaved(id!);
        bool isLoading = cubit.isLoading(id);

        return IconButton(
          icon: isLoading
              ? SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: AppColors.green,
                  ),
                )
              : Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: AppColors.green,
                ),
          onPressed: isLoading
              ? null
              : () {
                  if (isSaved) {
                    cubit.removeStadiumFromSaved(stadium);
                  } else {
                    cubit.addStadiumToSaved(stadium);
                  }
                },
        );
      },
    );
  }

  Widget _buildAvailableSlots(BuildContext context, List<TimeSlot> todaySlots,
      double deviceWidth, double deviceHeight, lan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: deviceWidth,
          child: Text(
            lan.empty_slots,
            style: TextStyle(
              fontSize: deviceHeight * 0.017,
              color: AppColors.grey4,
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: deviceHeight * 0.04,
          child: todaySlots.isNotEmpty
              ? _buildSlotListView(todaySlots, deviceHeight)
              : _buildNoSlotsMessage(deviceWidth, lan),
        ),
      ],
    );
  }

  Widget _buildSlotListView(List<TimeSlot> todaySlots, double deviceHeight) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: todaySlots.length,
      reverse: false,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        final slot = todaySlots[index];
        final timeFormat = DateFormat('HH:mm');
        final startTimeString = timeFormat.format(slot.startTime!);
        final endTimeString = timeFormat.format(slot.endTime!);

        return Container(
          width: 120,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: AppColors.green40,
          ),
          child: Center(
            child: Text(
              "$startTimeString - $endTimeString",
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.w700,
                fontSize: deviceHeight * 0.015,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoSlotsMessage(double deviceWidth, lan) {
    return Container(
      width: deviceWidth * 0.9,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppColors.red,
      ),
      child: Center(
        child: Text(
          lan.all_slots_booked,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildStadiumLocation(BuildContext context, StadiumDetail stadium,
      double deviceWidth, double deviceHeight) {
    return GestureDetector(
      onTap: () =>
          context.pushNamed(AppRoutes.detailStadium, extra: stadium.id),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on),
              SizedBox(width: deviceWidth * 0.02),
              SizedBox(
                width: deviceWidth - 150,
                child: Text(
                  "${stadium.location?.address}",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: deviceHeight * 0.015,
                    color: AppColors.main,
                    overflow: TextOverflow.visible,
                  ),
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
    );
  }

  List<TimeSlot> _getAvailableTodaySlots(
      List<Substadiums> fields, DateTime today) {
    final now = DateTime.now();
    final availableSlots = <TimeSlot>[];

    for (final field in fields) {
      // Generate all possible time slots for today (00:00-23:00)
      final allSlotsToday = List.generate(24, (hour) {
        final startTime = DateTime(today.year, today.month, today.day, hour);
        return TimeSlot(
          startTime: startTime,
          endTime: startTime.add(const Duration(hours: 1)),
        );
      });

      // Get booked slots from BronModel objects
      final bookedSlots = field.bookings
              ?.where((booking) =>
                  booking.timeSlot.startTime?.year == today.year &&
                  booking.timeSlot.startTime?.month == today.month &&
                  booking.timeSlot.startTime?.day == today.day)
              .map((booking) => booking.timeSlot)
              .toList() ??
          [];

      // Filter available slots
      final availableFieldSlots = allSlotsToday.where((slot) {
        final isBooked = bookedSlots.any((bookedSlot) =>
            slot.startTime!.isBefore(bookedSlot.endTime!) &&
            slot.endTime!.isAfter(bookedSlot.startTime!));

        final isPastSlot = slot.endTime!.isBefore(now);
        final isCurrentHour = slot.startTime!.hour == now.hour &&
            slot.startTime!.minute <= now.minute;

        return !isBooked && !isPastSlot && !isCurrentHour;
      });

      availableSlots.addAll(availableFieldSlots);
    }

    // Remove duplicates and sort
    final uniqueSlots = availableSlots.toSet().toList();
    uniqueSlots.sort((a, b) => a.startTime!.compareTo(b.startTime!));

    return uniqueSlots;
  }
}
