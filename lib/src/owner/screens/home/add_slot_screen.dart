import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import '../../../common/style/app_colors.dart';
import 'add_stadium_screen.dart'; // AddStadiumScreen ni import qilamiz

class AddSlotScreen extends StatefulWidget {
  const AddSlotScreen({super.key});

  @override
  _AddSlotScreenState createState() => _AddSlotScreenState();
}

class _AddSlotScreenState extends State<AddSlotScreen> {
  List<String> subStadiums = []; // Substadionlar ro'yxati

  @override
  Widget build(BuildContext context) {
    final bool isFirstTime = subStadiums
        .isEmpty; // Ro'yxat bo'sh bo'lsa birinchi marta kirilgan deb hisoblaymiz

    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(automaticallyImplyLeading: false,
        title: const Text("Stadiums"),
        actions: [
         //TODO add substadium

        ],
      ),
      body: Center(
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.green)),
          onPressed: () => context.pushNamed(AppRoutes.addStadium),
          child: Text(
            "Stadion qo'shish +",
            style:
                TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      // body: isFirstTime
      //     ? Center(
      //   child: TextButton(
      //     onPressed: () {
      //       // "Add Stadium" bosilganda AddStadiumScreen ga o'tish
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => AddStadiumScreen(),
      //         ),
      //       );
      //     },
      //     child: Text(
      //       "Add Stadium",
      //       style: TextStyle(fontSize: 20, color: AppColors.main),
      //     ),
      //   ),
      // )
      //     : GridView.builder(
      //   itemCount: subStadiums.length, // Substadionlar ro'yxati
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2, // 2 ta ustun
      //     childAspectRatio: 0.8, // Container nisbati
      //   ),
      //   itemBuilder: (context, index) {
      //     // Substadionlarni ko'rsatish
      //     final subStadium = subStadiums[index];
      //     return Column(
      //       children: [
      //         Container(
      //           height: 150,
      //           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(15),
      //             image: DecorationImage(
      //               fit: BoxFit.cover,
      //               image: AssetImage("assets/images/club_background.webp"),
      //             ),
      //           ),
      //         ),
      //         const SizedBox(height: 5),
      //         Text(
      //           subStadium,
      //           style: const TextStyle(
      //             fontSize: 16,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}

class AddSubStadiumScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sub Stadium'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Sub Stadium Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Substadion nomini saqlash va sahifani yopish
                    final subStadiumName = _nameController.text;
                    Navigator.pop(context, subStadiumName);
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
