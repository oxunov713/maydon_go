import 'package:flutter/material.dart';

import '../style/app_colors.dart';

Widget buildRoleCard({
  required String title,
  required String subtitle,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Container(
    height: 90,
    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(
        width: isSelected ? 2 : 1,
        color: isSelected ? AppColors.green : AppColors.grey4,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: isSelected ? AppColors.green : AppColors.grey4,
            radius: 18,
            child: CircleAvatar(
              backgroundColor: AppColors.white,
              radius: isSelected ? 16 : 17,
              child: isSelected
                  ? CircleAvatar(
                      backgroundColor: AppColors.green,
                      radius: 11,
                    )
                  : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.main,
                  fontSize: 20,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 30),
        ],
      ),
    ),
  );
}
