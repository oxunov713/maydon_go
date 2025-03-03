import 'package:flutter/material.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/widgets/sign_button.dart';

class SubscriptionScreen extends StatefulWidget {
  SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription"),
      ),
      backgroundColor: AppColors.white2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildSubscriptionCard(
              title: "Go",
              isGo: false,
              price: "0 so'm/oyiga",
              color: isActive ? AppColors.grey4 : AppColors.green,
              borderColor: isActive ? AppColors.grey4 : AppColors.green3,
              benefits: [
                "Bepul band qilish",
                "Oyiga 5 ta stadionni band qilish",
                "Kuniga 2 ta slotni band qilish",
                "Oyiga umumiy 3 kunni band qilish imkoniyati",
                "10 tagacha do‘stlar to'plash",
                "Har bir brondan +10 coins",
                "1 ta jamoa tuzishga ruxsat"
              ],
            ),
            _buildSubscriptionCard(
              title: "Go +",
              isGo: true,
              price: "19 900 so'm/oyiga",
              color: isActive ? AppColors.green : AppColors.grey4,
              borderColor: isActive ? AppColors.green3 : AppColors.grey4,
              benefits: [
                "Bepul band qilish",
                "Oyiga cheksiz stadion band qilish",
                "Kuniga 5 tagacha slotni band qilish",
                "Oyiga umumiy 15 kunni band qilish imkoniyati",
                "100 tagacha do‘stlar to'plash",
                "Har bir brondan +15 coins",
                "5 tagacha jamoa tuzishga ruxsat",
                "Turnirlarda qatnashish imkoniyati",
                "Ko‘proq quiz yechish imkoniyati",
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSignButton(
        function: () {},
        text: "Sotib olish",
        isdisabledBT: isActive,
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required bool isGo,
    required String title,
    required String price,
    required Color color,
    required Color borderColor,
    required List<String> benefits,
  }) {
    return GestureDetector(
      onTap: () {
        isGo ? isActive = true : isActive = false;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.white,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: color,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(thickness: 2),
            ...benefits.map(
              (benefit) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.black),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                price,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.green3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
