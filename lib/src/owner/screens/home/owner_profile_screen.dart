import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/api_image_service.dart';
import '../../../common/l10n/app_localizations.dart';
import '../../../common/router/app_routes.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../../user/bloc/profile_cubit/profile_cubit.dart';
import '../../../user/bloc/profile_cubit/profile_state.dart';
import '../../bloc/add_stadium/add_stadium_cubit.dart';
import '../../bloc/add_stadium/add_stadium_state.dart';

class OwnerProfileScreen extends StatefulWidget {
  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  @override
  void initState() {
    context.read<ProfileCubit>().loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context); // Access translations
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.profileTitle),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xffF2F3F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () => context.read<ProfileCubit>().loadUserData(),
            child: Column(
              spacing: 10,
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      return GestureDetector(
                        onTap: () => context.pushNamed(AppRoutes.profileView),
                        child: Container(
                          height: height * 0.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5, color: AppColors.secondary)
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: AppColors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: height * 0.05,
                                backgroundColor: AppColors.green2,
                                backgroundImage: state.user.imageUrl != null &&
                                        state.user.imageUrl!.isNotEmpty
                                    ? NetworkImage(state.user.imageUrl!)
                                    : null,
                                child: (state.user.imageUrl == null ||
                                        state.user.imageUrl!.isEmpty)
                                    ? Text(
                                        (state.user.fullName ?? "U")
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: height * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(width: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      textAlign: TextAlign.right,
                                      state.user.fullName ?? l10n.noName,
                                      style: TextStyle(fontSize: height * 0.03),
                                    ),
                                  ),
                                  Text(
                                    "${DateFormat('d').format(state.user.subscriptionModel?.timeSlot?.startTime ?? DateTime.now())}/${state.user.subscriptionModel?.durationInDays} kun",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.03,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: Text(l10n.noData),
                    );
                  },
                ),
                _listTile(
                  icon: AppIcons.notificationIcon,
                  title: l10n.notification,
                  onTap: () {
                    context.pushNamed(AppRoutes.notification);
                  },
                  isActive: false,
                ),
                _listTile(
                  icon: AppIcons.stadionsIcon,
                  title: l10n.subscription,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.ownerSubs),
                ),
                BlocBuilder<AddStadiumCubit, AddStadiumState>(
                  builder: (context, state) {
                    if (state.substadiums.isNotEmpty) {
                      return _listTile(
                        icons: Icons.image_outlined,
                        title: l10n.addImage,
                        isSvg: false,
                        isActive: false,
                        onTap: () => _pickMultipleImages(context, l10n),
                      );
                    }
                    return SizedBox();
                  },
                ),
                _listTile(
                  icon: AppIcons.faqIcon,
                  title: l10n.aboutApp,
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.about),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickMultipleImages(
      BuildContext context, AppLocalizations l10n) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: 50,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    final id = await context.read<AddStadiumCubit>().getCurrentStadium();
    Logger().e(id);
    if (images.isNotEmpty) {
      try {
        await ApiImageService(ApiClient().dio).addStadiumImages(id, images);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.imagesUploadedSuccess)),
        );
      } catch (e) {
        print('Rasmlarni yuklashda xatolik: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n.imageUploadError(
            '{error}',
          ))),
        );
      }
    } else {
      print('Rasmlar tanlanmadi');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noImagesSelected)),
      );
    }
  }

  Widget _listTile({
    String? icon,
    required String title,
    required Function() onTap,
    required bool isActive,
    bool isSvg = true,
    IconData? icons,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Card(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 15,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    isSvg ? SvgPicture.asset(icon!) : Icon(icons),
                    Text(title),
                  ],
                ),
                Row(
                  children: [
                    isActive
                        ? CircleAvatar(
                            radius: 4,
                            backgroundColor: AppColors.red,
                          )
                        : SizedBox(),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
