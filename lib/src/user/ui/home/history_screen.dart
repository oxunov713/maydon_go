import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final DateTime parsedDate = DateTime.parse("2024-12-31 23:59:00");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Ikkita tab: Active va History
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Bookings"),
          bottom: TabBar(
            indicatorColor: AppColors.green, // Aktiv tabni belgilash
            labelColor: AppColors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  "Active",
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.w600),
                ),
              ),
              Tab(
                child: Text(
                  "History",
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. Active Bookings
            _buildActiveBookings(),

            // 2. History Bookings
            _buildHistoryBookings(),
          ],
        ),
      ),
    );
  }

  // ** Active Bookings UI **
  Widget _buildActiveBookings() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      itemBuilder: (context, index) => ListTile(
        minTileHeight: 70,
        title: const Text(
          "Active Panda",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text(
          "+998 (50) 002-07-13",
        ),
        leading: SvgPicture.asset(AppIcons.historyIcon),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "📅 ${parsedDate.toString().substring(0, 10)}",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Text(
              "🕒 2 soat",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.green,
                fontSize: 15,
              ),
            ),
          ],
        ),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.green)),
        tileColor: AppColors.green40,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: 5, // Active bronlar soni
    );
  }

  // ** History Bookings UI **
  Widget _buildHistoryBookings() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      itemBuilder: (context, index) => ListTile(
        minTileHeight: 70,
        title: const Text(
          "History Panda",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text(
          "+998 (50) 002-07-13",
        ),
        leading: SvgPicture.asset(AppIcons.historyIcon),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "📅 ${parsedDate.toString().substring(0, 10)}",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Text(
              "🕒 3 soat",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.red, // Tarixiy bronlar qizil
                fontSize: 15,
              ),
            ),
          ],
        ),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.main)),
        tileColor: AppColors.green40,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemCount: 10, // Tarixiy bronlar soni
    );
  }
}
