import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/substadium_model.dart';
import 'package:maydon_go/src/common/service/booking_service.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';

import '../../user/bloc/booking_cubit/booking_cubit.dart';
import '../../user/bloc/booking_cubit/booking_state.dart';
import '../model/time_slot_model.dart';
import '../style/app_colors.dart';

class CustomCalendar extends StatefulWidget {
  final ScrollController scrollController;

  const CustomCalendar({
    super.key,
    required this.scrollController,
  });

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final Logger log = Logger();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bookingState = context.read<BookingCubit>().state;

    if (bookingState is BookingLoaded &&
        bookingState.selectedStadiumName == null) {
      if (bookingState.stadium.fields?.isNotEmpty == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context
              .read<BookingCubit>()
              .setSelectedField(bookingState.stadium.fields!.first.name!);
        });
      }
    }
  }

  String _getTodayDate() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  void _scrollLeft() {
    widget.scrollController.animateTo(
      widget.scrollController.offset - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    widget.scrollController.animateTo(
      widget.scrollController.offset + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, bookingState) {
        if (bookingState is BookingError) {
          return Center(child: Text(bookingState.message));
        }

        if (bookingState is! BookingLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final stadium = bookingState.stadium;
        final selectedDate = bookingState.selectedDate ?? _getTodayDate();
        final formattedDate = _formatDate(selectedDate);

        // Find the selected stadium based on selectedStadiumName
        final selectedStadium = stadium.fields?.firstWhere(
          (field) => field.name == bookingState.selectedStadiumName,
          orElse: () => stadium.fields!.isNotEmpty
              ? stadium.fields!.first
              : Substadiums(id: 0, name: '', availableSlots: []),
        );

        final groupedSlots =
            selectedStadium?.availableSlots?.groupByDate() ?? {};

        // Debugging logs
        log.e("📅 Selected Stadium: ${selectedStadium?.name}");
        log.e("📅 Selected Date: $selectedDate");
        log.e("📅 Grouped Slots Keys: ${groupedSlots.keys}");
        log.e("📅 Available Slots: ${selectedStadium?.availableSlots}");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            Text(
              formattedDate,
              style: TextStyle(fontSize: height * 0.02),
            ),
            SizedBox(height: height * 0.02),
            _buildDatePicker(height, selectedDate, groupedSlots),
            const Divider(),
            _buildTimeSlots(height, selectedDate, groupedSlots),
          ],
        );
      },
    );
  }

  String _formatDate(String date) {
    final dateOnly = date.split('T')[0];
    return DateFormat("dd MMMM, yyyy", 'uz').format(DateTime.parse(dateOnly));
  }

  Widget _buildDatePicker(double height, String selectedDate,
      Map<String, List<TimeSlot>> groupedSlots) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _scrollLeft,
        ),
        Expanded(
          child: SizedBox(
            height: height * 0.1,
            child: ListView.builder(
              controller: widget.scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: groupedSlots.keys.length,
              itemBuilder: (context, index) {
                final date = groupedSlots.keys.toList()[index];
                return _buildDateItem(height, selectedDate, date);
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _scrollRight,
        ),
      ],
    );
  }

  Widget _buildDateItem(double height, String selectedDate, String date) {
    final parsedDate = DateTime.parse(date.split('T')[0]);
    final today = _getTodayDate();
    final isSelected =
        selectedDate == date || (selectedDate.isEmpty && date == today);

    return GestureDetector(
      onTap: () => context.read<BookingCubit>().setSelectedDate(date),
      child: Container(
        width: height * 0.05,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : AppColors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("E", 'uz').format(parsedDate).substring(0, 2),
              style: TextStyle(
                fontSize: height * 0.018,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.main,
              ),
            ),
            CircleAvatar(
              backgroundColor: AppColors.white,
              radius: height * 0.018,
              child: Text(
                DateFormat("dd").format(parsedDate),
                style:
                    TextStyle(fontSize: height * 0.02, color: AppColors.main),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlots(double height, String selectedDate,
      Map<String, List<TimeSlot>> groupedSlots) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final selectedStadium = state is BookingLoaded
            ? state.stadium.fields?.firstWhere(
                (field) => field.name == state.selectedStadiumName,
                orElse: () => Substadiums(id: 0, name: '', availableSlots: []),
              )
            : Substadiums(id: 0, name: '', availableSlots: []);

        final slots = groupedSlots[selectedDate] ?? [];
        final availableSlots = selectedStadium?.availableSlots?.where((slot) =>
            slots.any((availableSlot) =>
                availableSlot.startTime == slot.startTime &&
                availableSlot.endTime == slot.endTime));
        final filteredSlots = availableSlots?.toList() ?? [];

        if (filteredSlots.isEmpty) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.01),
            width: double.infinity,
            height: height * 0.05,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: AppColors.red,
            ),
            child: Center(
              child: Text(
                "Bugungi barcha soatlar band",
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: height * 0.018,
                ),
              ),
            ),
          );
        }

        return Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              return _buildTimeSlotItem(slot);
            },
          ),
        );
      },
    );
  }

  Widget _buildTimeSlotItem(TimeSlot slot) {
    final bookingCubit = context.read<BookingCubit>();
    final isBooked = bookingCubit.isSlotBooked(slot);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isBooked ? AppColors.green40 : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBooked ? AppColors.transparent : AppColors.green2,
          width: 2,
        ),
      ),
      child: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          return InkWell(
            customBorder: const StadiumBorder(),
            onTap: () {
              if (state is BookingLoaded) {
                final currentState = state;
                final subscription = currentState.user.subscriptionModel?.name;
                final currentBookings = currentState.bookings.length;
                String errorMessage = "";

                if (isBooked) {
                  bookingCubit.removeSlot(slot);
                  return;
                }

                if (subscription == null) {
                  errorMessage = "Sizning obunangiz mavjud emas!";
                } else if (subscription == "Go") {
                  if (currentBookings >= 2) {
                    errorMessage =
                        '"Go" obuna foydalanuvchilari kuniga faqat 2 ta slot band qila oladi!';
                  }
                } else if (subscription == "Go+") {
                  if (currentBookings >= 5) {
                    errorMessage =
                        '"Go+" obuna foydalanuvchilari kuniga faqat 5 ta slot band qila oladi!';
                  }
                }

                if (errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                      showCloseIcon: true,
                      duration: Duration(seconds: 5),
                    ),
                  );
                  return;
                }

                bookingCubit.addSlot(slot);
              }
            },
            child: Center(
              child: Text(
                "${DateFormat('HH:mm').format(slot.startTime!)} - ${DateFormat('HH:mm').format(slot.endTime!)}",
                style: TextStyle(
                  fontSize: 14,
                  color: isBooked ? AppColors.green : AppColors.main,
                  fontWeight: isBooked ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
