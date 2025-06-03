import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:maydon_go/src/common/service/app_review_service.dart';
import 'package:maydon_go/src/common/service/url_launcher_service.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';

import '../../../../common/style/app_colors.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Color(0xffF2F3F5),
      appBar: AppBar(
        title: Text("Biz bilan bog'lanish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Image.asset(AppIcons.uzbIcon),
            Column(
              spacing: 10,
              children: [
                Text("Biz bilan bog'lanish"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          UrlLauncherService.callPhoneNumber("+998500020713"),
                      child: SizedBox.square(
                        dimension: height * 0.08,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                  offset: Offset(
                                      -3, 4), // Chapga va pastga yo‘nalish
                                ),
                              ]),
                          child: Icon(
                            Icons.phone,
                            size: height * 0.05,
                            color: AppColors.green3,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => UrlLauncherService.openInstagram("oxunov_713"),
                      child: SizedBox.square(
                        dimension: height * 0.1,
                        child: Image.asset(
                          AppIcons.instagram,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => UrlLauncherService.openTelegram("oxunov_713"),
                      child: SizedBox.square(
                        dimension: height * 0.1,
                        child: Image.asset(
                          AppIcons.telegram,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => UrlLauncherService.sendEmail("aoxunov713@gmail.com"),
                      child: SizedBox.square(
                        dimension: height * 0.1,
                        child: Image.asset(
                          AppIcons.gmail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => ReviewService.requestReview(),
                  child: Container(
                    height: height * 0.08,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Text(
                      "Bizni baholang",
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.02),
                    )),
                  ),
                ),
                Text(
                  "Ilova versiyasi 1.0.0.0",
                  style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.015),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
