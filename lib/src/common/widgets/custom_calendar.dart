import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../user/bloc/booking_cubit/booking_cubit.dart';
import '../../user/bloc/booking_cubit/booking_state.dart';
import '../model/stadium_model.dart';
import '../style/app_colors.dart';

class CustomCalendar extends StatefulWidget {
  final Map<String, List<TimeSlot>> groupedSlots;
  final ScrollController scrollController;

  const CustomCalendar({
    super.key,
    required this.groupedSlots,
    required this.scrollController,
  });

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bookingCubit = context.read<BookingCubit>();
    if (bookingCubit.state is BookingLoaded &&
        (bookingCubit.state as BookingLoaded).selectedDate.isEmpty) {
      bookingCubit.setSelectedDate(_getTodayDate());
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
    final bookingCubit = context.read<BookingCubit>();
    final bookingState = context.watch<BookingCubit>().state;

    if ((bookingState is! BookingLoaded)) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedDate = bookingState.selectedDate;
    final formattedDate = _formatDate(selectedDate);

    return BlocListener<BookingCubit, BookingState>(
      listenWhen: (previous, current) => current is BookingLoaded,
      listener: (context, state) {
        // Handle state changes if needed
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.02),
          Text(
            formattedDate,
            style: TextStyle(fontSize: height * 0.02),
          ),
          SizedBox(height: height * 0.02),
          _buildDatePicker(height, bookingCubit, selectedDate),
          const Divider(),
          _buildTimeSlots(height, bookingCubit, selectedDate),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    // Ensure the date is in the correct format
    final dateOnly = date.split('T')[0];
    return DateFormat("dd MMMM, yyyy", 'uz').format(DateTime.parse(dateOnly));
  }

  Widget _buildDatePicker(
      double height, BookingCubit bookingCubit, String selectedDate) {
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
              itemCount: widget.groupedSlots.keys.length,
              itemBuilder: (context, index) {
                final date = widget.groupedSlots.keys.toList()[index];
                return _buildDateItem(height, bookingCubit, selectedDate, date);
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

  Widget _buildDateItem(double height, BookingCubit bookingCubit,
      String selectedDate, String date) {
    final parsedDate = DateTime.parse(date.split('T')[0]);
    final today = _getTodayDate();
    final isSelected =
        selectedDate == date || (selectedDate.isEmpty && date == today);

    return GestureDetector(
      onTap: () => bookingCubit.setSelectedDate(date),
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

  Widget _buildTimeSlots(
      double height, BookingCubit bookingCubit, String selectedDate) {
    final slots = widget.groupedSlots[selectedDate] ?? [];

    if (slots.isEmpty) {
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
            "Barcha soatlar band",
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
          return _buildTimeSlotItem(bookingCubit, slot);
        },
      ),
    );
  }

  Widget _buildTimeSlotItem(BookingCubit bookingCubit, TimeSlot slot) {
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
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => isBooked
            ? bookingCubit.removeBookingSlot(slot)
            : bookingCubit.addBookingSlot(slot),
        child: Center(
          child: Text(
            "${DateFormat('HH:mm').format(slot.startTime)} - ${DateFormat('HH:mm').format(slot.endTime)}",
            style: TextStyle(
              fontSize: 14,
              color: isBooked ? AppColors.green : AppColors.main,
              fontWeight: isBooked ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}