import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';

import '../tools/position_enum.dart';

Future<Map<String, dynamic>?> showCreateClubDialog(BuildContext context) async {
  final TextEditingController nameController = TextEditingController();
  FootballPosition? selectedPosition;
  final formKey = GlobalKey<FormState>();

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create New Club',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.grey[600],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Club Name Field
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Club Name',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      prefixIcon: Icon(Icons.group, color: Colors.green[600]),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.green[400]!, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter club name';
                      }
                      if (value.length < 3) {
                        return 'Name too short (min 3 chars)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Position Dropdown
                  DropdownButtonFormField<FootballPosition>(
                    decoration: InputDecoration(
                      labelText: 'Your Position',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      prefixIcon:
                          Icon(Icons.sports_soccer, color: Colors.green[600]),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: FootballPosition.values.map((position) {
                      return DropdownMenuItem(
                        value: position,
                        child: Row(
                          spacing: 10,
                          children: [
                            Text(
                              position.abbreviation,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              position.fullName,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => selectedPosition = value,
                    validator: (value) =>
                        value == null ? 'Select your position' : null,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 2,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.green[600]),
                  ),

                  const SizedBox(height: 32),

                  // Create Button
                  // Create Button qismini quyidagicha o'zgartiring:
                  BlocBuilder<MyClubCubit, MyClubState>(
                    builder: (context, state) {
                      final isLoading = state is MyClubLoading;

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLoading
                                ? Colors.green[300]
                                : Colors.green[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<MyClubCubit>().createClub(
                                          nameController.text.trim(),
                                          selectedPosition!.abbreviation,
                                        );

                                    context.pop();
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'CREATE CLUB',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
