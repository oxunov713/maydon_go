import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/service/url_launcher_service.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';

class BronListScreen extends StatefulWidget {
  const BronListScreen({super.key});

  @override
  State<BronListScreen> createState() => _BronListScreenState();
}

class _BronListScreenState extends State<BronListScreen> {
  String _currentTime = "";

  @override
  void initState() {
    super.initState();

    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm').format(DateTime.now());
    });
    // Har soniya soatni yangilash
    Future.delayed(const Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Bronlar listi"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                _currentTime,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: $users.length,
          itemBuilder: (context, index) => ListTile(
            tileColor: Colors.white,
            leading: CircleAvatar(
              backgroundImage: NetworkImage($users[index].imageUrl!),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            title: Text(
              "${$users[index].firstName} ${$users[index].lastName}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Stadium $index",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.25,
                  height: 30,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.green3,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      customBorder: const StadiumBorder(),
                      onTap: () {},
                      child: Center(
                        child: Text(
                          "${DateFormat('HH:mm').format(DateTime.parse("2025-02-10T10:00:00"))} - ${DateFormat('HH:mm').format(DateTime.parse("2025-02-10T14:00:00"))}",
                          style: TextStyle(
                            //fontSize: 14,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "16-sentabr",
                  style: TextStyle(
                      color: AppColors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            onTap: () => _showBottomSheet(context, index),
          ),
          separatorBuilder: (context, index) => SizedBox(height: 15),
        ),
      ),
    );
  }
}

void _showBottomSheet(BuildContext context, int index) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),

            /// Profil rasmi
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage($users[index].imageUrl!),
                ),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.edit, color: Colors.white, size: 15),
                ),
              ],
            ),
            SizedBox(height: 10),

            /// Ism va kontakt ma'lumotlari
            Text(
              "${$users[index].firstName} ${$users[index].lastName}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text(
              "${$users[index].contactNumber}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),

            /// Ajratilgan vaqt va sanasi
            Divider(height: 20),

            /// Tugmalar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => UrlLauncherService.callPhoneNumber(
                      $users[index].contactNumber!),
                  icon: Icon(Icons.phone, color: Colors.white),
                  label: Text("Qo‘ng‘iroq qilish"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Yopish"),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
