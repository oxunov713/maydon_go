import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/stadium_model.dart';

import '../../../common/router/app_routes.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../../common/widgets/sign_button.dart';
import '../../bloc/booking_cubit/booking_cubit.dart';
import '../../bloc/booking_cubit/booking_state.dart';

class StadiumDetailScreen extends StatelessWidget {
  final Stadium stadium;

  StadiumDetailScreen({required this.stadium});

  @override
  Widget build(BuildContext context) {
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
                icon: Icon(Icons.bookmark_border),
                onPressed: () {
                  // Bookmark logic goes here
                },
              ),
              SizedBox(width: 10),
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
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
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
        floatingActionButton: SizedBox.square(
          dimension: 50,
          child: FloatingActionButton(
            shape: CircleBorder(),
            onPressed: () {},
            child: Icon(
              Icons.delete,
              color: AppColors.red,
            ),
            backgroundColor: AppColors.white,
          ),
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
              isdisabledBT: bookingCount > 0,
            );
          },
        ),
      ),
    );
  }
}
