import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/common/model/substadium_model.dart';
import '../../../common/tools/average_rating_extension.dart';
import '../../../common/tools/price_formatter_extension.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/sign_button.dart';
import '../../../owner/screens/home/owner_stadium_detail.dart';
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
    final bookingCubit = context.read<BookingCubit>();
    if (widget.stadium.fields!.isNotEmpty) {
      final initialStadium =
          widget.stadium.fields?.first.name ?? 'Nomaʼlum stadion';
      bookingCubit.setSelectedStadium(initialStadium);
      bookingCubit.setSelectedDate(_getTodayDate());
      bookingCubit.getGroupedSlots(widget.stadium);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
  }

  String _getTodayDate() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  void _scrollToToday() {
    final bookingCubit = context.read<BookingCubit>();
    final stadiumSlots = widget.stadium.fields?.firstWhere(
      (field) => field.name == bookingCubit.selectedStadium,
      orElse: () => Substadiums(id: 0, name: 'Nomaʼlum stadion', bookings: []),
    );

    final keys = stadiumSlots?.bookings!
        .map((booking) => DateFormat("yyyy-MM-dd")
            .format(booking.startTime ?? DateTime.now()))
        .toList();

    final today = _getTodayDate();

    if (keys!.contains(today)) {
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
    final double tabBarHeight = deviceHeight * 0.7;
    final double paddingHorizontal = deviceWidth * 0.03;
    final double paddingVertical = deviceHeight * 0.02;

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

                      bool isSaved = false;
                      if (savedState is SavedStadiumsLoaded) {
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
                      widget.stadium.name ?? 'Nomaʼlum stadion',
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
                    itemCount: widget.stadium.images!.length,
                    itemBuilder: (context, index, realIndex) {
                      final imageUrl = widget.stadium.images?[index];
                      return SizedBox(
                        width: deviceWidth,
                        child: CachedNetworkImage(
                          imageUrl:
                              imageUrl ?? 'https://via.placeholder.com/150',
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
                                        "${widget.stadium.location?.city ?? 'Nomaʼlum shahar'}, ${widget.stadium.location?.street ?? 'Nomaʼlum koʻcha'}",
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
                                                widget.stadium.averageRating
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
                                        final bookingCubit =
                                            context.read<BookingCubit>();
                                        return DropdownMenu<String>(
                                          initialSelection:
                                              bookingCubit.selectedStadium,
                                          onSelected: (String? value) {
                                            if (value != null) {
                                              bookingCubit
                                                  .setSelectedStadium(value);
                                              bookingCubit.setSelectedDate(
                                                  _getTodayDate());
                                              _scrollToToday();
                                            }
                                          },
                                          dropdownMenuEntries: widget
                                              .stadium.fields!
                                              .map((field) {
                                            return DropdownMenuEntry<String>(
                                              value: field.name ??
                                                  'Nomaʼlum stadion',
                                              label: field.name ??
                                                  'Nomaʼlum stadion',
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
                                            "${widget.stadium.price?.formatWithSpace()} so'm",
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
                                    return CustomCalendar(
                                      scrollController: _scrollController,
                                    );
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                height: deviceHeight * 0.04,
                                                AppIcons.ballIcon,
                                                color: AppColors.green,
                                              ),
                                              SizedBox(
                                                  width: deviceWidth * 0.02),
                                              Text(
                                                "Stadionlar soni",
                                                style: TextStyle(
                                                    fontSize: addressFontSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${widget.stadium.fields?.length} ta",
                                            style: TextStyle(
                                                fontSize: addressFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.grey4),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                height: deviceHeight * 0.04,
                                                AppIcons.shirtsIcon,
                                              ),
                                              SizedBox(
                                                  width: deviceWidth * 0.02),
                                              Text(
                                                "Forma",
                                                style: TextStyle(
                                                    fontSize: addressFontSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            widget.stadium.facilities!
                                                        .hasUniforms ??
                                                    true
                                                ? "Bor"
                                                : "Yo'q",
                                            style: TextStyle(
                                                fontSize: addressFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.grey4),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                height: deviceHeight * 0.04,
                                                AppIcons.roofIcon,
                                              ),
                                              SizedBox(
                                                  width: deviceWidth * 0.02),
                                              Text(
                                                "Usti yopiq stadion",
                                                style: TextStyle(
                                                    fontSize: addressFontSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            widget.stadium.facilities
                                                        ?.isIndoor ??
                                                    false
                                                ? "Ha"
                                                : "Yo'q",
                                            style: TextStyle(
                                                fontSize: addressFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.grey4),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                height: deviceHeight * 0.04,
                                                AppIcons.showerIcon,
                                              ),
                                              SizedBox(
                                                  width: deviceWidth * 0.02),
                                              Text(
                                                "Yuvinish xonasi",
                                                style: TextStyle(
                                                    fontSize: addressFontSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            widget.stadium.facilities!
                                                        .hasBathroom ??
                                                    false
                                                ? "Bor"
                                                : "Yo'q",
                                            style: TextStyle(
                                                fontSize: addressFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.grey4),
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
              ),
            ],
          ),
          bottomNavigationBar: BlocListener<BookingCubit, BookingState>(
            listener: (context, state) {
              if (state is BookingUpdated && state.confirmed) {
                _showConfirmationDialog(context);
              }
            },
            child: BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                final bookingCubit = context.read<BookingCubit>();
                if (state is BookingUpdated) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          width: deviceWidth,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xff148A03),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            state.confirmed
                                ? "Tasdiqlandi!"
                                : "Surib tasdiqlang",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Positioned(
                          left: state.position,
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              bookingCubit.updatePosition(details.primaryDelta!,
                                  deviceWidth - deviceWidth * 0.2);
                            },
                            onHorizontalDragEnd: (details) {
                              bookingCubit.confirmPosition(
                                  deviceWidth - deviceWidth * 0.25);
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.arrow_forward,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return BottomSignButton(
                  function: () {},
                  text: "Waiting",
                  isdisabledBT: false,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void _showConfirmationDialog(BuildContext context) {
  final bookingCubit = context.read<BookingCubit>();
  final state = bookingCubit.state;

  if (state is! BookingUpdated)
    return; // Agar ma'lumot yo'q bo'lsa, hech narsa qilmaydi

  final groupedSlots = state.groupedSlots;
  final stadiumName = state.selectedStadium;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("$stadiumName uchun bron qilingan vaqtlar"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupedSlots.entries.map((entry) {
              final date = entry.key;
              final slots = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "📅 Sana: $date",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...slots.map((slot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        "🕒 ${DateFormat('HH:mm').format(slot.startTime!)} - ${DateFormat('HH:mm').format(slot.endTime!)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  const Divider(),
                ],
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yopish"),
          ),
        ],
      );
    },
  );
}
