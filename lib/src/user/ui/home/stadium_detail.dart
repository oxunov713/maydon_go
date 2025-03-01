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
  final int stadiumId;

  const StadiumDetailScreen({super.key, required this.stadiumId});

  @override
  State<StadiumDetailScreen> createState() => _StadiumDetailScreenState();
}

class _StadiumDetailScreenState extends State<StadiumDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().fetchStadiumById(widget.stadiumId);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
  }

  String _getTodayDate() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  void _scrollToToday() {
    final bookingCubit = context.read<BookingCubit>();
    final state = bookingCubit.state;

    // 📌 State tekshirish
    if (state is! BookingLoaded) return;

    // 📌 Tanlangan stadionni olish
    final stadiumSlots = state.stadium.fields?.firstWhere(
      (field) => field.name == bookingCubit.selectedStadiumName,
      orElse: () => Substadiums(id: 0, name: 'Nomaʼlum stadion', bookings: []),
    );

    // 📌 Agar stadion yoki band qilingan vaqt bo‘sh bo‘lsa, qaytish
    if (stadiumSlots == null ||
        stadiumSlots.bookings == null ||
        stadiumSlots.bookings!.isEmpty) {
      return;
    }

    // 📅 Bugungi sana
    final today = _getTodayDate();

    // 🔑 Har bir band qilingan sana kalitlari
    final keys = stadiumSlots.bookings!
        .map((booking) => DateFormat("yyyy-MM-dd")
            .format(booking.startTime ?? DateTime.now()))
        .toList();

    // 📌 Bugungi sana mavjudligini tekshirish
    final todayIndex = keys.indexOf(today);
    if (todayIndex != -1) {
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
        child:
            BlocBuilder<BookingCubit, BookingState>(builder: (context, state) {
          if (state is BookingLoaded) {
            final stadium = state.stadium;
            final images = stadium.images ?? [];
            return RefreshIndicator(
              edgeOffset: deviceHeight * 0.5,
              onRefresh: () =>
                  context.read<BookingCubit>().refreshStadium(stadium.id!),
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                        floating: false,
                        pinned: true,
                        expandedHeight: deviceHeight * 0.25,
                        actions: [
                          // BlocBuilder<SavedStadiumsCubit, SavedStadiumsState>(
                          //   builder: (context, savedState) {
                          //     bool isSaved = false;
                          //
                          //     if (savedState is SavedStadiumsLoaded) {
                          //       isSaved = savedState.savedStadiums
                          //           .any((stadium) => stadium.id == widget.stadiumId);
                          //     }
                          //
                          //     return IconButton(
                          //       icon: Icon(
                          //         isSaved ? Icons.bookmark : Icons.bookmark_border,
                          //         color: AppColors.white,
                          //       ),
                          //       onPressed: () {
                          //         final cubit = context.read<SavedStadiumsCubit>();
                          //         if (isSaved) {
                          //           cubit.removeStadiumFromSaved(widget.stadiumId);
                          //         } else {
                          //           cubit.addStadiumToSaved(widget.stadiumId);
                          //         }
                          //       },
                          //     );
                          //   },
                          // ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          title: Padding(
                            padding: EdgeInsets.only(right: deviceWidth * 0.1),
                            child: Text(
                              stadium.name ?? 'Nomaʼlum stadion',
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
                            itemCount: images.isNotEmpty ? images.length : 1,
                            itemBuilder: (context, index, realIndex) {
                              final imageUrl = images.isNotEmpty
                                  ? images[index]
                                  : 'https://via.placeholder.com/150';

                              return SizedBox(
                                width: deviceWidth,
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
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
                        )),
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
                                              "${stadium.location?.city ?? 'Nomaʼlum shahar'}, ${stadium.location?.street ?? 'Nomaʼlum koʻcha'}, ${stadium.location?.country}",
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right:
                                                            deviceWidth * 0.01),
                                                    child: Text(
                                                      stadium.averageRating
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors.white,
                                                        fontSize:
                                                            ratingFontSize,
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
                                          BlocBuilder<BookingCubit,
                                              BookingState>(
                                            builder: (context, state) {
                                              final bookingCubit =
                                                  context.read<BookingCubit>();

                                              return DropdownMenu<String>(
                                                initialSelection: bookingCubit
                                                    .selectedStadiumName,
                                                onSelected: (String? value) {
                                                  if (value != null) {
                                                    bookingCubit.setSelectedField(
                                                        value); // ✅ Tanlangan stadionni saqlash
                                                    bookingCubit.setSelectedDate(
                                                        _getTodayDate()); // ✅ Sanani yangilash
                                                    _scrollToToday(); // ✅ Bugungi sanaga scroll qilish
                                                  }
                                                },
                                                dropdownMenuEntries: stadium
                                                    .fields!
                                                    .map((field) {
                                                  return DropdownMenuEntry<
                                                      String>(
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
                                                          BorderRadius.circular(
                                                              10),
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
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: AppColors.green,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: AppColors.green,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        const BorderSide(
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
                                                  "${stadium.price?.formatWithSpace()} so'm",
                                                  style: TextStyle(
                                                      fontSize: priceFontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.green,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),

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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      CustomCalendar(
                                        scrollController: _scrollController,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          spacing: 10,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      height:
                                                          deviceHeight * 0.04,
                                                      AppIcons.ballIcon,
                                                      color: AppColors.green,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            deviceWidth * 0.02),
                                                    Text(
                                                      "Stadionlar soni",
                                                      style: TextStyle(
                                                          fontSize:
                                                              addressFontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "${stadium.fields?.length} ta",
                                                  style: TextStyle(
                                                      fontSize: addressFontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.grey4),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      height:
                                                          deviceHeight * 0.04,
                                                      AppIcons.shirtsIcon,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            deviceWidth * 0.02),
                                                    Text(
                                                      "Forma",
                                                      style: TextStyle(
                                                          fontSize:
                                                              addressFontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  stadium.facilities!
                                                              .hasUniforms ??
                                                          true
                                                      ? "Bor"
                                                      : "Yo'q",
                                                  style: TextStyle(
                                                      fontSize: addressFontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.grey4),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      height:
                                                          deviceHeight * 0.04,
                                                      AppIcons.roofIcon,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            deviceWidth * 0.02),
                                                    Text(
                                                      "Usti yopiq stadion",
                                                      style: TextStyle(
                                                          fontSize:
                                                              addressFontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  stadium.facilities
                                                              ?.isIndoor ??
                                                          false
                                                      ? "Ha"
                                                      : "Yo'q",
                                                  style: TextStyle(
                                                      fontSize: addressFontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.grey4),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      height:
                                                          deviceHeight * 0.04,
                                                      AppIcons.showerIcon,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            deviceWidth * 0.02),
                                                    Text(
                                                      "Yuvinish xonasi",
                                                      style: TextStyle(
                                                          fontSize:
                                                              addressFontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  stadium.facilities!
                                                              .hasBathroom ??
                                                          false
                                                      ? "Bor"
                                                      : "Yo'q",
                                                  style: TextStyle(
                                                      fontSize: addressFontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.grey4),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Column(
                                                    spacing: 5,
                                                    children: [
                                                      Icon(
                                                        Icons.location_pin,
                                                        color: AppColors.green,
                                                      ),
                                                      Text("Location"),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Column(
                                                    spacing: 5,
                                                    children: [
                                                      Icon(
                                                        Icons.share,
                                                        color: AppColors.green,
                                                      ),
                                                      Text("Share"),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Column(
                                                    spacing: 5,
                                                    children: [
                                                      Icon(
                                                        Icons.open_in_new,
                                                        color: AppColors.green,
                                                      ),
                                                      Text("Open with..."),
                                                    ],
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
                                    bookingCubit.updatePosition(
                                        details.primaryDelta!,
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
                        text: "Choose a slot...",
                        isdisabledBT: false,
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(" uchun bron qilingan vaqtlar"),
        content: SingleChildScrollView(child: Center()),
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
