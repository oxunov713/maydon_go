import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/stadium_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:maydon_go/src/common/tools/price_formatter_extension.dart';
import '../../../bloc/saved_stadium_cubit/saved_stadium_cubit.dart';
import '../../../bloc/saved_stadium_cubit/saved_stadium_state.dart';

class SavedStadiums extends StatefulWidget {
  const SavedStadiums({super.key});

  @override
  State<SavedStadiums> createState() => _SavedStadiumsState();
}

class _SavedStadiumsState extends State<SavedStadiums> {
  @override
  void initState() {
    super.initState();
    context.read<SavedStadiumsCubit>().loadSavedStadiums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        title: Text(context.lan.saved),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showSavedStadiumsBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.green,
        onRefresh: () => context.read<SavedStadiumsCubit>().loadSavedStadiums(),
        child: BlocBuilder<SavedStadiumsCubit, SavedStadiumsState>(
          builder: (context, state) {
            return switch (state) {
              SavedStadiumsLoading() => const Center(
                  child: CircularProgressIndicator(color: AppColors.green)),
              SavedStadiumsLoaded(:final savedStadiums) => savedStadiums.isEmpty
                  ? const Center(child: Text("Saqlangan stadionlar yo'q"))
                  : _buildStadiumList(context, savedStadiums),
              SavedStadiumsError(:final message) =>
                Center(child: Text(message)),
              _ => const Center(child: Text("Saqlangan stadionlar yo'q")),
            };
          },
        ),
      ),
    );
  }

  Widget _buildStadiumList(BuildContext context, List<StadiumDetail> stadiums) {
    final deviceHeight = MediaQuery.sizeOf(context).height;
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: stadiums.length,
      itemBuilder: (context, index) {
        final stadium = stadiums[index];
        return _StadiumTile(
          stadium: stadium,
          deviceHeight: deviceHeight,
          onTap: () =>
              context.pushNamed(AppRoutes.detailStadium, extra: stadium.id),
        );
      },
    );
  }

  void _showSavedStadiumsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SavedStadiumsBottomSheet(),
    );
  }
}

class _StadiumTile extends StatelessWidget {
  final StadiumDetail stadium;
  final double deviceHeight;
  final VoidCallback onTap;

  const _StadiumTile({
    required this.stadium,
    required this.deviceHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        onTap: onTap,

        leading: SvgPicture.asset(
          AppIcons.stadionsIcon,
          color: AppColors.green,
          height: deviceHeight * 0.04,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        tileColor: AppColors.white,
        title: Text(
          stadium.name ?? "Noma'lum",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: deviceHeight * 0.02),
        ),
        subtitle: Text(
          "${stadium.price?.formatWithSpace() ?? "Narx mavjud emas"} so'm",
          style: TextStyle(
            fontSize: deviceHeight * 0.017,
            color: AppColors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

class _SavedStadiumsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedStadiumsCubit, SavedStadiumsState>(
      builder: (context, state) {
        return switch (state) {
          SavedStadiumsLoading() =>
            const Center(child: CircularProgressIndicator()),
          SavedStadiumsLoaded(:final savedStadiums) => savedStadiums.isEmpty
              ? const Center(child: Text("Saqlangan stadionlar yo'q"))
              : _buildBottomSheetContent(context, savedStadiums),
          SavedStadiumsError(:final message) => Center(child: Text(message)),
          _ => const Center(child: Text("Saqlangan stadionlar yo'q")),
        };
      },
    );
  }

  Widget _buildBottomSheetContent(
      BuildContext context, List<StadiumDetail> savedStadiums) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: savedStadiums.length,
              itemBuilder: (context, index) {
                final stadium = savedStadiums[index];
                return ListTile(
                  title: Text(
                    stadium.name ?? "Noma'lum",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context
                        .read<SavedStadiumsCubit>()
                        .removeStadiumFromSaved(stadium),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Qaytish",
                style: TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
