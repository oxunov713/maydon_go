import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/service/url_launcher_service.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/owner/bloc/add_stadium/add_stadium_cubit.dart';
import 'package:maydon_go/src/owner/bloc/add_stadium/add_stadium_state.dart';
import 'package:maydon_go/src/user/bloc/booking_cubit/booking_cubit.dart';
import 'package:maydon_go/src/user/bloc/booking_cubit/booking_state.dart';
import '../../../common/l10n/app_localizations.dart';
import '../../../common/model/time_slot_model.dart';

class BronListScreen extends StatefulWidget {
  const BronListScreen({super.key});

  @override
  State<BronListScreen> createState() => _BronListScreenState();
}

class _BronListScreenState extends State<BronListScreen> {
  final _scrollController = ScrollController();
  final _listKey = PageStorageKey<String>('bronList');

  @override
  void initState() {
    super.initState();
    context.read<AddStadiumCubit>().loadSubstadiums();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<AddStadiumCubit>().loadSubstadiums();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final l10n = AppLocalizations.of(context); // Access translations

    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: Text(l10n!.bookingListTitle),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        color: AppColors.green,
        onRefresh: () => context.read<AddStadiumCubit>().loadSubstadiums(),
        child: BlocBuilder<AddStadiumCubit, AddStadiumState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.green),
              );
            }

            if (!state.isLoading && !state.hasError) {
              final substadiums = state.substadiums;
              final allBookings = substadiums
                  .expand((substadium) => (substadium.bookings ?? [])
                      .map((bron) => _BookingWithStadium(
                            bron: bron,
                            stadiumName: substadium.name ?? l10n.unknownStadium,
                            startTime: bron.timeSlot.startTime!,
                          )))
                  .toList();

              allBookings.sort((a, b) => a.startTime.compareTo(b.startTime));

              if (allBookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 50, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noBookingsAvailable,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                key: _listKey,
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: allBookings.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final booking = allBookings[index];
                  return _buildBronListItem(context, booking, width, l10n);
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
              );
            }

            return Center(
              child: Text(
                state.errorMessage!.isNotEmpty
                    ? state.errorMessage!
                    : l10n.errorOccurred,
                style:
                    theme.textTheme.titleMedium?.copyWith(color: AppColors.red),
              ),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<AddStadiumCubit, AddStadiumState>(
        builder: (context, state) {
          final stadiumId = state.stadium.id;
          if (stadiumId != -1 &&
              stadiumId != null &&
              stadiumId.toString().isNotEmpty) {
            return FloatingActionButton(
              backgroundColor: AppColors.green,
              onPressed: () {
                context.pushNamed(
                  AppRoutes.detailStadium,
                  extra: stadiumId,
                );
              },
              child: const Icon(
                Icons.add,
                color: AppColors.white,
              ),
            );
          }

          // Agar stadion yo'q bo'lsa, FAB ko'rinmaydi
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBronListItem(BuildContext context, _BookingWithStadium booking,
      double width, AppLocalizations l10n) {
    final bron = booking.bron;
    return GestureDetector(
      onTap: () => _showBronDetails(context, booking, l10n),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: bron.user.imageUrl != null
                    ? NetworkImage(bron.user.imageUrl!)
                    : null,
                child: bron.user.imageUrl == null
                    ? const Icon(Icons.person, size: 24)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bron.user.fullName ?? l10n.noNameAvailable,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.stadiumName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.green3,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${DateFormat('HH:mm').format(bron.timeSlot.startTime!)} - ${DateFormat('HH:mm').format(bron.timeSlot.endTime!)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMMM').format(bron.timeSlot.startTime!),
                    style: const TextStyle(
                      color: AppColors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBronDetails(BuildContext context, _BookingWithStadium booking,
      AppLocalizations l10n) {
    final bron = booking.bron;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 40,
                backgroundImage: bron.user.imageUrl != null
                    ? NetworkImage(bron.user.imageUrl!)
                    : null,
                child: bron.user.imageUrl == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                bron.user.fullName ?? l10n.noNameAvailable,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                bron.user.phoneNumber ?? "5555",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Stadion: ${booking.stadiumName}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.phone, size: 20),
                        label: Text(l10n.call),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => UrlLauncherService.callPhoneNumber(
                            bron.user.phoneNumber ?? "555"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.close),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

// Stadion nomi bilan bronni birlashtirish uchun yordamchi sinf
class _BookingWithStadium {
  final BronModel bron;
  final String stadiumName;
  final DateTime startTime;

  _BookingWithStadium({
    required this.bron,
    required this.stadiumName,
    required this.startTime,
  });
}
