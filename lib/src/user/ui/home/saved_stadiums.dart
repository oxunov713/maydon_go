import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../common/tools/price_formatter_extension.dart';
import '../../../common/router/app_routes.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../bloc/saved_stadium_cubit/saved_stadium_cubit.dart';
import '../../bloc/saved_stadium_cubit/saved_stadium_state.dart';

class SavedStadiums extends StatefulWidget {
  const SavedStadiums({super.key});

  @override
  State<SavedStadiums> createState() => _SavedStadiumsState();
}

class _SavedStadiumsState extends State<SavedStadiums> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: const Text("Saqlanganlar"),
        centerTitle: true,
      ),
      body: BlocBuilder<SavedStadiumsCubit, SavedStadiumsState>(
        builder: (context, state) {
          if (state is SavedStadiumsLoaded) {
            final savedStadiums = state.savedStadiums;

            return ListView.builder(
              itemCount: savedStadiums.length,
              itemBuilder: (context, index) {
                final stadium = savedStadiums[index];

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () => context.pushNamed(AppRoutes.detailStadium,
                        extra: stadium),
                    leading: SvgPicture.asset(
                      AppIcons.stadionsIcon,
                      color: AppColors.green,
                      height: deviceHeight * 0.04,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    tileColor: AppColors.white,
                    title: Text(
                      stadium.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: deviceHeight * 0.02,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${stadium.price.formatWithSpace()} so'm",
                          style: TextStyle(
                            fontSize: deviceHeight * 0.017,
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Saqlangan stadionlar yo‘q"),
            );
          }
        },
      ),
    );
  }
}
