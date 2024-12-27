import 'package:flutter/material.dart';
import 'package:maydon_go/src/widgets/sign_button.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../style/app_colors.dart';
import '../../widgets/role_widget.dart';
import '../../tools/language_extension.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.lan.appName,
                  style: const TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 50),
                buildRoleCard(
                  title: context.lan.roleUserTitle,
                  subtitle: context.lan.roleUserSubTitle,
                  isSelected: Provider.of<AuthProvider>(context).userSelected,
                  onTap: () => Provider.of<AuthProvider>(context, listen: false)
                      .onRoleSelect(true),
                ),
                buildRoleCard(
                  title: context.lan.roleOwnerTitle,
                  subtitle: context.lan.roleOwnerSubTitle,
                  isSelected: Provider.of<AuthProvider>(context).ownerSelected,
                  onTap: () => Provider.of<AuthProvider>(context, listen: false)
                      .onRoleSelect(false),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSignButton(
        function: () => Provider.of<AuthProvider>(context, listen: false)
            .navigateBasedOnSelection(context),
        text: context.lan.continueBt,
        isdisabledBT: Provider.of<AuthProvider>(context).letDisable(),
      ),
    );
  }
}
