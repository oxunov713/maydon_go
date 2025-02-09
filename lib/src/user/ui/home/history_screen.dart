import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';


class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  DateTime parsedDate = DateTime.parse("2024-12-31 23:59:00");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        itemBuilder: (context, index) => ListTile(
          minTileHeight: 70,
          title: const Text(
            "Panda",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            "+998 (50) 002-07-13",
            style: TextStyle(),
          ),
          leading: SvgPicture.asset(AppIcons.historyIcon),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "$index soat",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                    fontSize: 15),
              ),
              Text(
                parsedDate.toString().substring(0, 10),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ],
          ),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.main)),
          tileColor: AppColors.green40,
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemCount: 10,
      ),
    );
  }
}
