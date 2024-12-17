import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/data/fake_data.dart';
import 'package:maydon_go/src/model/stadium_model.dart';
import 'package:maydon_go/src/tools/extension_custom.dart';
import 'package:provider/provider.dart';

import '../../provider/saved_stadium_provider.dart';
import '../../style/app_colors.dart';

class StadiumDetailScreen extends StatelessWidget {
  final Stadium stadium;

  const StadiumDetailScreen({Key? key, required this.stadium})
      : super(key: key);

  StadiumOwner? findStadiumOwnerByStadium(
      Stadium stadium, List<StadiumOwner> stadiumOwners) {
    // Har bir stadion egasini tekshirib, agar stadionga tegishli bo'lsa, qaytariladi
    for (var owner in stadiumOwners) {
      if (owner.stadium.id == stadium.id) {
        return owner; // Agar topilsa, stadion egasini qaytaradi
      }
    }
    return null; // Agar stadion egasi topilmasa, null qaytaradi
  }

  @override
  Widget build(BuildContext context) {
    // Format the price for display
    final priceFormatted = NumberFormat.currency(symbol: '\$', decimalDigits: 2)
        .format(stadium.price);
    final number = findStadiumOwnerByStadium(stadium, FakeData.stadiumOwners);
    // Group available slots by date
    Map<String, List<AvailableSlot>> groupedSlots = {};
    for (var slot in stadium.availableSlots) {
      final dateFormatted = DateFormat("yyyy-MM-dd").format(slot.startTime);
      if (!groupedSlots.containsKey(dateFormatted)) {
        groupedSlots[dateFormatted] = [];
      }
      groupedSlots[dateFormatted]?.add(slot);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(stadium.name),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<SavedStadiumsProvider>().isStadiumSaved(stadium)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: AppColors.white,
              size: 30,
            ),
            onPressed: () {
              // Stadionni saqlash yoki olib tashlash
              if (context
                  .read<SavedStadiumsProvider>()
                  .isStadiumSaved(stadium)) {
                context
                    .read<SavedStadiumsProvider>()
                    .removeStadiumFromSaved(stadium);
              } else {
                context
                    .read<SavedStadiumsProvider>()
                    .addStadiumToSaved(stadium);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(
                  stadium.images.first,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Text(
                      stadium.name,
                      style: TextStyle(
                          fontSize: 22,
                          color: AppColors.main,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      stadium.description,
                      style: TextStyle(fontSize: 16, color: AppColors.main),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    "Phone: ",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.main,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " ${number?.phoneNumber}",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.main,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Location: ",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.main,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " ${stadium.location.address}",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.main,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Yuvinish xonasi: ",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.main,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " ${stadium.facilities.hasBathroom ? 'Bor' : "Yo'q"}",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.main,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Usti yopiq stadion ",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.main,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " ${stadium.facilities.hasRestroom ? 'Bor' : "Yo'q"}",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.main,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Forma & koptok ",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.main,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    " ${stadium.facilities.hasUniforms ? 'Bor' : "Yo'q"}",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.main,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Soati: ",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.main,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    stadium.price.formatWithSpace() + " so'm",
                    style: TextStyle(
                        fontSize: 22,
                        color: AppColors.green,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "Mavjud vaqtlar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              for (var date in groupedSlots.keys)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat("dd MMMM yyyy").format(DateTime.parse(date)),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      // Display slots for the specific date
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: groupedSlots[date]!.length,
                        itemBuilder: (context, index) {
                          final slot = groupedSlots[date]![index];
                          return Card(
                            color: Colors.green.shade100,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                "${slot.startTime.hour}:${slot.startTime.minute.toString().padLeft(2, '0')} - ${slot.endTime.hour}:${slot.endTime.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.navigate_next,
                                    color: AppColors.green),
                                onPressed: () {},
                              ),
                              onTap: () {
                                // Navigate to the payment page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(amount: stadium.price,),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final double amount;

  PaymentPage({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Page"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your car number to pay:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            Text(
              'Amount: ${amount.formatWithSpace()} so\'m',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
