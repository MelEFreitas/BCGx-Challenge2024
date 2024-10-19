import 'package:flutter/material.dart';
import 'package:frontend/presentation/home/widgtes/language_switcher.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String textLanguage;

  const AuthAppBar({super.key, required this.textLanguage});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: const [
        LanguageSwitcherButton(),
      ],
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
