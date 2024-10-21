import 'package:flutter/material.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:frontend/presentation/home/widgtes/dialog_utils.dart';
import 'package:frontend/presentation/home/widgtes/language_switcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: ThemeColors.lightGreen,
      title: SizedBox(height: 56, child: Image.asset('assets/small_clean_logo.png', fit: BoxFit.contain,)),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: ThemeColors.black,),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        PopupMenuButton<String>(
          color: ThemeColors.lightGrey,
          icon: const Icon(Icons.settings, color: ThemeColors.black,),
          onSelected: (value) {
            if (value == 'sign_out') {
              showSignOutDialog(context);
            } else if (value == 'change_role') {
              showChangeRoleDialog(context);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'sign_out',
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(localizations.signOut,
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'change_role',
                child: Row(
                  children: [
                    const Icon(Icons.settings, color: ThemeColors.darkGreen),
                    const SizedBox(width: 8),
                    Text(localizations.changeRole,
                        style: const TextStyle(color: ThemeColors.darkGreen)),
                  ],
                ),
              ),
            ];
          },
        ),
        const LanguageSwitcherButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
