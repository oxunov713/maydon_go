import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';
import 'package:maydon_go/src/common/widgets/sign_button.dart';

import '../../bloc/add_stadium/add_stadium_cubit.dart';
import '../../bloc/add_stadium/add_stadium_state.dart';

class AddStadiumScreen extends StatelessWidget {
  const AddStadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          title: const Text('Add Stadium'),
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
    return BlocConsumer<AddStadiumCubit, AddStadiumState>(
      listener: (context, state) {
        if (state.status == AddStadiumStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Stadium added successfully!')),
          );
          context.read<AddStadiumCubit>().reset();
          context.pop();
        } else if (state.status == AddStadiumStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error occurred')),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddStadiumCubit>();

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
                label: 'Name',
                hint: "ex: Novza stadioni",
                icon: Icons.stadium,
                value: state.name,
                onChanged: cubit.updateName,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Description',
                hint: "ex: Barcha qulayliklar ega stadion",
                icon: Icons.description,
                value: state.description,
                onChanged: cubit.updateDescription,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Price',
                hint: "ex: 200 000 so'm",
                icon: Icons.attach_money,
                value: state.price,
                onChanged: cubit.updatePrice,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                label: 'Stadium count',
                hint: "ex: Yonma-yon stadionlar soni",
                icon: Icons.numbers,
                value: state.count,
                onChanged: cubit.updateCount,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildLocationPicker(context),
              const SizedBox(height: 20),
              _buildImagePicker(context, cubit, state),
              if (state.selectedImages.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildImagePreview(state),
              ],
              const SizedBox(height: 20),
              _buildSwitchListTile(
                title: "Forma mavjudmi?",
                value: state.hasUniforms,
                onChanged: (_) => cubit.toggleHasUniforms(),
              ),
              const SizedBox(height: 20),
              _buildSwitchListTile(
                title: "Dush mavjudmi?",
                value: state.hasBathroom,
                onChanged: (_) => cubit.toggleHasBathroom(),
              ),
              const SizedBox(height: 20),
              _buildSwitchListTile(
                title: "Yopiq stadion mavjudmi?",
                value: state.isIndoor,
                onChanged: (_) => cubit.toggleIsIndoor(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: BottomSignButton(
                  function: () =>
                      state.isValid ? () => cubit.submitStadium() : null,
                  text: "Submit",
                  isdisabledBT: !state.isValid,
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
    required IconData icon,
    required String value,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.main),
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
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildLocationPicker(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.locationPicker),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.main, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Location from Google Maps',
              style: TextStyle(color: AppColors.main),
            ),
            Icon(Icons.location_pin, color: AppColors.main),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(
    BuildContext context,
    AddStadiumCubit cubit,
    AddStadiumState state,
  ) {
    return InkWell(
      onTap: cubit.pickImages,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.main, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, color: AppColors.main),
            const SizedBox(width: 10),
            Text(
              'Pick Images',
              style: TextStyle(color: AppColors.main),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(AddStadiumState state) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: state.selectedImages.map((image) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
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
