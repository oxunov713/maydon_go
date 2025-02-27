import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../user/bloc/locale_cubit/locale_cubit.dart';
import '../router/app_routes.dart';
import '../style/app_colors.dart';
import '../widgets/sign_button.dart';

class ChooseLanguageScreens extends StatelessWidget {
  const ChooseLanguageScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: BlocBuilder<LocaleCubit, Locale>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Text(
                      "Choose language",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.sizeOf(context).height / 22,
                      ),
                    ),
                    _buildLanguageButton(context, "uz", "O'zbek tili", state),
                    _buildLanguageButton(context, "ru", "Русский", state),
                    _buildLanguageButton(context, "en", "English", state),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomSignButton(
          isdisabledBT: true,
          function: () => context.pushNamed(AppRoutes.welcome),
          text: "Continue",
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    String locale,
    String text,
    Locale selectedLocale,
  ) {
    bool isSelected = selectedLocale.languageCode == locale;

    return ListTile(
      onTap: () => context.read<LocaleCubit>().setLocale(locale),
      shape: const StadiumBorder(
          side: BorderSide(color: AppColors.grey4, width: 1.5)),
      leading: CountryFlag.fromLanguageCode(
        locale,
        shape: const Circle(),
      ),
      title: Text(text),
      trailing: CircleAvatar(
        backgroundColor: isSelected ? AppColors.green : AppColors.grey4,
        radius: 13,
        child: CircleAvatar(
          backgroundColor: AppColors.white,
          radius: 10.5,
          child: isSelected
              ? const CircleAvatar(
                  backgroundColor: AppColors.green,
                  radius: 7,
                )
              : null,
        ),
      ),
    );
  }
}
