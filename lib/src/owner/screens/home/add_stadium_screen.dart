import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';
import 'package:maydon_go/src/common/widgets/sign_button.dart';
import '../../../common/l10n/app_localizations.dart';
import '../../bloc/add_stadium/add_stadium_cubit.dart';
import '../../bloc/add_stadium/add_stadium_state.dart';

class AddStadiumScreen extends StatelessWidget {
  const AddStadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.addStadiumTitle),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.green,
        ),
        body: const _AddStadiumForm(),
      ),
    );
  }
}

class _AddStadiumForm extends StatelessWidget {
  const _AddStadiumForm();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<AddStadiumCubit>();

    return BlocConsumer<AddStadiumCubit, AddStadiumState>(
      listenWhen: (previous, current) =>
          previous.isSuccess != current.isSuccess ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.isSuccess && !state.isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.stadiumAddedSuccess)),
          );
          context.goNamed(AppRoutes.ownerDashboard);
        }
        if (state.errorMessage != null && !state.isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(AppIcons.uzbIcon),
              ),
              const SizedBox(height: 25),
              _buildTextField(
                label: l10n.nameLabel,
                hint: l10n.nameHint,
                value: state.name,
                onChanged: cubit.updateName,
                errorText: state.isFormSubmitted && state.name.isEmpty
                    ? l10n.nameRequired
                    : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: l10n.descriptionLabel,
                hint: l10n.descriptionHint,
                value: state.description,
                onChanged: cubit.updateDescription,
                errorText: state.isFormSubmitted && state.description.isEmpty
                    ? l10n.descriptionRequired
                    : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: l10n.priceLabel,
                hint: l10n.priceHint,
                value: state.price,
                onChanged: cubit.updatePrice,
                keyboardType: TextInputType.number,
                errorText: state.isFormSubmitted && state.price.isEmpty
                    ? l10n.priceRequired
                    : null,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: l10n.stadiumCountLabel,
                hint: l10n.stadiumCountHint,
                value: state.count.toString(),
                onChanged: cubit.updateCount, // O'zgartirish
                keyboardType: TextInputType.number,
                errorText: state.isFormSubmitted && state.count <= 0
                    ? l10n.stadiumCountRequired
                    : null,
              ),
              const SizedBox(height: 15),
              _buildLocationPicker(context, state, l10n),
              const SizedBox(height: 20),
              _buildSwitchListTile(
                title: l10n.hasUniforms,
                value: state.hasUniforms,
                onChanged: (_) => cubit.toggleHasUniforms(),
              ),
              const SizedBox(height: 20),
              _buildSwitchListTile(
                title: l10n.hasBathroom,
                value: state.hasBathroom,
                onChanged: (_) => cubit.toggleHasBathroom(),
              ),
              const SizedBox(height: 20),
              _buildSwitchListTile(
                title: l10n.isIndoor,
                value: state.isIndoor,
                onChanged: (_) => cubit.toggleIsIndoor(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: BottomSignButton(
                  function: () {
                    state.isSubmitting ? null : (cubit.submitStadium(),);
                  },
                  text: state.isSubmitting ? l10n.submitting : l10n.submit,
                  isdisabledBT: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.main, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.green, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.red, width: 2),
        ),
        errorText: errorText,
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildLocationPicker(
      BuildContext context, AddStadiumState state, AppLocalizations l10n) {
    return InkWell(
      onTap: () async {
        final locationData = await context.pushNamed<Map<String, dynamic>>(
          AppRoutes.locationPicker,
        );
        if (locationData != null) {
          context.read<AddStadiumCubit>().updateLocation(locationData);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.main, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                state.locationData['address'] ?? l10n.selectLocation,
                style: TextStyle(
                  color:
                      state.latitude == null ? AppColors.main : AppColors.green,
                ),
              ),
            ),
            Icon(
              Icons.location_pin,
              color: state.latitude == null ? AppColors.main : AppColors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.main, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(title),
      onChanged: onChanged,
      value: value,
      activeColor: AppColors.green,
      inactiveTrackColor: AppColors.white,
      inactiveThumbColor: AppColors.secondary,
    );
  }
}
