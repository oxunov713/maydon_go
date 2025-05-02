import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/common/l10n/app_localizations.dart';
import 'package:maydon_go/src/common/model/substadium_model.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/model/time_slot_model.dart';
import 'package:maydon_go/src/owner/bloc/calendar_cubit/calendar_cubit.dart';
import 'package:maydon_go/src/owner/bloc/calendar_cubit/calendar_state.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../common/service/url_launcher_service.dart';

class SubstadiumScreen extends StatefulWidget {
  final Substadiums substadium;

  const SubstadiumScreen({super.key, required this.substadium});

  @override
  State<SubstadiumScreen> createState() => _SubstadiumBookingsScreenState();
}

class _SubstadiumBookingsScreenState extends State<SubstadiumScreen> {
  @override
  Widget build(BuildContext context) {
    final substadium = widget.substadium;
    final bookings = substadium.bookings ?? [];
    final lan = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => CalendarCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(substadium.name ?? lan.bookingListTitle),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: BlocBuilder<CalendarCubit, CalendarState>(
                builder: (context, state) {
                  return TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: state.focusedDay,
                    calendarFormat: state.calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(state.selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      context
                          .read<CalendarCubit>()
                          .selectDay(selectedDay, focusedDay);
                    },
                    onFormatChanged: (format) {
                      context.read<CalendarCubit>().changeFormat(format);
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        final hasBooking = substadium.bookings?.any((bron) {
                              return bron.timeSlot.startTime!.year ==
                                      day.year &&
                                  bron.timeSlot.startTime!.month == day.month &&
                                  bron.timeSlot.startTime!.day == day.day;
                            }) ??
                            false;

                        if (hasBooking) {
                          return Positioned(
                            bottom: 1,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.green,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<CalendarCubit, CalendarState>(
                builder: (context, state) {
                  return _buildBookingsList(bookings, state.selectedDay);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<BronModel> allBookings, DateTime selectedDay) {
    final filteredBookings = allBookings.where((bron) {
      final bookingDate = bron.timeSlot.startTime!;
      return bookingDate.year == selectedDay.year &&
          bookingDate.month == selectedDay.month &&
          bookingDate.day == selectedDay.day;
    }).toList();
    final lan = AppLocalizations.of(context)!;
    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              lan.noBookings,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(BronModel booking) {
    final lan = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 5,
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: booking.user.imageUrl != null
                        ? NetworkImage(booking.user.imageUrl!)
                        : null,
                    child: booking.user.imageUrl == null
                        ? Icon(Icons.person, size: 24, color: Colors.grey[600])
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.user.fullName ?? lan.client,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      "${DateFormat('HH:mm').format(booking.timeSlot.startTime!)} - "
                      "${DateFormat('HH:mm').format(booking.timeSlot.endTime!)}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        DateFormat('dd MMM')
                            .format(booking.timeSlot.startTime!),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _callUser(booking.user.phoneNumber),
                  icon: const Icon(Icons.phone),
                  label: Text(lan.call),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _callUser(String? phoneNumber) {
  if (phoneNumber != null && phoneNumber.isNotEmpty) {
    UrlLauncherService.callPhoneNumber(phoneNumber);
  }
}
