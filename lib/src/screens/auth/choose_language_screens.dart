import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../tools/language_extension.dart';
import 'package:provider/provider.dart';

import '../../provider/locale_provider.dart';
import '../../router/app_routes.dart';
import '../../widgets/sign_button.dart';

class ChooseLanguageScreens extends StatefulWidget {
  const ChooseLanguageScreens({super.key});

  @override
  State<ChooseLanguageScreens> createState() => _ChooseLanguageScreensState();
}

class _ChooseLanguageScreensState extends State<ChooseLanguageScreens> {
  void _setLocale(String locale) {
    Provider.of<LocaleProvider>(context, listen: false)
        .setLocale(Locale(locale));
  }

//todo shu tilni tanlaganda yashil bo'lishi kerak rolescreenga o'xshab
//button o'zgarmasligi kerak yozuvi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.lan.chooseLanguage),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _setLocale("uz"),
              child: Text(context.lan.uzbek),
            ),
            ElevatedButton(
              onPressed: () => _setLocale("ru"),
              child: Text(context.lan.russian),
            ),
            ElevatedButton(
              onPressed: () => _setLocale("en"),
              child: Text(context.lan.english),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSignButton(
          isdisabledBT: true,
          function: () => context.pushNamed(AppRoutes.role),
          text: context.lan.continueBt),
    );
  }
}
