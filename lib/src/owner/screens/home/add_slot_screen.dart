import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/substadium_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/owner/bloc/add_stadium/add_stadium_cubit.dart';
import 'package:maydon_go/src/owner/bloc/add_stadium/add_stadium_state.dart';

import '../../../common/l10n/app_localizations.dart';

class AddSlotScreen extends StatefulWidget {
  const AddSlotScreen({super.key});

  @override
  _AddSlotScreenState createState() => _AddSlotScreenState();
}

class _AddSlotScreenState extends State<AddSlotScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddStadiumCubit>().loadSubstadiums();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final crossAxisCount = isTablet ? 3 : 2;
    final l10n = AppLocalizations.of(context); // Access translations

    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: Text(l10n!.appTitle),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<AddStadiumCubit>().loadSubstadiums(),
        color: AppColors.green,
        child: BlocConsumer<AddStadiumCubit, AddStadiumState>(
          listener: (context, state) {
            if (state.isSuccess) {
              context.read<AddStadiumCubit>().loadSubstadiums();
            }
            if (state.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? l10n.dataLoadError),
                  backgroundColor: AppColors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.green),
              );
            }

            if (state.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 50, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(l10n.dataLoadError),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          context.read<AddStadiumCubit>().loadSubstadiums(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              );
            }

            if (state.substadiums.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sports_soccer,
                        size: 80, color: Colors.grey),
                    const SizedBox(height: 20),
                    Text(
                      l10n.noFieldsFound,
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 32 : 24,
                          vertical: isTablet ? 16 : 12,
                        ),
                      ),
                      onPressed: () => context.pushNamed(AppRoutes.addStadium),
                      child: Text(l10n.addField),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: isTablet ? 24 : 16,
                  mainAxisSpacing: isTablet ? 24 : 16,
                  childAspectRatio: isTablet ? 0.9 : 0.8,
                ),
                itemCount: state.substadiums.length,
                itemBuilder: (context, index) {
                  return _buildSubstadiumCard(
                      state.substadiums[index], isTablet, l10n);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubstadiumCard(
      Substadiums substadium, bool isTablet, AppLocalizations l10n) {
    final bookingCount = substadium.bookings?.length ?? 0;
    final statusColor = bookingCount > 0 ? AppColors.green : Colors.grey;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.green.withOpacity(0.1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        size: isTablet ? 60 : 40,
                        color: AppColors.green,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        substadium.name ?? l10n.unknownField,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: isTablet ? 8 : 4),
                  Text(
                    bookingCount > 0 ? l10n.booked : l10n.available,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: isTablet ? 16 : 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "$bookingCount ta",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isTablet ? 14 : 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 14 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed(
                      AppRoutes.subStadium,
                      extra: substadium,
                    );
                  },
                  child: Text(
                    l10n.manage,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}