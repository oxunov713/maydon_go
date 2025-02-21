import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../common/tools/average_rating_extension.dart';
import '../../..//common/tools/price_formatter_extension.dart';
import '../../../common/model/stadium_model.dart';
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
    final bookingCubit = context.read<BookingCubit>();
    if (widget.stadium.stadiumsSlots.isNotEmpty) {
      final initialStadium = widget.stadium.stadiumsSlots.first.keys.first;
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
    final stadiumSlots = widget.stadium.stadiumsSlots.firstWhere(
      (stadium) => stadium.containsKey(bookingCubit.selectedStadium),
      orElse: () => {},
    );

    final keys = stadiumSlots[bookingCubit.selectedStadium]
        ?.keys
        .map((date) => DateFormat("yyyy-MM-dd").format(date))
        .toList();

    final today = _getTodayDate();

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
      length: 2,
      // Ikkita tab
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
                                        final bookingCubit =
                                            context.read<BookingCubit>();
                                        return DropdownMenu<String>(
                                          initialSelection:
                                              bookingCubit.selectedStadium,
                                          onSelected: (String? value) {
                                            if (value != null) {
                                              bookingCubit
                                                  .setSelectedStadium(value);
                                              bookingCubit.getGroupedSlots(
                                                  widget.stadium);
                                              _scrollToToday();
                                              bookingCubit.setSelectedDate(
                                                  _getTodayDate());
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
                                    return CustomCalendar(
                                        scrollController: _scrollController,
                                        groupedSlots: (state is BookingLoaded)
                                            ? state.groupedSlots
                                            : {});
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
                                            "3 ta",
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
                                            "Bor",
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
                                            "Yo'q",
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
                                            "Bor",
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
              if (state is BookingLoaded && state.confirmed) {
                _showConfirmationDialog(context);
              }
            },
            child: BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                final bookingCubit = context.read<BookingCubit>();
                if (state is BookingLoaded) {
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
  final bookedSlots = bookingCubit.bookedSlots;
  final groupedSlots = groupSlotsByDate(bookedSlots);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            "Buyurtma",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (groupedSlots.isNotEmpty)
                ? groupedSlots.entries.map((entry) {
                    final date = entry.key;
                    final slots = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tanlangan sana:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " ${DateFormat('dd.MM.yyyy').format(DateTime.parse(date))}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: slots.map((slot) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Center(
                                child: Text(
                                  "${DateFormat('HH:mm').format(slot.startTime)} - ${DateFormat('HH:mm').format(slot.endTime)}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                            height: 20), // Har bir sana orasida bo'sh joy
                      ],
                    );
                  }).toList()
                : [const Center(child: Text("Siz hali vaqt tanlamadingiz"))],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          groupedSlots.isNotEmpty
              ? TextButton(
                  onPressed: () {
                    context.pop();
                    List<String> friendsAvatars = [
                      "https://randomuser.me/api/portraits/men/1.jpg",
                      "https://randomuser.me/api/portraits/women/2.jpg",
                      "https://randomuser.me/api/portraits/men/3.jpg",
                      "https://randomuser.me/api/portraits/women/4.jpg",
                      "https://randomuser.me/api/portraits/men/1.jpg",
                      "https://randomuser.me/api/portraits/women/2.jpg",
                      "https://randomuser.me/api/portraits/men/3.jpg",
                      "https://randomuser.me/api/portraits/women/4.jpg",
                      "https://randomuser.me/api/portraits/men/1.jpg",
                      "https://randomuser.me/api/portraits/women/2.jpg",
                      "https://randomuser.me/api/portraits/men/3.jpg",
                      "https://randomuser.me/api/portraits/women/4.jpg",
                    ]; // Do‘stlarning rasm URL'lari

                    _showBookingConfirmationSheet(context, friendsAvatars);
                  },
                  child: const Text(
                    "Bron qilish",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.green,
                        fontSize: 18),
                  ),
                )
              : const SizedBox(),
          TextButton(
            onPressed: () {
              context.pop();
              context.read<BookingCubit>().clearBookingSlots();
            },
            child: const Text(
              "Bekor qilish",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.red,
                  fontSize: 18),
            ),
          ),
        ],
      );
    },
  );
}

Map<String, List<TimeSlot>> groupSlotsByDate(List<TimeSlot> slots) {
  final Map<String, List<TimeSlot>> groupedSlots = {};

  for (var slot in slots) {
    // Sana faqat yyy-MM-dd formatida olinadi
    final String dateKey = DateFormat('yyyy-MM-dd').format(slot.startTime);

    // Agar bu sana mavjud bo'lmasa, yangi bo'sh list yaratamiz
    groupedSlots.putIfAbsent(dateKey, () => []);

    // O'sha sanaga tegishli slotlarni qo'shamiz
    groupedSlots[dateKey]!.add(slot);
  }

  return groupedSlots;
}

void _showBookingConfirmationSheet(
    BuildContext context, List<String> friendsAvatars) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // To'liq ekranga yaqin ochilishi uchun
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Scroll uchun min ishlatamiz
            children: [
              Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(height: 20),
              const Icon(Icons.check_circle, color: Colors.green, size: 50),
              const SizedBox(height: 10),
              const Text(
                "Bron qilindi!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "+10 coins",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent),
              ),
              const SizedBox(height: 20),
              Text(
                "Do‘stlaringiz bilan baham ko‘ring:",
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildFriendsAvatars(friendsAvatars),
              const SizedBox(height: 20),
              Text(
                "Jamoadoshlaringiz bilan baham ko‘ring:",
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildTeamsAvatars(friendsAvatars),

              const SizedBox(height: 10),

              // **Share va Location Iconlari**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      // Location funksiyasi
                    },
                    icon: Icon(
                      Icons.location_on,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      //todo share service yozish tashqi appga silka berib otadi
                    },
                    icon: Icon(
                      Icons.share,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // OK tugmasi
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  context.read<BookingCubit>().clearBookingSlots();
                  context.pop();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text("OK",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildFriendsAvatars(List<String> avatars) {
  return SizedBox(
    height: 80,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(avatars[index]),
              ),
              Text("Alisher"),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildTeamsAvatars(List<String> avatars) {
  return SizedBox(
    height: 80,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(avatars[index]),
              ),
              Text("Tashkent Bulls"),
            ],
          ),
        );
      },
    ),
  );
}
