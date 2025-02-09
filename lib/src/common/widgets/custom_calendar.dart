import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../user/bloc/booking_cubit/booking_cubit.dart';
import '../model/available_slots_model.dart';
import '../model/stadium_model.dart';
import '../style/app_colors.dart';

class CustomCalendar extends StatelessWidget {
  final Map<String, List<AvailableSlot>> groupedSlots;

  const CustomCalendar({Key? key, required this.groupedSlots})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the selected date and the cubit instance
    final bookingCubit = context.watch<BookingCubit>();
    String selectedDate = bookingCubit.selectedDate;

    DateTime date = DateTime.parse(selectedDate);
    String formattedDate = DateFormat("dd MMMM, yyyy", 'uz').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedDate,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: groupedSlots.keys.length,
            itemBuilder: (context, index) {
              final date = groupedSlots.keys.toList()[index];
              final parsedDate = DateTime.parse(date);

              return GestureDetector(
                onTap: () {
                  // Update the selected date in the cubit
                  bookingCubit.setSelectedDate(date);
                },
                child: Container(
                  width: 50,
                  margin: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedDate == date
                        ? Colors.green
                        : AppColors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("E", 'uz')
                            .format(parsedDate)
                            .substring(0, 2),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selectedDate == date
                              ? AppColors.white
                              : AppColors.main,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        child: Text(
                          DateFormat("dd").format(parsedDate),
                          style: TextStyle(fontSize: 18, color: AppColors.main),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Divider(),
        // Available Slots for Selected Date
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: groupedSlots[selectedDate]?.length ?? 0,
            itemBuilder: (context, index) {
              final slot = groupedSlots[selectedDate]![index];
              // return DecoratedBox(
              //   decoration: BoxDecoration(
              //     color: bookingCubit.isSlotBooked(slot)
              //         ? AppColors.green40
              //         : AppColors.white,
              //     borderRadius: BorderRadius.circular(20),
              //     border: Border.all(
              //         color: bookingCubit.isSlotBooked(slot)
              //             ? AppColors.transparent
              //             : AppColors.green2,
              //         width: 2),
              //   ),
              //   child: InkWell(
              //     customBorder: StadiumBorder(),
              //     onTap: () {
              //       // if (bookingCubit.isSlotBooked(slot as String)) {
              //       //   bookingCubit.removeBookingSlot(slot);
              //       // } else {
              //       //   bookingCubit.addBookingSlot(slot);
              //       // }
              //     },
              //     // child: Center(
              //     //   child: Text(
              //     //     "${DateFormat('HH:mm').format(slot.startTime)} - ${DateFormat('HH:mm').format(slot.endTime)}",
              //     //     style: TextStyle(
              //     //       fontSize: 14,
              //     //       color: bookingCubit.isSlotBooked(slot)
              //     //           ? AppColors.green
              //     //           : AppColors.main,
              //     //       fontWeight: bookingCubit.isSlotBooked(slot)
              //     //           ? FontWeight.w700
              //     //           : FontWeight.w600,
              //     //     ),
              //     //   ),
              //     // ),
              //   ),
              // );
            },
          ),
        ),
      ],
    );
  }
}
