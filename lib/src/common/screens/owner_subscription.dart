import 'package:flutter/material.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';

class OwnerSubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Obuna paketlari")),
      backgroundColor: AppColors.white2,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SubscriptionCard(
                title: "Toshkent shahar - 1 oy",
                price: "590 000 so‘m",
                isBought: false,
                onTap: () => _subscribe(context, "590 000 so‘m"),
              ),
              SubscriptionCard(
                title: "Toshkent shahar - 3 oy",
                price: "1 680 000 so‘m",
                isBought: true,
                onTap: () => _subscribe(context, "1 680 000 so‘m"),
              ),
              SubscriptionCard(
                title: "Toshkent shahar - 6 oy",
                price: "3 180 000 so‘m",
                isBought: false,
                onTap: () => _subscribe(context, "3 180 000 so‘m"),
              ),
              SizedBox(height: 20),
              SubscriptionCard(
                title: "Viloyatlar - 1 oy",
                price: "390 000 so‘m",
                isBought: false,
                onTap: () => _subscribe(context, "390 000 so‘m"),
              ),
              SubscriptionCard(
                title: "Viloyatlar - 3 oy",
                price: "1 110 000 so‘m",
                isBought: false,
                onTap: () => _subscribe(context, "1 110 000 so‘m"),
              ),
              SubscriptionCard(
                title: "Viloyatlar - 6 oy",
                price: "2 100 000 so‘m",
                isBought: false,
                onTap: () => _subscribe(context, "2 100 000 so‘m"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _subscribe(BuildContext context, String price) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Siz $price obunasini tanladingiz!")),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final VoidCallback onTap;
  final bool isBought;

  const SubscriptionCard({
    required this.title,
    required this.price,
    required this.onTap,
    required this.isBought,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: Colors.white,
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
        trailing: Text(
          isBought ? "Active" : "Noactive",
          style: TextStyle(
              color: isBought ? AppColors.green : AppColors.red,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
