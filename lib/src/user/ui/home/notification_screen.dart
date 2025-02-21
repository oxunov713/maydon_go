import 'package:flutter/material.dart';
import 'package:maydon_go/src/common/constants/config.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isRead = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isRead = !isRead;
              });
            },
            icon: Icon(Icons.done_all),
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) => NotificationItem(
          title: "Yangi Xabar",
          message: "Sizga yangi xabar keldi. Batafsil ma'lumot uchun bosing.",
          time: "2 soat oldin",
          isRead:isRead,
          // Misol uchun, juft indexlilar o'qilgan deb belgilandi
          imageUrl: $users[2].imageUrl!, // Rasm manzili
        ),
        separatorBuilder: (context, index) => Divider(height: 16),
        itemCount: 10, // Misol uchun 10 ta bildirishnoma
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String imageUrl;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey[200] : Colors.white,
        // O'qilgan va o'qilmaganlar uchun rang
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Rasm
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 24,
          ),
          SizedBox(width: 12),
          // Matnlar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isRead
                        ? Colors.grey
                        : Colors.black, // O'qilgan va o'qilmaganlar uchun rang
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: isRead ? Colors.grey : Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Vaqt
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
