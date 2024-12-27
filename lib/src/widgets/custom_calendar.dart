import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/provider/booking_provider.dart';
import 'package:maydon_go/src/style/app_colors.dart';
import 'package:provider/provider.dart';

import '../model/stadium_model.dart';

class CustomCalendar extends StatelessWidget {
  final Map<String, List<AvailableSlot>> groupedSlots;

  const CustomCalendar({Key? key, required this.groupedSlots})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the selected date from the provider
    String selectedDate = context.watch<BookingDateProvider>().selectedDate;

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
                  // Update the selected date in the provider
                  context.read<BookingDateProvider>().setSelectedDate(date);
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
              return DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      context.watch<BookingDateProvider>().isSlotBooked(slot)
                          ? AppColors.green40
                          : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: context
                              .watch<BookingDateProvider>()
                              .isSlotBooked(slot)
                          ? AppColors.transparent
                          : AppColors.green2,
                      width: 2),
                ),
                child: InkWell(customBorder:StadiumBorder(),
                  onTap: () {
                    if (context.read<BookingDateProvider>().isSlotBooked(slot)) {
                      context.read<BookingDateProvider>().removeBookingSlot(slot);
                    } else {
                      context.read<BookingDateProvider>().addBookingSlot(slot);
                    }
                  },
                  child: Center(
                    child: Text(
                      "${DateFormat('HH:mm').format(slot.startTime)} - ${DateFormat('HH:mm').format(slot.endTime)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: context
                                .watch<BookingDateProvider>()
                                .isSlotBooked(slot)
                            ? AppColors.green
                            : AppColors.main,
                        fontWeight:context
                            .watch<BookingDateProvider>()
                            .isSlotBooked(slot)
                            ? FontWeight.w700:FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
