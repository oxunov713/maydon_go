import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../common/tools/language_extension.dart';
import '../../user/bloc/auth_cubit/auth_cubit.dart';
import '../../user/bloc/auth_cubit/auth_state.dart';
import '../router/app_routes.dart';
import '../style/app_colors.dart';
import '../widgets/role_widget.dart';
import '../widgets/sign_button.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                context.lan.appName,
                style: const TextStyle(
                  color: AppColors.main,
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 50),
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) => current is AuthRoleSelected,
                builder: (context, state) {
                  final selectedRole = (state is AuthRoleSelected)
                      ? state.selectedRole
                      : UserRole.none;
                  return Column(
                    children: [
                      buildRoleCard(
                        title: context.lan.roleUserTitle,
                        subtitle: context.lan.roleUserSubTitle,
                        isSelected: selectedRole == UserRole.user,
                        onTap: () =>
                            context.read<AuthCubit>().onRoleSelect(UserRole.user),
                      ),
                      buildRoleCard(
                        title: context.lan.roleOwnerTitle,
                        subtitle: context.lan.roleOwnerSubTitle,
                        isSelected: selectedRole == UserRole.owner,
                        onTap: () => context
                            .read<AuthCubit>()
                            .onRoleSelect(UserRole.owner),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return BottomSignButton(
              function: () => _onContinuePressed(context, state),
              text: context.lan.continueBt,
              isdisabledBT: (state is AuthRoleSelected),
            );
          },
        ),
      ),
    );
  }
}

void _onContinuePressed(BuildContext context, AuthState state) {
  if (state is AuthRoleSelected) {
    context.pushNamed(AppRoutes.signUp);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Iltimos, avval rolni tanlang!"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
