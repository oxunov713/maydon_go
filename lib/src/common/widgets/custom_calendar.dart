import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../user/bloc/booking_cubit/booking_cubit.dart';
import '../model/stadium_model.dart';
import '../style/app_colors.dart';

class CustomCalendar extends StatefulWidget {
  final Map<String, List<TimeSlot>> groupedSlots;

  const CustomCalendar({super.key, required this.groupedSlots});

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100, // Scroll miqdori
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100, // Scroll miqdori
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final bookingCubit = context.watch<BookingCubit>();
    final selectedDate = bookingCubit.selectedDate;

    final formattedDate =
        DateFormat("dd MMMM, yyyy", 'uz').format(DateTime.parse(selectedDate));

    return (widget.groupedSlots.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),
              Text(
                formattedDate,
                style: TextStyle(fontSize: height * 0.02),
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _scrollLeft,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: height * 0.1,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.groupedSlots.keys.length,
                        itemBuilder: (context, index) {
                          final date = widget.groupedSlots.keys.toList()[index];
                          final parsedDate = DateTime.parse(date);

                          return GestureDetector(
                            onTap: () {
                              bookingCubit.setSelectedDate(date);
                            },
                            child: Container(
                              width: height * 0.05,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 10),
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
                                      fontSize: height * 0.018,
                                      fontWeight: FontWeight.w600,
                                      color: selectedDate == date
                                          ? AppColors.white
                                          : AppColors.main,
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: AppColors.white,
                                    radius: height * 0.018,
                                    child: Text(
                                      DateFormat("dd").format(parsedDate),
                                      style: TextStyle(
                                          fontSize: height * 0.02,
                                          color: AppColors.main),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _scrollRight,
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: widget.groupedSlots[selectedDate]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final slot = widget.groupedSlots[selectedDate]![index];
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: bookingCubit.isSlotBooked(slot)
                            ? AppColors.green40
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: bookingCubit.isSlotBooked(slot)
                              ? AppColors.transparent
                              : AppColors.green2,
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        customBorder: const StadiumBorder(),
                        onTap: () {
                          if (bookingCubit.isSlotBooked(slot)) {
                            bookingCubit.removeBookingSlot(slot);
                          } else {
                            bookingCubit.addBookingSlot(slot);
                          }
                        },
                        child: Center(
                          child: Text(
                            "${DateFormat('HH:mm').format(slot.startTime)} - ${DateFormat('HH:mm').format(slot.endTime)}",
                            style: TextStyle(
                              fontSize: 14,
                              color: bookingCubit.isSlotBooked(slot)
                                  ? AppColors.green
                                  : AppColors.main,
                              fontWeight: bookingCubit.isSlotBooked(slot)
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                width: double.infinity,
                height: height * 0.05,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: AppColors.red,
                ),
                child: Center(
                  child: Text(
                    "Barcha soatlar band",
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: height * 0.018,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
