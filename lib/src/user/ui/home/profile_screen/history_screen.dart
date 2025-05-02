import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/common/model/time_slot_model.dart';
import 'package:maydon_go/src/common/service/url_launcher_service.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/user/bloc/booking_cubit/booking_cubit.dart';
import 'package:maydon_go/src/user/bloc/booking_history/booking_history_cubit.dart';

import '../../../../common/service/booking_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<BookingHistoryCubit>().fetchBookingHistories();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      context.read<BookingHistoryCubit>().fetchBookingHistories();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Bookings"),
          bottom: const TabBar(
            indicatorColor: AppColors.green,
            labelColor: AppColors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Active"),
              Tab(text: "History"),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
          builder: (context, state) {
            return switch (state) {
              BookingHistoryLoading() =>
                const Center(child: CircularProgressIndicator()),
              BookingHistoryError(:final message) =>
                Center(child: Text('Error: $message')),
              BookingHistoryLoaded(:final bookingHistories) => TabBarView(
                  children: [
                    _buildActiveBookings(bookingHistories),
                    _buildHistoryBookings(bookingHistories),
                  ],
                ),
              _ => const Center(child: Text('No data available')),
            };
          },
        ),
      ),
    );
  }

  Widget _buildActiveBookings(List<Map<String, dynamic>> bookingHistories) {
    final activeBookings = bookingHistories.where((history) {
      final booking = _parseBooking(history);
      return booking.startTime?.isAfter(DateTime.now()) ?? false;
    }).toList();

    activeBookings.sort((a, b) {
      final aTime = _parseBooking(a).startTime;
      final bTime = _parseBooking(b).startTime;
      return aTime!.compareTo(bTime!);
    });

    return _buildBookingList(activeBookings, AppColors.green);
  }

  Widget _buildHistoryBookings(List<Map<String, dynamic>> bookingHistories) {
    final historyBookings = bookingHistories.where((history) {
      final booking = _parseBooking(history);
      return booking.endTime?.isBefore(DateTime.now()) ?? false;
    }).toList();

    historyBookings.sort((a, b) {
      final aTime = _parseBooking(a).endTime;
      final bTime = _parseBooking(b).endTime;
      return bTime!.compareTo(aTime!);
    });

    return _buildBookingList(historyBookings, Colors.red);
  }

  TimeSlot _parseBooking(Map<String, dynamic> history) {
    try {
      final booking = history['booking'];
      if (booking is Map<String, dynamic>) {
        return TimeSlot.fromJson(booking);
      } else if (booking is Map) {
        return TimeSlot.fromJson(booking.cast<String, dynamic>());
      }
      throw Exception('Invalid booking format');
    } catch (e) {
      debugPrint('Error parsing booking: $e');
      return TimeSlot(startTime: DateTime.now(), endTime: DateTime.now());
    }
  }

  Widget _buildBookingList(
      List<Map<String, dynamic>> bookings, Color statusColor) {
    if (bookings.isEmpty) {
      return const Center(child: Text("Hech qanday bron topilmadi"));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      physics: const BouncingScrollPhysics(),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final bookingHistory = bookings[index];
        return _BookingTile(
          bookingHistory: bookingHistory,
          statusColor: statusColor,
          onTap: () => _showBottomSheet(context, bookingHistory, statusColor),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 15),
    );
  }

  void _showBottomSheet(BuildContext context,
      Map<String, dynamic> bookingHistory, Color statusColor) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _BookingBottomSheet(
        bookingHistory: bookingHistory,
        statusColor: statusColor,
        onDelete: (key) {
          context.pop();
        },
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final Map<String, dynamic> bookingHistory;
  final Color statusColor;
  final VoidCallback onTap;

  const _BookingTile({
    required this.bookingHistory,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final stadiumName =
        bookingHistory['stadiumName'] as String? ?? "Noma'lum stadion";
    final stadiumPhoneNumber =
        bookingHistory['stadiumPhoneNumber'] as String? ??
            "Noma'lum telefon raqami";
    final booking = _parseBooking(bookingHistory);
    final dateFormat = DateFormat('dd-MM-yyyy');

    return ListTile(
      minTileHeight: 70,
      onTap: onTap,
      title: Text(
        stadiumName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(stadiumPhoneNumber),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            booking.startTime != null
                ? dateFormat.format(booking.startTime!)
                : 'Noma\'lum',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          Text(
            "${booking.startTime?.hour ?? 0}:00 - ${booking.endTime?.hour ?? 0}:00",
            style: TextStyle(
                fontWeight: FontWeight.w700, color: statusColor, fontSize: 15),
          ),
        ],
      ),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.main),
      ),
      tileColor: AppColors.green40,
    );
  }

  TimeSlot _parseBooking(Map<String, dynamic> history) {
    try {
      final booking = history['booking'];
      if (booking is Map<String, dynamic>) {
        return TimeSlot.fromJson(booking);
      } else if (booking is Map) {
        return TimeSlot.fromJson(booking.cast<String, dynamic>());
      }
      throw Exception('Invalid booking format');
    } catch (e) {
      debugPrint('Error parsing booking: $e');
      return TimeSlot(startTime: DateTime.now(), endTime: DateTime.now());
    }
  }
}

class _BookingBottomSheet extends StatelessWidget {
  final Map<String, dynamic> bookingHistory;
  final Color statusColor;
  final Function(String) onDelete;

  const _BookingBottomSheet({
    required this.bookingHistory,
    required this.statusColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final stadiumName =
        bookingHistory['stadiumName'] as String? ?? "Noma'lum stadion";
    final phoneNumber = bookingHistory['stadiumPhoneNumber'] as String? ??
        "Noma'lum telefon raqami";
    final booking = _parseBooking(bookingHistory);
    final key =
        '${bookingHistory['stadiumId']}-${booking.startTime?.toIso8601String() ?? ''}';

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            stadiumName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Bron vaqti",
            style: TextStyle(
                fontSize: 16,
                color: AppColors.grey4,
                fontWeight: FontWeight.w600),
          ),
          if (statusColor == AppColors.green)
            Text(
              "${booking.startTime?.hour ?? 0}:00 - ${booking.endTime?.hour ?? 0}:00",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                  fontSize: 15),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                icon: const Icon(Icons.phone, color: AppColors.white),
                label: const Text("Call",
                    style: TextStyle(color: AppColors.white)),
                onPressed: () {
                  UrlLauncherService.callPhoneNumber(phoneNumber);
                  context.pop();
                },
              ),
              if (statusColor == AppColors.green)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Icons.close, color: AppColors.white),
                  label: const Text("Bekor qilish",
                      style: TextStyle(color: AppColors.white)),
                  onPressed: () {
                    onDelete(key);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  TimeSlot _parseBooking(Map<String, dynamic> history) {
    try {
      final booking = history['booking'];
      if (booking is Map<String, dynamic>) {
        return TimeSlot.fromJson(booking);
      } else if (booking is Map) {
        return TimeSlot.fromJson(booking.cast<String, dynamic>());
      }
      throw Exception('Invalid booking format');
    } catch (e) {
      debugPrint('Error parsing booking: $e');
      return TimeSlot(startTime: DateTime.now(), endTime: DateTime.now());
    }
  }
}
