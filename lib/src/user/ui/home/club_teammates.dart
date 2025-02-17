import 'package:flutter/material.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';

class ClubTeammates extends StatelessWidget {
  const ClubTeammates({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title:  Text("Tashkent Bulls")
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  tileColor: AppColors.white,
                  shape: StadiumBorder(),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage($users[index].imageUrl ??
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/AUT_vs._WAL_2016-10-06_%28155%29.jpg/1200px-AUT_vs._WAL_2016-10-06_%28155%29.jpg"),
                  ),
                  title: Text(
                      "${$users[index].firstName} ${$users[index].lastName}"),
                  subtitle: Text($users[index].contactNumber!),
                  trailing: IconButton(
                      onPressed: () {
                        //todo remove qilishi kerak teamdan
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        color: AppColors.red,
                      )),
                ),
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: $users.length),
      ),
    );
  }
}
