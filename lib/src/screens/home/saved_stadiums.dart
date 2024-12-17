import 'package:flutter/material.dart';
import 'package:maydon_go/src/tools/extension_custom.dart';
import 'package:provider/provider.dart';
import '../../model/stadium_model.dart';
import '../../provider/saved_stadium_provider.dart';
import '../../style/app_colors.dart';
import 'stadium_detail.dart';

class SavedStadiumsScreen extends StatefulWidget {
  const SavedStadiumsScreen({super.key});

  @override
  State<SavedStadiumsScreen> createState() => _SavedStadiumsScreenState();
}

class _SavedStadiumsScreenState extends State<SavedStadiumsScreen> {
  void _navigateToDetailScreen(Stadium stadium) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StadiumDetailScreen(stadium: stadium),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Saqlangan stadionlarni olish
    final savedStadiums =
        Provider.of<SavedStadiumsProvider>(context).savedStadiums;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Stadiums"),
      ),
      body: savedStadiums.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              itemBuilder: (context, index) {
                final stadium = savedStadiums[index];
                return ListTile(
                  minTileHeight: 70,
                  onTap: () => _navigateToDetailScreen(stadium),
                  title: Text(
                    stadium.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    stadium.location.address,
                    style: const TextStyle(),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      context
                              .watch<SavedStadiumsProvider>()
                              .isStadiumSaved(stadium)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: AppColors.green,
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
                  ),
                  trailing: Text(
                    stadium.price.formatWithSpace(), // Stadion narxi
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                      fontSize: 15,
                    ),
                  ),
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.green),
                  ),
                  tileColor: AppColors.green.withOpacity(0.1),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemCount: savedStadiums.length, // Saqlangan stadionlar soni
            )
          : Center(child: Text("No items")),
    );
  }
}
