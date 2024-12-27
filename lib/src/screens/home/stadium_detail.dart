import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/data/fake_data.dart';
import 'package:maydon_go/src/model/stadium_model.dart';
import 'package:maydon_go/src/provider/all_stadium_provider.dart';
import 'package:maydon_go/src/provider/booking_provider.dart';
import 'package:maydon_go/src/style/app_icons.dart';
import 'package:maydon_go/src/tools/extension_custom.dart';
import 'package:maydon_go/src/widgets/sign_button.dart';
import 'package:provider/provider.dart';

import '../../provider/saved_stadium_provider.dart';
import '../../style/app_colors.dart';
import '../../widgets/custom_calendar.dart';

class StadiumDetailScreen extends StatelessWidget {
  final Stadium stadium;

  const StadiumDetailScreen({Key? key, required this.stadium})
      : super(key: key);

  StadiumOwner? findStadiumOwnerByStadium(
      Stadium stadium, List<StadiumOwner> stadiumOwners) {
    for (var owner in stadiumOwners) {
      if (owner.stadium.id == stadium.id) {
        return owner; // Stadion egasini qaytarish
      }
    }
    return null; // Agar topilmasa, null qaytaradi
  }

  @override
  Widget build(BuildContext context) {
    // Format the price for display
    final priceFormatted = NumberFormat.currency(symbol: '\$', decimalDigits: 2)
        .format(stadium.price);
    final number = findStadiumOwnerByStadium(stadium, FakeData.stadiumOwners);

    // Group available slots by date
    Map<String, List<AvailableSlot>> groupedSlots = {};
    for (var slot in stadium.availableSlots) {
      final dateFormatted = DateFormat("yyyy-MM-dd").format(slot.startTime);
      if (!groupedSlots.containsKey(dateFormatted)) {
        groupedSlots[dateFormatted] = [];
      }
      groupedSlots[dateFormatted]?.add(slot);
    }

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            expandedHeight: 215,
            backgroundColor: AppColors.green,
            actions: [
              IconButton(
                icon: Icon(
                  context.watch<SavedStadiumsProvider>().isStadiumSaved(stadium)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
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
              ),
              SizedBox(width: 10)
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                stadium.name,
                style: TextStyle(
                    fontSize: 20,
                    color: AppColors.white,
                    fontWeight: FontWeight.w800),
              ),
              background: CarouselSlider.builder(
                itemCount: stadium.images.length,
                itemBuilder: (context, index, realIndex) {
                  return Image.asset(
                    stadium.images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  initialPage: 0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  stadium.description,
                                  style: TextStyle(
                                      fontSize: 16, color: AppColors.main),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            "Phone: ",
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.main,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            " ${number?.phoneNumber}",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.main,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Location: ",
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.main,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            " ${stadium.location.address}",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.main,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Yuvinish xonasi: ",
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.main,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            " ${stadium.facilities.hasBathroom ? 'Bor' : "Yo'q"}",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.main,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Usti yopiq stadion ",
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.main,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            " ${stadium.facilities.hasRestroom ? 'Bor' : "Yo'q"}",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.main,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Forma & koptok ",
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.main,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            " ${stadium.facilities.hasUniforms ? 'Bor' : "Yo'q"}",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.main,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Soati: ",
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.main,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            stadium.price.formatWithSpace() + " so'm",
                            style: TextStyle(
                                fontSize: 22,
                                color: AppColors.green,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Mavjud vaqtlar",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: CustomCalendar(groupedSlots: groupedSlots),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
        bottomNavigationBar: BottomSignButton(
            function: () {},
            text: "Booking ${Provider.of<BookingDateProvider>(context,listen: true)
                .bookingList.length} hours",
            isdisabledBT: Provider.of<BookingDateProvider>(context,listen: true)
                .bookingList
                .isNotEmpty,),
      ),
    );
  }
}
